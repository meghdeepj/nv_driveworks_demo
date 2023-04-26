#include "TransformNodeImpl.hpp"
#include <dw/core/logger/Logger.hpp>
#include <dwshared/dwfoundation/dw/cuda/misc/Checks.hpp>

#include "gpu.cuh"

namespace dw
{
namespace framework
{

constexpr char gwTransformNodeImpl::LOG_TAG[];

gwTransformNodeImpl::gwTransformNodeImpl(const gwTransformNodeParams& params, const dwContextHandle_t ctx)
    : m_params(params)
    , m_ctx(ctx)
{
    // resolve params
    // m_stream = m_params.cudaStream;
    DW_CHECK_CUDA_ERROR(cudaStreamCreateWithFlags(&m_stream, cudaStreamNonBlocking));
    // if(!m_stream)
    // {
    //     throw Exception(DW_NOT_IMPLEMENTED, "m_stream is NULL!!!!");
    // }

    // Create input/output ports
    NODE_INIT_INPUT_PORT("VALUE_IN"_sv);
    NODE_INIT_OUTPUT_PORT("VALUE_OUT"_sv);

    // Init passes
    NODE_REGISTER_PASS("PROCESS"_sv, [this]() {
        return process();
    });

    DW_LOGD << "gwTransformNodeImpl: created" << Logger::State::endl;
}

///////////////////////////////////////////////////////////////////////////////////////
gwTransformNodeImpl::~gwTransformNodeImpl()
{
    DW_LOGD << "gwTransformNodeImpl: destructed" << Logger::State::endl;
}

// dwStatus gwTransformNodeImpl::validate()
// {
//     dwStatus status = Base::validate();
//     // Check ports are bound
//     if (status == DW_SUCCESS && !NODE_GET_OUTPUT_PORT("VALUE_IN"_sv).isBound())
//     {
//         return DW_NOT_READY;
//     }

//     return status;
// }

///////////////////////////////////////////////////////////////////////////////////////
dwStatus gwTransformNodeImpl::process()
{
    // cuda-kernel-process
    testKernel(m_stream);

    auto& inPort = NODE_GET_INPUT_PORT("VALUE_IN"_sv);
    auto& outPort = NODE_GET_OUTPUT_PORT("VALUE_OUT"_sv);
    if (inPort.isBufferAvailable())
    {
        m_inputValue = *inPort.getBuffer();
        DW_LOGD << "[Epoch " << m_epochCount << "]"
                << " Received " << m_inputValue << " from input VALUE_IN"
                << "!" << Logger::State::endl;
    }
    else
    {
        DW_LOGD << "[Epoch " << m_epochCount << "]"
                << " inPort buffer not available." << Logger::State::endl;
    }
    if (outPort.isBufferAvailable())
    {
        *outPort.getBuffer() = m_inputValue;
        DW_LOGD << "[Epoch " << m_epochCount << "] Sent VALUE_OUT: " << m_inputValue << "." << Logger::State::endl;
        outPort.send();
    }
    else
    {
        DW_LOGD << "[Epoch " << m_epochCount << "]"
                << " outPort buffer not available." << Logger::State::endl;
    }
    ++m_epochCount;
    return DW_SUCCESS;
}

} // namespace framework
} // namespace dw
