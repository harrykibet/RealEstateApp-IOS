// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "FeatureAuth",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "FeatureAuth",
            targets: ["FeatureAuth"]
        ),
    ],
    targets: [
        .target(
            name: "FeatureAuth",
            path: "Sources/FeatureAuth"
        ),
        .testTarget(
            name: "FeatureAuthTests",
            dependencies: ["FeatureAuth"]
        ),
    ]
)
