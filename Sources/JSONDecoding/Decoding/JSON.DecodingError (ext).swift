#if CANEXPOSE_TraceableErrors
public import TraceableErrors
extension JSON.DecodingError: TraceableError {
    /// Returns a single note that says
    /// `"while decoding value for field '_'"`.
    public var notes: [String] { [self.heading] }
}
#else
internal import TraceableErrors

extension JSON.DecodingError: CustomStringConvertible {
    public var description: String { self.step.description }
}
extension JSON.DecodingError {
    private var step: JSON.DecodingStepError {
        if case let next as Self = self.underlying {
            return .init(heading: self.heading, underlying: next.step)
        } else {
            return .init(heading: self.heading, underlying: self.underlying)
        }
    }
}
#endif
