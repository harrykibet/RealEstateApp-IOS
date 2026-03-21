// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "FeatureService",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "FeatureService",
            targets: ["FeatureService"]
        ),
    ],
    targets: [
        .target(
            name: "FeatureService"
        ),
        .testTarget(
            name: "FeatureServiceTests",
            dependencies: ["FeatureService"]
        ),
    ]
)
