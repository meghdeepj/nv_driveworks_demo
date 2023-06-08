#ifndef PARAMETER_PREPROC_TYPES_HPP_
#define PARAMETER_PREPROC_TYPES_HPP_

#include <dwcgf/enum/EnumDescriptor.hpp>
#include <dw/core/base/Types.h>
#include <dw/sensors/Sensors.h>
#include <dw/image/Image.h>

#include "Utils.hpp"

namespace dw
{
namespace framework
{

enum class gwPreprocMode
{
    GW_PREPROC_DW = 0,         // Driveworks
    GW_PREPROC_DO = 1,         // Driveos
    GW_PREPROC_CUSTOM = 2,     // custom
    GW_PREPROC_INVALID = 0xFF  // invalid
};

template <>
struct EnumDescription<gwPreprocMode>
{
    static constexpr auto get()
    {
        using EnumT = gwPreprocMode;
        return describeEnumeratorCollection<EnumT>(
            DW_DESCRIBE_ENUMERATOR(GW_PREPROC_DW), DW_DESCRIBE_ENUMERATOR(GW_PREPROC_DO),
            DW_DESCRIBE_ENUMERATOR(GW_PREPROC_CUSTOM), DW_DESCRIBE_ENUMERATOR(GW_PREPROC_INVALID));
    }
};

}  // namespace framework
}  // namespace dw
#endif  // PARAMETER_PREPROC_TYPES_HPP_
