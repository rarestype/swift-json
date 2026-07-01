#if !CANEXPOSE_TraceableErrors
protocol DecodingErrorProtocol {
    var step: JSON.DecodingStepError { get }
}
#endif
