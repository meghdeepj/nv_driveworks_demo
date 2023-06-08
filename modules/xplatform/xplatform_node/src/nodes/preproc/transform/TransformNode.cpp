#include "TransformNode.hpp"

#include <dwcgf/parameter/ParameterProvider.hpp>

#include "TransformNodeImpl.hpp"

namespace dw {
namespace framework {

std::unique_ptr<gwTransformNode> gwTransformNode::create(ParameterProvider& provider) {
  return dw::framework::create<gwTransformNode>(provider);
}

gwTransformNode::gwTransformNode(const gwTransformNodeParams& params, const dwContextHandle_t ctx)
    : ExceptionSafeProcessNode(std::make_unique<gwTransformNodeImpl>(params, ctx)) {}

}  // namespace framework
}  // namespace dw

#include <dwcgf/node/NodeFactory.hpp>

DW_REGISTER_NODE(dw::framework::gwTransformNode)
