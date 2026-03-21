// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "FeatureSearch",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "FeatureSearch",
            targets: ["FeatureSearch"]
        ),
    ],
    targets: [
        .target(
            name: "FeatureSearch"
        ),
        .testTarget(
            name: "FeatureSearchTests",
            dependencies: ["FeatureSearch"]
        ),
    ]
)
