// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "FeatureMarket",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "FeatureMarket",
            targets: ["FeatureMarket"]
        ),
    ],
    targets: [
        .target(
            name: "FeatureMarket"
        ),
        .testTarget(
            name: "FeatureMarketTests",
            dependencies: ["FeatureMarket"]
        ),
    ]
)
