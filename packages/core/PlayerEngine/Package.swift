// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "CorePlayerEngine",
    products: [
        .library(
            name: "CorePlayerEngine",
            targets: ["CorePlayerEngine"]
        ),
    ],
    targets: [
        .target(
            name: "CorePlayerEngine"
        ),
        .testTarget(
            name: "CorePlayerEngineTests",
            dependencies: ["CorePlayerEngine"]
        ),
    ]
)
