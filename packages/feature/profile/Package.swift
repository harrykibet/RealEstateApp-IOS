
// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "profile",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "profile",
            targets: ["profile"]
        ),
    ],
    dependencies: [
        .package(path: "../core/model")
    ],
    targets: [
        .target(
            name: "profile",
            dependencies: [
                .product(name: "model", package: "model")
            ]
        ),
        .testTarget(
            name: "profileTests",
            dependencies: ["profile"]
        ),
    ]
)
