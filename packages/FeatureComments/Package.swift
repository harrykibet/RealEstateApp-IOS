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
        .package(path: "../CoreData")
    ],
    targets: [
        .target(
            name: "FeatureComments",
            dependencies: [
                .product(name: "CoreData", package: "CoreData")
            ]
        ),
        .testTarget(
            name: "FeatureCommentsTests",
            dependencies: ["FeatureComments"]
        ),
    ]
)
