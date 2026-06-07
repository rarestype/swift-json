@available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
public protocol ConstructibleFromJSValue {
    static func construct(from value: JSValue) -> Self?
}
@available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
extension ConstructibleFromJSValue where Self: SignedInteger {
    @inlinable public static func construct(from value: JSValue) -> Self? {
        switch value.storage {
        case .number(let value): .init(exactly: value)
        case .bigInt(let value): .init(exactly: value.int128)
        default: nil
        }
    }
}
@available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
extension ConstructibleFromJSValue where Self: UnsignedInteger {
    @inlinable public static func construct(from value: JSValue) -> Self? {
        switch value.storage {
        case .number(let number): Self.init(exactly: number)
        case .bigInt(let bigInt): Self.init(exactly: bigInt.int128)
        default: nil
        }
    }
}
