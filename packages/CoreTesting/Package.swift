// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "CoreTesting",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "CoreTesting",
            targets: ["CoreTesting"]
        ),
    ],
    targets: [
        .target(
            name: "CoreTesting"
        ),
        .testTarget(
            name: "CoreTestingTests",
            dependencies: ["CoreTesting"]
        ),
    ]
)
