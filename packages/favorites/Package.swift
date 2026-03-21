// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "FeatureFavorites",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "FeatureFavorites",
            targets: ["FeatureFavorites"]
        ),
    ],
    targets: [
        .target(
            name: "FeatureFavorites"
        ),
        .testTarget(
            name: "FeatureFavoritesTests",
            dependencies: ["FeatureFavorites"]
        ),
    ]
)
