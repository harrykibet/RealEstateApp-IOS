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
    targets: [
        .target(
            name: "CoreUI"
        ),
        .testTarget(
            name: "CoreUITests",
            dependencies: ["CoreUI"]
        ),
    ]
)
