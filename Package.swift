// swift-tools-version:6.2
import class Foundation.ProcessInfo
import PackageDescription

let package: Package = .init(
    name: "swift-json",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .visionOS(.v1)],
    products: [
        .library(name: "JQ", targets: ["JQ"]),
        .library(name: "JSON", targets: ["JSON"]),
        .library(name: "JSONAST", targets: ["JSONAST"]),
        .library(name: "JSONLegacy", targets: ["JSONLegacy"]),

        .library(name: "_JSON_SnippetsAnchor", targets: ["_JSON_SnippetsAnchor"]),
    ],
    traits: [
        .trait(name: "_ExperimentalJQ"),
    ],
    dependencies: [
        .package(url: "https://github.com/ordo-one/dollup", from: "1.0.1"),
        .package(url: "https://github.com/rarestype/gram", from: "2.0.0"),
    ],
    targets: [
        .target(name: "JSONAST"),

        .target(
            name: "JSONDecoding",
            dependencies: [
                .target(name: "JSONAST"),
                .product(name: "Grammar", package: "gram"),
            ]
        ),

        .target(
            name: "JSONEncoding",
            dependencies: [
                .target(name: "JSONAST"),
            ]
        ),

        .target(
            name: "JSONLegacy",
            dependencies: [
                .target(name: "JSONDecoding"),
            ]
        ),

        .target(
            name: "JSONParsing",
            dependencies: [
                .target(name: "JSONAST"),
                .product(name: "Grammar", package: "gram"),
            ]
        ),

        .target(
            name: "JSON",
            dependencies: [
                .target(name: "JSONDecoding"),
                .target(name: "JSONEncoding"),
                .target(name: "JSONParsing"),
            ]
        ),

        .target(
            name: "JQ",
            dependencies: [
                .target(name: "JSONAST"),
            ]
        ),

        .testTarget(
            name: "JSONTests",
            dependencies: [
                .target(name: "JSON"),
            ]
        ),
        .testTarget(
            name: "JQTests",
            dependencies: [
                .target(name: "JSON"),
                .target(name: "JQ"),
            ]
        ),


        .target(
            name: "_JSON_SnippetsAnchor",
            dependencies: [
                .target(name: "JSON"),
            ],
            path: "Snippets/_Anchor",
            linkerSettings: [
                .linkedLibrary("m"),
            ],
        ),
    ]
)

var WarningsAsErrors: Bool {
    switch ProcessInfo.processInfo.environment["WARNINGS_AS_ERRORS"] {
    case "true"?: true
    case "1"?: true
    default: false
    }
}
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

        if  WarningsAsErrors {
            settings.append(.treatWarning("ExistentialAny", as: .error))
            settings.append(.treatWarning("MutableGlobalVariable", as: .error))
        }

        $0 = settings
    } (&$0.swiftSettings)
    return $0
}
