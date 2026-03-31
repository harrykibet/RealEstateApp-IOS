// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "FeatureService",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "FeatureService",
            targets: ["FeatureService"]
        ),
    ],
    dependencies: [
        .package(path: "../CoreData")
    ],
    targets: [
        .target(
            name: "FeatureService",
            dependencies: [
                .product(name: "CoreData", package: "CoreData")
            ]
        ),
        .testTarget(
            name: "FeatureServiceTests",
            dependencies: ["FeatureService"]
        ),
    ]
)
