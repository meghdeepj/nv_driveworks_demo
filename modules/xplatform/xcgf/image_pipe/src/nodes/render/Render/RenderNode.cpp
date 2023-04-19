#include "RenderNode.hpp"

#include <dwcgf/parameter/ParameterProvider.hpp>

#include "RenderNodeImpl.hpp"

namespace dw {
namespace framework {

std::unique_ptr<gwRenderNode> gwRenderNode::create(ParameterProvider& provider) {
  return dw::framework::create<gwRenderNode>(provider);
}

gwRenderNode::gwRenderNode(const gwRenderNodeParams& params, const dwContextHandle_t ctx)
    : ExceptionSafeProcessNode(std::make_unique<gwRenderNodeImpl>(params, ctx)) {}

}  // namespace framework
}  // namespace dw

#include <dwcgf/node/NodeFactory.hpp>

DW_REGISTER_NODE(dw::framework::gwRenderNode)
