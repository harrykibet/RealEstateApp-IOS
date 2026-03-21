// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "FeatureHome",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "FeatureHome",
            targets: ["FeatureHome"]
        ),
    ],
    targets: [
        .target(
            name: "FeatureHome"
        ),
        .testTarget(
            name: "FeatureHomeTests",
            dependencies: ["FeatureHome"]
        ),
    ]
)
