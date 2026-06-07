@available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
extension Double: ConstructibleFromJSValue {}
@available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
extension Double: ConvertibleToJSValue {
    @inlinable public var jsValue: JSValue { .number(self) }
}
