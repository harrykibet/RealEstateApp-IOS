// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "FeatureAuth",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "FeatureAuth", targets: ["FeatureAuth"]),
    ],
    dependencies: [
        .package(path: "../CoreAppData")
    ],
    targets: [
        .target(
            name: "FeatureAuth",
            dependencies: [
                .product(name: "CoreAppData", package: "CoreAppData")
            ],
            path: "Sources/FeatureAuth"
        ),
        .testTarget(
            name: "FeatureAuthTests",
            dependencies: ["FeatureAuth"]
        ),
    ]
)
