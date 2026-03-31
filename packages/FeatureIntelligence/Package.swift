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
        .package(path: "../CoreData")
    ],
    targets: [
        .target(
            name: "FeatureIntelligence",
            dependencies: [
                .product(name: "CoreData", package: "CoreData")
            ]
        ),
        .testTarget(
            name: "FeatureIntelligenceTests",
            dependencies: ["FeatureIntelligence"]
        ),
    ]
)
