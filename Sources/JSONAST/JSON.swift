/// A container for some UTF-8 encoded JSON source text.
@frozen public struct JSON: Sendable {
    public var utf8: ArraySlice<UInt8>

    @inlinable public init(utf8: ArraySlice<UInt8>) {
        self.utf8 = utf8
    }
}
extension JSON: CustomStringConvertible {
    public var description: String {
        .init(decoding: self.utf8, as: UTF8.self)
    }
}
extension JSON {
    @inline(always) @inlinable static func hex(_ remainder: UInt8) -> UInt8 {
        remainder < 10 ? remainder + 0x30 : remainder + 0x37
    }
}
