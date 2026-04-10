// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "CorePlayerUI",
    platforms: [
        .iOS(.v18)
    ],
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
