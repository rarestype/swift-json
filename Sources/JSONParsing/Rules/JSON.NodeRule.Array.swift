internal import Grammar

extension JSON.NodeRule {
    /// Matches an array literal.
    ///
    /// Array literals begin and end with square brackets (`[` and `]`), and
    /// recursively contain instances of ``JSON.NodeRule`` separated by ``JSON.CommaRule``s.
    /// Trailing commas (a JSON5 extension) are not allowed.
    enum Array {}
}
extension JSON.NodeRule.Array: ParsingRule {
    typealias Terminal = UInt8

    static func parse<Source>(
        _ input: inout ParsingInput<some ParsingDiagnostics<Source>>
    ) throws(PatternMatchingError) -> [JSON.Node]
        where Source.Element == Terminal, Source.Index == Location {
        try input.parse(as: JSON.BracketLeftRule<Location>.self)

        var elements: [JSON.Node]? = nil
        var json5: Bool = false

        while let next: JSON.Node = input.parse(as: JSON.NodeRule<Location>?.self) {
            if var allocated: [JSON.Node] = consume elements {
                allocated.append(next)
                elements = allocated
            } else {
                elements = [next]
            }

            guard case ()? = input.parse(as: JSON.CommaRule<Location>?.self) else {
                json5 = false
                break
            }

            json5 = true
        }

        _ = json5

        try input.parse(as: JSON.BracketRightRule<Location>.self)
        return elements ?? []
    }
}
