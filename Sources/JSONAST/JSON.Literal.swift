extension JSON {
    @frozen public struct Literal<Value> {
        public var value: Value

        @inlinable public init(_ value: Value) {
            self.value = value
        }
    }
}
extension JSON.Literal: Sendable where Value: Sendable {}
extension JSON.Literal: Equatable where Value: Equatable {}
extension JSON.Literal: Hashable where Value: Hashable {}
extension JSON.Literal where Value: StringProtocol {
    /// Encodes this literal’s string ``value``, with surrounding quotes, to the provided JSON
    /// stream. This function escapes any special characters in the string.
    @inlinable public static func += (json: inout JSON, self: Self) {
        json.utf8.append(0x22) // '"'
        for codeunit: UInt8 in self.value.utf8 {
            if  let code: JSON.EscapeCode = .init(escaping: codeunit) {
                json.utf8 += code
            } else if codeunit < 0x20 {
                json.utf8.append(0x5C) // '\'
                json.utf8.append(0x75) // 'u'
                json.utf8.append(0x30) // '0'
                json.utf8.append(0x30) // '0'
                json.utf8.append(JSON.hex(codeunit >> 4))
                json.utf8.append(JSON.hex(codeunit & 15))
            } else {
                json.utf8.append(codeunit)
            }
        }
        json.utf8.append(0x22) // '"'
    }
}
