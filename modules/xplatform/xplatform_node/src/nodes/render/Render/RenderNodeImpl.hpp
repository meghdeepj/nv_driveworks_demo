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

    // SimpleProcessNode
    // dwStatus validate() final;

  private:
    // Passes functions
    dwStatus process();

    // node internal from cgf
    gwRenderNodeParams m_params{};

    // node internal from loaderlite-stm
    dwContextHandle_t m_ctx{ DW_NULL_HANDLE };

    // node internal workload
    // workload: handle

    // workload: config

    // workload: memory
    size_t m_epochCount{ 0 };
    gwGuardianInstruct m_guardian_instruct{};

};

}  // namespace framework
}  // namespace dw

#endif  // RENDER_NODE_IMPL_HPP_
