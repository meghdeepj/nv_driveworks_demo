#include "RenderNodeImpl.hpp"
#include <dw/core/logger/Logger.hpp>

namespace dw
{
namespace framework
{

constexpr char gwRenderNodeImpl::LOG_TAG[];

gwRenderNodeImpl::gwRenderNodeImpl(const gwRenderNodeParams& params, const dwContextHandle_t ctx)
    : m_params(params)
    , m_ctx(ctx)
{
    // Create input/output ports
    NODE_INIT_INPUT_PORT("VALUE_0"_sv);

    // Init passes
    NODE_REGISTER_PASS("PROCESS"_sv, [this]() {
        return process();
    });

    DW_LOGD << "gwRenderNodeImpl: created" << Logger::State::endl;
}

///////////////////////////////////////////////////////////////////////////////////////
gwRenderNodeImpl::~gwRenderNodeImpl()
{
    DW_LOGD << "gwRenderNodeImpl: destructed" << Logger::State::endl;
}

// dwStatus gwRenderNodeImpl::validate()
// {
//     dwStatus status = Base::validate();
//     // Check ports are bound
//     if (status == DW_SUCCESS && !NODE_GET_OUTPUT_PORT("VALUE_0"_sv).isBound())
//     {
//         return DW_NOT_READY;
//     }

//     return status;
// }

///////////////////////////////////////////////////////////////////////////////////////
dwStatus gwRenderNodeImpl::process()
{
    auto& inPort0 = NODE_GET_INPUT_PORT("VALUE_0"_sv);
    if (inPort0.isBufferAvailable())
    {
        auto inputValue0 = *inPort0.getBuffer();
        DW_LOGD << "[Epoch " << m_epochCount << "]"
                << " Received " << inputValue0 << " from input VALUE_0"
                << "!" << Logger::State::endl;
    }
    else
    {
        DW_LOGD << "[Epoch " << m_epochCount << "]"
                << " inPort0 buffer not available." << Logger::State::endl;
    }

    ++m_epochCount;
    return DW_SUCCESS;
}

} // namespace framework
} // namespace dw
