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
    targets: [
        .target(
            name: "FeatureIntelligence"
        ),
        .testTarget(
            name: "FeatureIntelligenceTests",
            dependencies: ["FeatureIntelligence"]
        ),
    ]
)
