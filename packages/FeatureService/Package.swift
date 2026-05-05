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
    dependencies: [
        .package(path: "../CoreAppData")
    ],
    targets: [
        .target(
            name: "FeatureService",
            dependencies: [
                .product(name: "CoreAppData", package: "CoreAppData")
            ]
        ),
        .testTarget(
            name: "FeatureServiceTests",
            dependencies: ["FeatureService"]
        ),
    ]
)
