#ifndef CHANNEL_PACKET_TYPES_GEOMETRY_POINT_HPP_
#define CHANNEL_PACKET_TYPES_GEOMETRY_POINT_HPP_

#include <dwcgf/channel/ChannelPacketTypes.hpp>
#include <channel/common/AvEnums.hpp>

#include <dw/core/base/MatrixTypes.h>

typedef dwVector3f Point64;

// here declare node init output port parameters
DWFRAMEWORK_DECLARE_PACKET_TYPE_POD(Point64);

#endif  // CHANNEL_PACKET_TYPES_GEOMETRY_POINT_HPP_
