#ifndef PARAMETER_CAMERA_TYPES_HPP_
#define PARAMETER_CAMERA_TYPES_HPP_

#include <dwcgf/enum/EnumDescriptor.hpp>
#include <dw/core/base/Types.h>
#include <dw/sensors/Sensors.h>
#include <dw/image/Image.h>

#include "Utils.hpp"

namespace dw
{
namespace framework
{

enum class gwCameraType
{
    GW_CAMERA_RAW = 0,        // 通过Orin的ISP后处理出YUV，例如shunyu和virtual_camera
    GW_CAMERA_YUV = 1,        // 通过相机ISP直接出YUV，例如senyun
    GW_CAMERA_INVALID = 0xFF  // invalid
};

template <>
struct EnumDescription<gwCameraType>
{
    static constexpr auto get()
    {
        using EnumT = gwCameraType;
        return describeEnumeratorCollection<EnumT>(DW_DESCRIBE_ENUMERATOR(GW_CAMERA_RAW),
                                                   DW_DESCRIBE_ENUMERATOR(GW_CAMERA_YUV),
                                                   DW_DESCRIBE_ENUMERATOR(GW_CAMERA_INVALID));
    }
};

}  // namespace framework
}  // namespace dw
#endif  // PARAMETER_CAMERA_TYPES_HPP_
