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
        .package(path: "../CoreData")
    ],
    targets: [
        .target(
            name: "FeatureAuth",
            dependencies: [
                .product(name: "CoreData", package: "CoreData")
            ],
            path: "Sources/FeatureAuth"
        ),
        .testTarget(
            name: "FeatureAuthTests",
            dependencies: ["FeatureAuth"]
        ),
    ]
)
