// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "FeatureChats",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "FeatureChats",
            targets: ["FeatureChats"]
        ),
    ],
    targets: [
        .target(
            name: "FeatureChats"
        ),
        .testTarget(
            name: "FeatureChatsTests",
            dependencies: ["FeatureChats"]
        ),
    ]
)
