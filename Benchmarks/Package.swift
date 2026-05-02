// swift-tools-version:6.2
import PackageDescription

let package: Package = .init(
    name: "swift-json-benchmarks",
    platforms: [.macOS(.v15), .iOS(.v18), .tvOS(.v18), .watchOS(.v11), .visionOS(.v2)],
    products: [
        .executable(name: "benchmark", targets: ["Benchmark"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ordo-one/dollup", from: "1.0.1"),
        .package(url: "https://github.com/rarestype/swift-io", from: "3.0.0"),
        .package(path: ".."),
    ],
    targets: [
        .executableTarget(
            name: "Benchmark",
            dependencies: [
                .product(name: "JSON", package: "swift-json"),
                .product(name: "SystemIO", package: "swift-io"),
                .product(name: "System_ArgumentParser", package: "swift-io"),
            ]
        ),
    ]
)

package.targets = package.targets.map {
    switch $0.type {
    case .plugin: return $0
    case .binary: return $0
    default: break
    }
    {
        var settings: [SwiftSetting] = $0 ?? []

        settings.append(.enableUpcomingFeature("ExistentialAny"))
        settings.append(.enableUpcomingFeature("InternalImportsByDefault"))

        settings.append(.treatWarning("ExistentialAny", as: .error))
        settings.append(.treatWarning("MutableGlobalVariable", as: .error))

        $0 = settings
    } (&$0.swiftSettings)
    return $0
}
