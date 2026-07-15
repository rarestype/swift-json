import JSON
import Testing

@Suite enum Rendering {
    @Test static func StringNewline() throws {
        let expected: JSON.Node = "\n"
        #expect("\(expected)" == "\"\\n\"")
        #expect("\(expected)" == "\(try JSON.Node.init(parsingFragment: "\(expected)"))")
    }

    @Test static func StringControlCharacters() throws {
        let expected: JSON.Node = "\u{10}"
        #expect("\(expected)" == "\"\\u0010\"")
        #expect("\(expected)" == "\(try JSON.Node.init(parsingFragment: "\(expected)"))")
    }
}
