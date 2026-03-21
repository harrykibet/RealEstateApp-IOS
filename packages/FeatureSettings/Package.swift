// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "FeatureSettings",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "FeatureSettings",
            targets: ["FeatureSettings"]
        ),
    ],
    targets: [
        .target(
            name: "FeatureSettings"
        ),
        .testTarget(
            name: "FeatureSettingsTests",
            dependencies: ["FeatureSettings"]
        ),
    ]
)
