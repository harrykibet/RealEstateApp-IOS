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
    dependencies: [
        .package(path: "../CoreAppData")
    ],
    targets: [
        .target(
            name: "FeatureMarket",
            dependencies: [
                .product(name: "CoreAppData", package: "CoreAppData")
            ]
        ),
        .testTarget(
            name: "FeatureMarketTests",
            dependencies: ["FeatureMarket"]
        ),
    ]
)
