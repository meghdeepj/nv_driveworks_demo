#ifndef PARAMETER_UTILS_TYPES_HPP_
#define PARAMETER_UTILS_TYPES_HPP_

namespace dw
{
namespace framework
{

template <typename Enumeration>
auto as_integer(Enumeration const value) -> typename std::underlying_type<Enumeration>::type
{
    return static_cast<typename std::underlying_type<Enumeration>::type>(value);
}

}  // namespace framework
}  // namespace dw
#endif  // PARAMETER_UTILS_TYPES_HPP_
