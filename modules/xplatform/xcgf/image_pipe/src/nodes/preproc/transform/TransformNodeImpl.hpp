#ifndef TRANSFORM_NODE_IMPL_HPP_
#define TRANSFORM_NODE_IMPL_HPP_

#include "TransformNode.hpp"
#include <dwcgf/node/SimpleNodeT.hpp>

namespace dw
{
namespace framework
{

class gwTransformNodeImpl : public SimpleProcessNodeT<gwTransformNode>
{
  public:
    static constexpr char LOG_TAG[] = "gwTransformNode";

    // Initialization and destruction
    gwTransformNodeImpl(const gwTransformNodeParams& params, const dwContextHandle_t ctx);
    ~gwTransformNodeImpl() override;

    // SimpleProcessNode
    // dwStatus validate() final;

  private:
    // Passes functions
    dwStatus process();

    // node internal from cgf
    gwTransformNodeParams m_params{};

    // node internal from loaderlite-stm
    dwContextHandle_t m_ctx{ DW_NULL_HANDLE };

    // node internal workload
    // workload: handle

    // workload: config
    cudaStream_t m_stream{ DW_NULL_HANDLE };
    // workload: memory
    size_t m_epochCount{ 0 };
    size_t m_inputValue{ 0 };
    gwGuardianInstruct m_guardian_instruct{};

};

}  // namespace framework
}  // namespace dw

#endif  // TRANSFORM_NODE_IMPL_HPP_
