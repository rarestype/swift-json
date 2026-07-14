internal import Grammar

extension JSON.NodeRule {
    /// Matches an object literal.
    ///
    /// Object literals begin and end with curly braces (`{` and `}`), and
    /// contain instances of ``Item`` separated by ``JSON.CommaRule``s.
    /// In standard JSON, trailing commas are not allowed.
    enum Object {}
}
extension JSON.NodeRule.Object: ParsingRule {
    typealias Terminal = UInt8

    static func parse<Source>(
        _ input: inout ParsingInput<some ParsingDiagnostics<Source>>
    ) throws(PatternMatchingError) -> [(key: JSON.Key, value: JSON.Node)]
        where Source.Index == Location, Source.Element == Terminal {
        try input.parse(as: JSON.BraceLeftRule<Location>.self)

        var items: [(key: JSON.Key, value: JSON.Node)] = []
        var json5: Bool = false

        while case nil = input.parse(as: JSON.BraceRightRule<Location>?.self) {

            items.append(try input.parse(as: Item.self))

            guard case ()? = input.parse(as: JSON.CommaRule<Location>?.self) else {
                // no comma, so it's not JSON5
                try input.parse(as: JSON.BraceRightRule<Location>.self)
                json5 = false
                break
            }

            json5 = true
        }
        _ = json5

        return items
    }
}
