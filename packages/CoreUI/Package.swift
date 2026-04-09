// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "CoreUI",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "CoreUI",
            targets: ["CoreUI"]
        ),
    ],
    dependencies: [
        .package(path: "../CoreDesignSystem")
    ],
    targets: [
        .target(
            name: "CoreUI",
            dependencies: [
                .product(name: "CoreDesignSystem", package: "CoreDesignSystem")
            ]
        ),
        .testTarget(
            name: "CoreUITests",
            dependencies: ["CoreUI"]
        ),
    ]
)
