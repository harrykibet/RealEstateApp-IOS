// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "FeatureSearch",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "FeatureSearch", targets: ["FeatureSearch"]),
    ],
    dependencies: [
        .package(path: "../CoreData")
    ],
    targets: [
        .target(
            name: "FeatureSearch",
            dependencies: [
                .product(name: "CoreData", package: "CoreData")
            ]
        ),
        .testTarget(
            name: "FeatureSearchTests",
            dependencies: ["FeatureSearch"]
        ),
    ]
)
