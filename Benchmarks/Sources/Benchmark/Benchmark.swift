import ArgumentParser
import JSON
import SystemIO
import System_ArgumentParser

struct Benchmark {
    @Argument(
        help: "path to JSON file to parse",
    ) var input: FilePath
}
@main extension Benchmark: ParsableCommand {
    static var configuration: CommandConfiguration {
        .init(commandName: "benchmark")
    }

    func run() throws {
        // executable has to launch with profiling enabled, disable to avoid recording file IO
        Perf.disable()

        let bytes: [UInt8] = try self.input.read()
        let duration: Duration = try Perf.tour {
            let json: JSON = .init(utf8: bytes[...])
            let root: JSON.Node = try .init(parsing: json)
            Self._blackhole(root)
        }

        print(duration)
    }
}
extension Benchmark {
    @inline(never) private static func _blackhole(_: JSON.Node) {}
}


#if canImport(Glibc)
import Glibc
#elseif canImport(Musl)
import Musl
#endif

@_silgen_name("prctl")
private func prctl(
    _ option: Int32,
    _ arg2: UInt,
    _ arg3: UInt,
    _ arg4: UInt,
    _ arg5: UInt
) -> Int32

/// A Swift-native wrapper for Linux perf event control
public enum Perf {
    private static var PR_TASK_PERF_EVENTS_DISABLE: Int32 { 31 }
    private static var PR_TASK_PERF_EVENTS_ENABLE: Int32 { 32 }

    /// Starts recording hardware/software events to the attached `perf` session.
    public static func enable() {
        let status: Int32 = prctl(PR_TASK_PERF_EVENTS_ENABLE, 0, 0, 0, 0)
        if  status != 0 {
            print("⚠️ WARNING: prctl(ENABLE) failed!")
        } else {
            print("enabled")
        }
    }

    /// Stops recording events.
    public static func disable() {
        let status: Int32 = prctl(PR_TASK_PERF_EVENTS_DISABLE, 0, 0, 0, 0)
        if  status != 0 {
            print("⚠️ WARNING: prctl(DISABLE) failed!")
        } else {
            print("disabled")
        }
    }
}
extension Perf {
    @discardableResult
    public static func tour<E>(_ tour: () throws(E) -> ()) throws(E) -> Duration {
        let (duration, _): (Duration, ()) = try self.tour(tour)
        return duration
    }

    @discardableResult
    public static func tour<T, E>(_ tour: () throws(E) -> T) throws(E) -> (Duration, T) {
        let started: ContinuousClock.Instant = .now
        let success: T
        do {
            self.enable()
            success = try tour()
            self.disable()
        } catch {
            self.disable()
            throw error
        }
        return (.now - started, success)
    }
}
