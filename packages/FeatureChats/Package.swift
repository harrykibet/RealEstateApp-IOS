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
        .package(path: "../CoreData")
    ],
    targets: [
        .target(
            name: "FeatureChats",
            dependencies: [
                .product(name: "CoreData", package: "CoreData")
            ]
        ),
        .testTarget(
            name: "FeatureChatsTests",
            dependencies: ["FeatureChats"]
        ),
    ]
)
