// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "FeatureComments",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "FeatureComments", targets: ["FeatureComments"]),
    ],
    dependencies: [
        .package(path: "../CoreAppData")
    ],
    targets: [
        .target(
            name: "FeatureComments",
            dependencies: [
                .product(name: "CoreAppData", package: "CoreAppData")
            ]
        ),
        .testTarget(
            name: "FeatureCommentsTests",
            dependencies: ["FeatureComments"]
        ),
    ]
)
