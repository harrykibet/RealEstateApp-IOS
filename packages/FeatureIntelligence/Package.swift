// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "FeatureIntelligence",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "FeatureIntelligence",
            targets: ["FeatureIntelligence"]
        ),
    ],
    dependencies: [
        .package(path: "../CoreAppData")
    ],
    targets: [
        .target(
            name: "FeatureIntelligence",
            dependencies: [
                .product(name: "CoreAppData", package: "CoreAppData")
            ]
        ),
        .testTarget(
            name: "FeatureIntelligenceTests",
            dependencies: ["FeatureIntelligence"]
        ),
    ]
)
