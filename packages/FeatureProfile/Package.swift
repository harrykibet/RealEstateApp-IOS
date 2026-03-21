
// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "FeatureProfile",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "FeatureProfile",
            targets: ["FeatureProfile"]
        ),
    ],
    dependencies: [
        .package(path: "../CoreModel")
    ],
    targets: [
        .target(
            name: "FeatureProfile",
            dependencies: [
                .product(name: "CoreModel", package: "CoreModel")
            ]
        ),
        .testTarget(
            name: "FeatureProfileTests",
            dependencies: ["FeatureProfile"]
        ),
    ]
)
