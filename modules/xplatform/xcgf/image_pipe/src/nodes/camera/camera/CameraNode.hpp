#ifndef CAMERA_NODE_HPP_
#define CAMERA_NODE_HPP_

#include <string>

// dwmodule
#include <dw/sensors/Sensors.h>
#include <dw/sensors/camera/Camera.h>
// dwcgf framework
#include <dwcgf/channel/Channel.hpp>
#include <dwcgf/node/Node.hpp>
#include <dwcgf/parameter/ParameterDescriptor.hpp>
#include <dwcgf/parameter/SemanticParameterTypes.hpp>
#include <dwcgf/pass/Pass.hpp>
#include <dwcgf/pass/PassDescriptor.hpp>
#include <dwcgf/port/Port.hpp>
#include <dwcgf/port/PortDescriptor.hpp>
// custom dwchannel type
#include "channel/Image.hpp"

// predifined channel type did not work
// #include <dwframework/dwnodes/common/channelpackets/Image.hpp>
// #include <dwframework/dwnodes/common/channelpackets/SelfCalibrationTypes.hpp>
// #include <dwframework/dwnodes/common/channelpackets/SensorCommonTypes.hpp>
// #include <dwframework/dwnodes/common/channelpackets/Sensors.hpp>

namespace dw
{
namespace framework
{

class gwCameraNodeImpl;

struct gwCameraNodeParams
{
    // todo: sal_handle in params
    // todo: const* to fixedstring
    char8_t const* sensorName;
    dw::core::FixedString<64> name;
    // cudaStream_t cudaStream;
    // dwConstRigHandle_t rig;
    // dwSALHandle_t sal;
};

class gwCameraNode : public ExceptionSafeSensorNode
{
  public:
    static constexpr auto describeInputPorts()
    {
        using namespace dw::framework;
        return describePortCollection();
    };
    static constexpr auto describeOutputPorts()
    {
        using namespace dw::framework;
        return describePortCollection(
            DW_DESCRIBE_PORT(dwImageHandle_t, "IMAGE_NATIVE_RAW"_sv),
            DW_DESCRIBE_PORT(int, "VALUE_0"_sv));
    };

    static constexpr auto describePasses()
    {
        return describePassCollection(describePass("SETUP"_sv, DW_PROCESSOR_TYPE_CPU),
                                      describePass("RAW_OUTPUT"_sv, DW_PROCESSOR_TYPE_CPU),
                                      describePass("TEARDOWN"_sv, DW_PROCESSOR_TYPE_CPU));
    }

    dwSensorType getSensorType() const
    {
        return DW_SENSOR_CAMERA;
    }

    static std::unique_ptr<gwCameraNode> create(ParameterProvider& provider);

    static constexpr auto describeParameters()
    {
        // file:///E:/orin_ws/nv_driveworks/driverorks-5.10/doc/nvcgf_html/cgf_tutorials_node.html
        return describeConstructorArguments<gwCameraNodeParams, dwContextHandle_t>(
            describeConstructorArgument(
                DW_DESCRIBE_INDEX_PARAMETER_WITH_SEMANTIC(const char*, semantic_parameter_types::CameraName,
                                                          "cameraIndex"_sv, &gwCameraNodeParams::sensorName),
                DW_DESCRIBE_PARAMETER(dw::core::FixedString<64>, "name"_sv, &gwCameraNodeParams::name)),
            describeConstructorArgument(DW_DESCRIBE_UNNAMED_PARAMETER(dwContextHandle_t)));
    }

    gwCameraNode(const gwCameraNodeParams& params, const dwContextHandle_t ctx);

    // constructors with dwSensorParams
    // gwCameraNode(const dwSensorParams& params, cudaStream_t cudaStream, dwSALHandle_t sal, dwContextHandle_t ctx);
    // gwCameraNode(const char* sensorName, dwConstRigHandle_t rigHandle, dwSALHandle_t sal, dwContextHandle_t ctx,
    //              const FixedString<32>& frameSkipMask);
    // gwCameraNode(const dwSensorParams& params, dwSALHandle_t sal, dwContextHandle_t ctx);
};

}  // namespace framework
}  // namespace dw

#endif  // CAMERA_NODE_HPP_
