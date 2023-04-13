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

    // init workload


    // init input ports

    // init output ports with ref
    // todo: output init
    // dwImageHandle_t ref{};
    // dwImageProperties imageProps{};
    // NODE_INIT_OUTPUT_PORT("IMAGE_NATIVE_RAW"_sv, imageProps);
    // NODE_INIT_OUTPUT_PORT("IMAGE_NATIVE_PROCESSED"_sv);
    // NODE_INIT_OUTPUT_PORT("IMAGE_PROCESSED_RGBA"_sv);
    // NODE_INIT_OUTPUT_PORT("IMAGE_TIMESTAMP"_sv);

    // Init passes
    NODE_REGISTER_PASS("RAW_OUTPUT"_sv, [this]() { return raw_output(); });
    // NODE_REGISTER_PASS("PROCESSED_OUTPUT"_sv, [this]() { return processed_output(); });
    // NODE_REGISTER_PASS("PROCESSED_RGBA_OUTPUT"_sv, [this]() { return processed_rgba_output(); });

    DW_LOGD << "gwCameraNodeImpl: created" << Logger::State::endl;
}

///////////////////////////////////////////////////////////////////////////////////////
gwCameraNodeImpl::~gwCameraNodeImpl()
{
    DW_LOGD << "gwCameraNodeImpl: destructed" << Logger::State::endl;
}

// SimpleSensorNode
dwStatus gwCameraNodeImpl::start()
{
    DW_LOGD << "gwCameraNodeImpl: start: " << Logger::State::endl;
    // throw ExceptionWithStatus(DW_NOT_IMPLEMENTED, "gwCameraNodeImpl::start() not implemented");
    return DW_SUCCESS;
}
dwStatus gwCameraNodeImpl::stop()
{
    DW_LOGD << "gwCameraNodeImpl: stop: " << Logger::State::endl;
    // throw ExceptionWithStatus(DW_NOT_IMPLEMENTED, "gwCameraNodeImpl::stop() not implemented");
    return DW_SUCCESS;
}
dwStatus gwCameraNodeImpl::isVirtual(bool* isVirtual)
{
    *isVirtual = 0;
    DW_LOGD << "gwCameraNodeImpl: isVirtual: " << *isVirtual << Logger::State::endl;
    return DW_SUCCESS;
}
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
    DW_LOGD << "gwCameraNodeImpl: setStartTime: " << "startTime" << Logger::State::endl;
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

dwStatus gwCameraNodeImpl::reset()
{
    DW_LOGD << "gwCameraNodeImpl: reset: " << Logger::State::endl;
    // reset node
    // reset base
    return Base::reset();
}

///////////////////////////////////////////////////////////////////////////////////////
dwStatus gwCameraNodeImpl::raw_output()
{
    // auto& raw_outport = NODE_GET_OUTPUT_PORT("IMAGE_NATIVE_RAW"_sv);
    // if (raw_outport.isBufferAvailable())
    // {
    //     // *outPort0.getBuffer() = m_port0Value++;
    //     DW_LOGD << "[Epoch " << m_epochCount << "] Sent raw_output." << Logger::State::endl;
    //     // outPort0.send();
    // }
    DW_LOGD << "[Epoch " << m_epochCount++ << "] Greetings from gwCameraNodeImpl: Hello "
            << "!" << Logger::State::endl;
    return DW_SUCCESS;
}

}  // namespace framework
}  // namespace dw
