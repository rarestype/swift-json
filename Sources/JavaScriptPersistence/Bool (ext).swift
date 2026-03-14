@available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
extension Bool: ConvertibleToJSValue {
    @inlinable public var jsValue: JSValue { .boolean(self) }
}
@available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
extension Bool: ConstructibleFromJSValue {
    @inlinable public static func construct(from value: JSValue) -> Bool? { value.boolean }
}
