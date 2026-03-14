@available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
extension JSValue {
    @frozen @usableFromInline enum Storage {
        case boolean(Bool)
        case string(JSString)
        case number(Double)
        case object(JSObject)
        case null
        case undefined
        case symbol(JSSymbol)
        case bigInt(JSBigInt)
    }
}
