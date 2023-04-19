#ifndef RENDER_NODE_IMPL_HPP_
#define RENDER_NODE_IMPL_HPP_

#include "RenderNode.hpp"
#include <dwcgf/node/SimpleNodeT.hpp>

namespace dw
{
namespace framework
{

class gwRenderNodeImpl : public SimpleProcessNodeT<gwRenderNode>
{
public:
    static constexpr char LOG_TAG[] = "gwRenderNode";

    // Initialization and destruction
    gwRenderNodeImpl(const gwRenderNodeParams& params, const dwContextHandle_t ctx);
    ~gwRenderNodeImpl() override;

private:
    // Passes functions
    dwStatus process();

    // SimpleProcessNode
    // dwStatus validate() final;

    // Internal states of node
    size_t m_epochCount{0};
    gwRenderNodeParams m_params{};
    dwContextHandle_t m_ctx{DW_NULL_HANDLE};
};

} // namespace framework
} // namespace dw

#endif // RENDER_NODE_IMPL_HPP_
