// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoreImagePipeline",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CoreImagePipeline",
            targets: ["CoreImagePipeline"]
        ),
    ],
    dependencies: [
        .package(path: "../CoreMediaPipeline"),
        .package(path: "../CoreSecurity"),
        .package(path: "../CoreNetwork")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CoreImagePipeline",
            dependencies: [
                .product(name: "CoreMediaPipeline", package: "CoreMediaPipeline"),
                .product(name: "CoreSecurity", package: "CoreSecurity"),
                .product(name: "CoreNetwork", package: "CoreNetwork")
            ]
        ),
        .testTarget(
            name: "CoreImagePipelineTests",
            dependencies: [
                "CoreImagePipeline"
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
