// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "CorePlayerUI",
    products: [
        .library(
            name: "CorePlayerUI",
            targets: ["CorePlayerUI"]
        ),
    ],
    targets: [
        .target(
            name: "CorePlayerUI"
        ),
        .testTarget(
            name: "CorePlayerUITests",
            dependencies: ["CorePlayerUI"]
        ),
    ]
)
