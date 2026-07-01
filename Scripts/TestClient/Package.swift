// swift-tools-version: 6.2
import PackageDescription

let package: Package = .init(
    name: "swift-json-test-client",
    products: [
    ],
    targets: [
        .target(
            name: "Consumer",
            dependencies: [
                .target(name: "JSON"),
                .target(name: "JSONAST"),
                .target(name: "JSONDecoding"),
                .target(name: "JSONEncoding"),
                .target(name: "JSONParsing"),
            ]
        ),

        binary(name: "JSON"),
        binary(name: "JSONAST"),
        binary(name: "JSONDecoding"),
        binary(name: "JSONEncoding"),
        binary(name: "JSONParsing"),
    ]
)

func binary(name: String) -> Target {
    return .binaryTarget(name: name, path: "../../.build/xcframeworks_/\(name).xcframework.zip")
}
