@available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
public final class JSBigInt {
    @usableFromInline let int128: Int128

    @inlinable init(int128: Int128) {
        self.int128 = int128
    }
}
@available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
extension JSBigInt: Equatable {
    @inlinable public static func == (a: JSBigInt, b: JSBigInt) -> Bool {
        a.int128 == b.int128
    }
}
