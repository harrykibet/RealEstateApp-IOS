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
        .package(path: "../CoreData")
    ],
    targets: [
        .target(
            name: "FeatureMarket",
            dependencies: [
                .product(name: "CoreData", package: "CoreData")
            ]
        ),
        .testTarget(
            name: "FeatureMarketTests",
            dependencies: ["FeatureMarket"]
        ),
    ]
)
