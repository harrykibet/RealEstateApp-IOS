// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "FeatureComments",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "FeatureComments",
            targets: ["FeatureComments"]
        ),
    ],
    targets: [
        .target(
            name: "FeatureComments"
        ),
        .testTarget(
            name: "FeatureCommentsTests",
            dependencies: ["FeatureComments"]
        ),
    ]
)
