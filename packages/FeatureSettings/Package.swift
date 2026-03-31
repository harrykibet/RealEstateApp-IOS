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
        .package(path: "../CoreData")
    ],
    targets: [
        .target(
            name: "FeatureSettings",
            dependencies: [
                .product(name: "CoreData", package: "CoreData")
            ]
        ),
        .testTarget(
            name: "FeatureSettingsTests",
            dependencies: ["FeatureSettings"]
        ),
    ]
)
