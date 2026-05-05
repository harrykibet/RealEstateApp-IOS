// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "FeatureChats",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "FeatureChats", targets: ["FeatureChats"]),
    ],
    dependencies: [
        .package(path: "../CoreAppData")
    ],
    targets: [
        .target(
            name: "FeatureChats",
            dependencies: [
                .product(name: "CoreAppData", package: "CoreAppData")
            ]
        ),
        .testTarget(
            name: "FeatureChatsTests",
            dependencies: ["FeatureChats"]
        ),
    ]
)
