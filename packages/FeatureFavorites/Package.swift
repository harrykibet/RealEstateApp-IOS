// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "FeatureFavorites",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "FeatureFavorites", targets: ["FeatureFavorites"]),
    ],
    dependencies: [
        .package(path: "../CoreAppData")
    ],
    targets: [
        .target(
            name: "FeatureFavorites",
            dependencies: [
                .product(name: "CoreAppData", package: "CoreAppData")
            ]
        ),
        .testTarget(
            name: "FeatureFavoritesTests",
            dependencies: ["FeatureFavorites"]
        ),
    ]
)
