#if !CANEXPOSE_TraceableErrors
internal import TraceableErrors

extension JSON {
    struct DecodingStepError: Error {
        let heading: String
        let underlying: any Error
    }
}
extension JSON.DecodingStepError: TraceableError {
    var notes: [String] { [self.heading] }
}
#endif
