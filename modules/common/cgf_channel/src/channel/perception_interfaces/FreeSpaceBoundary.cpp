#include "FreeSpaceBoundary.hpp"

#include <dwcgf/channel/IChannelPacket.hpp>
#include <dwcgf/channel/ChannelFactory.hpp>

using IChannelPacket = dw::framework::IChannelPacket;
using GenericData = dw::framework::GenericData;
using Exception = dw::core::Exception;

class FreeSpaceBoundaryPacket : public IChannelPacket
{
  public:
    FreeSpaceBoundaryPacket(GenericData specimen)
    {
        auto* size = specimen.getData<size_t>();
        if (size != nullptr)
        {
            m_dataBuffer = std::make_unique<Point64[]>(*size);
            m_packet.data = static_cast<Point64*>(m_dataBuffer.get());
        }
        else
        {
            throw Exception(DW_INVALID_ARGUMENT, "Invalid maximum buffer size.");
        }
        m_maxDataSize = *size;
    }
    GenericData getGenericData() override
    {
        return GenericData(&m_packet);
    }
  protected:
    FreeSpaceBoundary m_packet{};
    std::unique_ptr<Point64[]> m_dataBuffer{};
    size_t m_maxDataSize;
};

namespace
{
struct Proxy
{
    using ChannelPacketConstructor = dw::framework::ChannelPacketConstructor;
    using ChannelPacketConstructorSignature = dw::framework::ChannelPacketConstructorSignature;
    using ChannelFactory = dw::framework::ChannelFactory;

    Proxy()
    {
        m_sigShem = { FreeSpaceBoundaryTypeID, dw::framework::DW_CHANNEL_TYPE_SHMEM_LOCAL };
        // m_sigSocket = { FreeSpaceBoundaryTypeID, dw::framework::DW_CHANNEL_TYPE_SOCKET };
        // m_sigNvSci = { FreeSpaceBoundaryTypeID, dw::framework::DW_CHANNEL_TYPE_NVSCI };

        ChannelFactory::registerPacketConstructor(
            m_sigShem,
            ChannelPacketConstructor([](GenericData ref, dwContextHandle_t context) -> std::unique_ptr<IChannelPacket> {
                static_cast<void>(context);
                return std::make_unique<FreeSpaceBoundaryPacket>(ref);
            }));
        // ChannelFactory::registerPacketConstructor(
        //     m_sigSocket,
        //     ChannelPacketConstructor([](GenericData ref, dwContextHandle_t context) -> std::unique_ptr<IChannelPacket> {
        //         static_cast<void>(context);
        //         return std::make_unique<FreeSpaceBoundarySocketPacket>(ref);
        //     }));
        // ChannelFactory::registerPacketConstructor(
        //     m_sigNvSci,
        //     ChannelPacketConstructor([](GenericData ref, dwContextHandle_t context) -> std::unique_ptr<IChannelPacket> {
        //         static_cast<void>(context);
        //         return std::make_unique<FreeSpaceBoundaryNvSciPacket>(ref);
        //     }));
    }
    ~Proxy()
    {
        ChannelFactory::unregisterPacketConstructor(m_sigShem);
        // ChannelFactory::unregisterPacketConstructor(m_sigSocket);
        // ChannelFactory::unregisterPacketConstructor(m_sigNvSci);
    }

  private:
    ChannelPacketConstructorSignature m_sigShem;
    // ChannelPacketConstructorSignature m_sigSocket;
    // ChannelPacketConstructorSignature m_sigNvSci;
};
static Proxy g_registerPacketConstructors;
}  // namespace