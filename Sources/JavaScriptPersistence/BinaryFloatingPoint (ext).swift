@available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
extension BinaryFloatingPoint where Self: ConstructibleFromJSValue {
    @inlinable public static func construct(from value: JSValue) -> Self? {
        switch value.storage {
        case .number(let value):
            return Self.init(value)
        case .bigInt(let value):
            return Self.init(exactly: value.int128)
        default:
            return nil
        }
    }
}
