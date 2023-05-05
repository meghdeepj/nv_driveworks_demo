#include "CameraNodeImpl.hpp"
#include <dw/core/logger/Logger.hpp>

namespace dw
{
namespace framework
{

constexpr char gwCameraNodeImpl::LOG_TAG[];

gwCameraNodeImpl::gwCameraNodeImpl(const gwCameraNodeParams& params, const dwContextHandle_t ctx)
  : m_params(params), m_ctx(ctx)
{
    // resolve params
    DW_LOGD << "gwCameraNodeImpl: cameraIndex is: " << m_params.cameraIndex << "." << Logger::State::endl;
    DW_LOGD << "gwCameraNodeImpl: cameraType is: " << as_integer(m_params.cameraType) << "." << Logger::State::endl;
    DW_LOGD << "gwCameraNodeImpl: cameraParameter is: " << m_params.cameraParameter.c_str() << "." << Logger::State::endl;
    DW_LOGD << "gwCameraNodeImpl: cameraProtocol is: " << m_params.cameraProtocol.c_str() << "." << Logger::State::endl;
    DW_LOGD << "gwCameraNodeImpl: cameraIntrinsics is: " << m_params.cameraIntrinsics.c_str() << "." << Logger::State::endl;
    // init workload
    // todo: need a app framework
    FRWK_CHECK_DW_ERROR(dwSAL_initialize(&m_sal, m_ctx));
    // interface=csi-ab/ef,link=0,1,2,3
    m_camera_param.parameters = m_params.cameraParameter.c_str();
    m_camera_param.protocol = m_params.cameraProtocol.c_str();
    FRWK_CHECK_DW_ERROR(dwSAL_createSensor(&m_camera, m_camera_param, m_sal));
    FRWK_CHECK_DW_ERROR(dwSAL_start(m_sal));

    // init input ports

    // check config
    dwImageProperties imageProps{};
    if(m_params.cameraType == gwCameraType::GW_CAMERA_RAW)
    {
        DW_LOGD << "gwCameraNodeImpl: cameraType is: GW_CAMERA_RAW." << Logger::State::endl;
        // 通过Orin的ISP后处理出YUV，例如shunyu和virtual_camera
        m_image_type = DW_CAMERA_OUTPUT_NATIVE_PROCESSED;
    }
    if (m_params.cameraType == gwCameraType::GW_CAMERA_YUV)
    {
        DW_LOGD << "gwCameraNodeImpl: cameraType is: GW_CAMERA_YUV." << Logger::State::endl;
        // 通过相机ISP直接出YUV，例如senyun
        m_image_type = DW_CAMERA_OUTPUT_NATIVE_RAW;
    }
    // 输出的图片属性是统一的
    imageProps.width = 1920;
    imageProps.height = 1536;
    imageProps.type = DW_IMAGE_NVMEDIA;
    imageProps.memoryLayout = DW_IMAGE_MEMORY_TYPE_PITCH;
    imageProps.format = DW_IMAGE_FORMAT_YUV420_UINT8_SEMIPLANAR;
    FRWK_CHECK_DW_ERROR(dwImage_create(&m_image_yuv, imageProps, m_ctx));

    // init output ports with ref
    NODE_INIT_OUTPUT_PORT("IMAGE_PROCESSED_YUV"_sv, imageProps);
    NODE_INIT_OUTPUT_PORT("IMAGE_TIMESTAMP"_sv);
    NODE_INIT_OUTPUT_PORT("VALUE_0"_sv);
    NODE_INIT_OUTPUT_PORT("GUARDIAN_INSTRUCT"_sv);

    // Init passes
    NODE_REGISTER_PASS("PROCESSED_OUTPUT"_sv, [this]() { return yuv_output(); });

    DW_LOGD << "gwCameraNodeImpl: created" << Logger::State::endl;
}

///////////////////////////////////////////////////////////////////////////////////////
gwCameraNodeImpl::~gwCameraNodeImpl()
{
    // release workload
    if(m_camera)
    {
        dwSAL_releaseSensor(m_camera);
    }
    if(m_sal)
    {
        dwSAL_release(m_sal);
    }
    DW_LOGD << "gwCameraNodeImpl: destructed" << Logger::State::endl;
}

// SimpleSensorNode
dwStatus gwCameraNodeImpl::start()
{
    DW_LOGD << "gwCameraNodeImpl: start: " << Logger::State::endl;
    FRWK_CHECK_DW_ERROR(dwSensor_start(m_camera));
    // throw ExceptionWithStatus(DW_NOT_IMPLEMENTED, "gwCameraNodeImpl::start() not implemented");
    return DW_SUCCESS;
}
dwStatus gwCameraNodeImpl::stop()
{
    DW_LOGD << "gwCameraNodeImpl: stop: " << Logger::State::endl;
    FRWK_CHECK_DW_ERROR(dwSensor_stop(m_camera));
    // throw ExceptionWithStatus(DW_NOT_IMPLEMENTED, "gwCameraNodeImpl::stop() not implemented");
    return DW_SUCCESS;
}
dwStatus gwCameraNodeImpl::isVirtual(bool* isVirtual)
{
    *isVirtual = 0;
    DW_LOGD << "gwCameraNodeImpl: isVirtual: " << *isVirtual << Logger::State::endl;
    return DW_SUCCESS;
}
dwStatus gwCameraNodeImpl::validate()
{
    dwStatus status = Base::validate();
    // Check ports are bound
    // && (!NODE_GET_OUTPUT_PORT("IMAGE_FOVEAL"_sv).isBound() || !NODE_GET_OUTPUT_PORT("FOVEAL_SIGNAL"_sv).isBound()))
    if (status == DW_SUCCESS && !NODE_GET_OUTPUT_PORT("VALUE_0"_sv).isBound())
    {
        return DW_NOT_READY;
    }
    return status;
}

dwStatus gwCameraNodeImpl::reset()
{
    DW_LOGD << "gwCameraNodeImpl: reset: " << Logger::State::endl;
    // reset node
    FRWK_CHECK_DW_ERROR(dwSAL_reset(m_sal));
    FRWK_CHECK_DW_ERROR(dwSensor_reset(m_camera));
    // reset base
    return Base::reset();
}

///////////////////////////////////////////////////////////////////////////////////////
dwStatus gwCameraNodeImpl::yuv_output()
{
    // get port status
    auto& yuv_outport = NODE_GET_OUTPUT_PORT("IMAGE_PROCESSED_YUV"_sv);
    auto& outPort0 = NODE_GET_OUTPUT_PORT("VALUE_0"_sv);
    auto& gi_oport = NODE_GET_OUTPUT_PORT("GUARDIAN_INSTRUCT"_sv);
    if (!outPort0.isBufferAvailable())
    {
        DW_LOGD << "outPort0.buffer not available." << Logger::State::endl;
    }
    else
    {
        *outPort0.getBuffer() = m_epochCount;
        DW_LOGD << "[Epoch " << m_epochCount << "] Sent VALUE_0: " << m_epochCount << "." << Logger::State::endl;
        outPort0.send();
    }
    if (!gi_oport.isBufferAvailable())
    {
        DW_LOGD << "[Epoch " << m_epochCount << "] gi_oport.buffer not available." << Logger::State::endl;
    }
    else
    {
        m_guardian_instruct.instruct = gwInstruct::STANDBY;
        FRWK_CHECK_DW_ERROR(dwContext_getCurrentTime(&m_guardian_instruct.timestamp_us, m_ctx));
        *gi_oport.getBuffer() = m_guardian_instruct;
        DW_LOGD << "[Epoch " << m_epochCount << "] Sent GUARDIAN_INSTRUCT: "
                << " timestamp_us: " << m_guardian_instruct.timestamp_us
                << " instruct: " << m_guardian_instruct.instruct << "." << Logger::State::endl;
        gi_oport.send();
    }
    if (!yuv_outport.isBufferAvailable())
    {
        DW_LOGD << "[Epoch " << m_epochCount << "] yuv_outport.buffer not available." << Logger::State::endl;
        return DW_SUCCESS;
    }
    else
    {
        DW_LOGD << "[Epoch " << m_epochCount << "] yuv_outport.buffer is available." << Logger::State::endl;
    }

    // get data and send
    // readframe and getimage
    dwStatus status = DW_NOT_READY;
    uint32_t countFailure = 0;
    while ((status == DW_NOT_READY) || (status == DW_END_OF_STREAM))
    {
        status = dwSensorCamera_readFrame(&m_camera_frame, 333333, m_camera);
        countFailure++;
        if (countFailure == 1000000)
        {
            DW_LOGD << "Camera doesn't seem responsive, exit loop and stopping the sample" << Logger::State::endl;
            break;
        }
        // Reset the sensor to support loopback
        if (status == DW_END_OF_STREAM)
        {
            dwSensor_reset(m_camera);
            DW_LOGD << "Video reached end of stream" << Logger::State::endl;
        }
    }

    if (status == DW_TIME_OUT)
    {
        throw ExceptionWithStatus(DW_TIME_OUT, "gwCameraNodeImpl::yuv_output Timeout waiting for camera");
    }

    // get native image Only native processed ISP1/2 outputs(not cuda) are available for now
    FRWK_CHECK_DW_ERROR(dwSensorCamera_getImage(&m_image_yuv, m_image_type, m_camera_frame));
    // check prop
    dwImageProperties imgProperties{};
    FRWK_CHECK_DW_ERROR(dwSensorCamera_getImageProperties(&imgProperties, m_image_type, m_camera));
    DW_LOGD << "gwCameraNodeImpl::yuv_output() get imageProp: "
            << "width: " << imgProperties.width << " height: " << imgProperties.height
            << " type: " << imgProperties.type << " memoryLayout: " << imgProperties.memoryLayout
            << " format: " << imgProperties.format << "." << Logger::State::endl;
    // get isp image

    // write outputport
    *yuv_outport.getBuffer() = m_image_yuv;
    DW_LOGD << "[Epoch " << m_epochCount << "] Sent yuv_output." << Logger::State::endl;
    yuv_outport.send();

    // return frame
    FRWK_CHECK_DW_ERROR(dwSensorCamera_returnFrame(&m_camera_frame));
    DW_LOGD << "[Epoch " << m_epochCount++ << "] Greetings from gwCameraNodeImpl: Hello "
            << "!" << Logger::State::endl;
    return DW_SUCCESS;
}

///////////////////////////////////////////////////////////////////////////////////////
dwStatus gwCameraNodeImpl::setDataEventReadCallback(DataEventReadCallback)
{
    DW_LOGD << "gwCameraNodeImpl: setDataEventReadCallback: " << Logger::State::endl;
    throw ExceptionWithStatus(DW_NOT_IMPLEMENTED, "gwCameraNodeImpl::setDataEventReadCallback() not implemented");
    return DW_SUCCESS;
}
dwStatus gwCameraNodeImpl::setDataEventWriteCallback(DataEventWriteCallback)
{
    DW_LOGD << "gwCameraNodeImpl: setDataEventWriteCallback: " << Logger::State::endl;
    throw ExceptionWithStatus(DW_NOT_IMPLEMENTED, "gwCameraNodeImpl::setDataEventWriteCallback() not implemented");
    return DW_SUCCESS;
}
// ISensorNode
dwStatus gwCameraNodeImpl::setAffinityMask(uint affinityMask)
{
    DW_LOGD << "gwCameraNodeImpl: setAffinityMask: " << affinityMask << Logger::State::endl;
    throw ExceptionWithStatus(DW_NOT_IMPLEMENTED, "gwCameraNodeImpl::setAffinityMask Not implemented");
    return DW_SUCCESS;
}
dwStatus gwCameraNodeImpl::setThreadPriority(int threadPriority)
{
    DW_LOGD << "gwCameraNodeImpl: setThreadPriority: " << threadPriority << Logger::State::endl;
    throw ExceptionWithStatus(DW_NOT_IMPLEMENTED, "gwCameraNodeImpl::setThreadPriority Not implemented");
    return DW_SUCCESS;
}
dwStatus gwCameraNodeImpl::setStartTime(dwTime_t startTime)
{
    DW_LOGD << "gwCameraNodeImpl: setStartTime: "
            << "startTime" << Logger::State::endl;
    throw ExceptionWithStatus(DW_NOT_IMPLEMENTED, " gwCameraNodeImpl::setStartTime Not implemented");
    return DW_SUCCESS;
}
dwStatus gwCameraNodeImpl::setEndTime(dwTime_t endTime)
{
    DW_LOGD << "gwCameraNodeImpl: setEndTime: "
            << "endTime" << Logger::State::endl;
    throw ExceptionWithStatus(DW_NOT_IMPLEMENTED, " gwCameraNodeImpl::setEndTime Not implemented");
    return DW_SUCCESS;
}
dwStatus gwCameraNodeImpl::setLockstepDeterministicMode(bool enable)
{
    DW_LOGD << "gwCameraNodeImpl: setLockstepDeterministicMode: " << enable << Logger::State::endl;
    throw ExceptionWithStatus(DW_NOT_IMPLEMENTED, "gwCameraNodeImpl::setLockstepDeterministicMode Not implemented");
    return DW_SUCCESS;
}
dwStatus gwCameraNodeImpl::getNextTimestamp(dwTime_t& nextTimestamp)
{
    DW_LOGD << "gwCameraNodeImpl: getNextTimestamp: "
            << "nextTimestamp" << Logger::State::endl;
    throw ExceptionWithStatus(DW_NOT_IMPLEMENTED, "gwCameraNodeImpl::getNextTimestamp Not implemented");
    return DW_SUCCESS;
}

}  // namespace framework
}  // namespace dw
