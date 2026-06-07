@available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
@frozen public struct JSString: Equatable {
    @usableFromInline let string: String

    @inlinable public init(_ string: String) {
        self.string = string
    }
}
@available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
extension JSString: ExpressibleByStringLiteral {
    @inlinable public init(stringLiteral: String) {
        self.init(stringLiteral)
    }
}
@available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
extension JSString: CustomStringConvertible, LosslessStringConvertible {
    @inlinable public var description: String { self.string }
}
@available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
extension JSString: ConvertibleToJSValue {
    @inlinable public var jsValue: JSValue { .string(self) }
}
@available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
extension JSString: ConstructibleFromJSValue {
    @inlinable public static func construct(from value: JSValue) -> JSString? {
        guard case .string(let string) = value.storage else {
            return nil
        }
        return string
    }
}
