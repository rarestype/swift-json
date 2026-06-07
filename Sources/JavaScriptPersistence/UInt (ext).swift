@available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
extension UInt: ConstructibleFromJSValue {}
@available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
extension UInt: ConvertibleToJSValue {
    @inlinable public var jsValue: JSValue {
        if  let double: Double = .init(exactly: self) {
            .number(double)
        } else {
            .bigInt(JSBigInt.init(int128: Int128.init(self)))
        }
    }
}
