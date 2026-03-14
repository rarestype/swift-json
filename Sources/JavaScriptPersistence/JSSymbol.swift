@available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
public final class JSSymbol {
    public let name: String?

    @inlinable init(name: String?) {
        self.name = name
    }
}
