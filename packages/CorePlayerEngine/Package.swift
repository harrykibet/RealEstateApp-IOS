// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "CorePlayerEngine",
    platforms: [
        .iOS(.v18),
        .macOS(.v10_15)
    ],
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
