// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "CoreNetwork",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "CoreNetwork",
            targets: ["CoreNetwork"]
        ),
    ],
    dependencies: [
        .package(path: "../CoreModel")
    ],
    targets: [
        .target(
            name: "CoreNetwork",
            dependencies: [
                .product(name: "CoreModel", package: "CoreModel")
            ]
        ),
        .testTarget(
            name: "CoreNetworkTests",
            dependencies: [
                "CoreNetwork",
                .product(name: "CoreModel", package: "CoreModel")
            ]
        ),
    ]
)
