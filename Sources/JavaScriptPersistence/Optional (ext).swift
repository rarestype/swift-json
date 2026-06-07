@available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
extension Optional: ConstructibleFromJSValue where Wrapped: ConstructibleFromJSValue {
    @inlinable public static func construct(from value: JSValue) -> Self? {
        switch value.storage {
        case .null, .undefined:
            return .some(nil)
        default:
            guard let wrapped: Wrapped = .construct(from: value) else {
                return nil
            }
            return .some(wrapped)
        }
    }
}
@available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
extension Optional: ConvertibleToJSValue where Wrapped: ConvertibleToJSValue {
    @inlinable public var jsValue: JSValue {
        self?.jsValue ?? .null
    }
}
