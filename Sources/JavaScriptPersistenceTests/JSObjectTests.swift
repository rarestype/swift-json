import JavaScriptPersistence
import Testing

@Suite struct JSObjectTests {
    @Test static func ArrayPaddingPastEnd() {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
        guard #available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) else {
            return
        }
        #endif

        let array: JSObject = .array()
        array[3] = .number(89)

        #expect(Int.construct(from: array["length"]) == 4)
        #expect(array[0].isUndefined)
        #expect(array[1].isUndefined)
        #expect(array[2].isUndefined)
        #expect(array[3].number == 89)
        #expect(array[4].isUndefined)

        // Appending at endIndex
        array[4] = .string("hello")
        #expect(Int.construct(from: array["length"]) == 5)
        #expect(array[4].string == "hello")

        // Overwriting in-bounds
        array[1] = .boolean(true)
        #expect(Int.construct(from: array["length"]) == 5)
        #expect(array[1].boolean == true)

        // Assigning past end of existing non-empty array
        array[7] = .number(42)
        #expect(Int.construct(from: array["length"]) == 8)
        #expect(array[5].isUndefined)
        #expect(array[6].isUndefined)
        #expect(array[7].number == 42)
    }
}
