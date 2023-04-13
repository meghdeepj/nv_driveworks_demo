#ifndef CHANNEL_PACKET_TYPES_IMAGE_HPP_
#define CHANNEL_PACKET_TYPES_IMAGE_HPP_

#include <dw/image/Image.h>
#include <dwcgf/channel/ChannelPacketTypes.hpp>

// wraps around base framework macro but allows us to avoid boiler plating of dw::framework::DWChannelPacketTypeID
#define DWFRAMEWORK_DECLARE_PACKET_DWTYPE_RELATION(DATA_TYPE, SPECIMEN_TYPE, ENUM_SPEC)                                \
    DWFRAMEWORK_DECLARE_PACKET_TYPE_RELATION(DATA_TYPE, SPECIMEN_TYPE, dw::framework::DWChannelPacketTypeID::ENUM_SPEC)

// here declare node init output port parameters
DWFRAMEWORK_DECLARE_PACKET_DWTYPE_RELATION(dwImageHandle_t, dwImageProperties, DW_IMAGE_HANDLE);
DWFRAMEWORK_DECLARE_PACKET_TYPE_POD(dwImageHandle_t*);

#endif  // CHANNEL_PACKET_TYPES_IMAGE_HPP_