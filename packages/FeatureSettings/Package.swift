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
    dependencies: [
        .package(path: "../CoreAppData")
    ],
    targets: [
        .target(
            name: "FeatureSettings",
            dependencies: [
                .product(name: "CoreAppData", package: "CoreAppData")
            ]
        ),
        .testTarget(
            name: "FeatureSettingsTests",
            dependencies: ["FeatureSettings"]
        ),
    ]
)
