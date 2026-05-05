
// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "CoreAppData",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "CoreAppData",
            targets: ["CoreAppData"]
        ),
    ],
    dependencies: [
        .package(path: "../CoreModel"),
        .package(path: "../CoreNetwork")
    ],
    targets: [
        .target(
            name: "CoreAppData",
            dependencies: [
                .product(name: "CoreModel", package: "CoreModel"),
                .product(name: "CoreNetwork", package: "CoreNetwork")
            ]
        ),
        .testTarget(
            name: "CoreAppDataTests",
            dependencies: [
                "CoreAppData",
                .product(name: "CoreModel", package: "CoreModel"),
                .product(name: "CoreNetwork", package: "CoreNetwork")
            ]
        ),
    ]
)
