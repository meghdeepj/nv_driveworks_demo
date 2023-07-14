#ifndef CHANNEL_PACKET_TYPES_SAMPLE_FREESPACE_BOUNDARY_HPP
#define CHANNEL_PACKET_TYPES_SAMPLE_FREESPACE_BOUNDARY_HPP

#include <dw/core/base/Types.h>
#include <dwcgf/channel/ChannelPacketTypes.hpp>
#include <channel/common/TypesExt.hpp>
#include <channel/common/AvEnums.hpp>
#include <channel/geometry_msgs/Point.hpp>

struct FreeSpaceBoundary
{
    dwTime_t timestamp;
    // if there is no capacity, then capacity is the same as size
    size_t size;
    Point64* data;
};

constexpr dw::framework::ChannelPacketTypeID FreeSpaceBoundaryTypeID =
    dw::framework::dwSerializationTypeExt::DW_FREESPACE_BOUNDARY;

DWFRAMEWORK_DECLARE_PACKET_TYPE_RELATION(FreeSpaceBoundary, size_t, FreeSpaceBoundaryTypeID);

// for dwChannel_test only
template <typename PacketT>
struct TypeCallbacks;
template <>
struct TypeCallbacks<FreeSpaceBoundary>
{
    static size_t getSpecimen()
    {
        size_t size = 256;
        return size;
    }

    static size_t getSize()
    {
        return sizeof(FreeSpaceBoundary);
    }

    static dwTime_t getTimestamp(FreeSpaceBoundary& data)
    {
        return data.timestamp;
    }

    static void setTimestamp(FreeSpaceBoundary& data, dwTime_t time)
    {
        data.timestamp = time;
    }
};

#endif  // CHANNEL_PACKET_TYPES_SAMPLE_FREESPACE_BOUNDARY_HPP