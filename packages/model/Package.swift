// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "CoreModel",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "CoreModel",
            targets: ["CoreModel"]
        ),
    ],
    targets: [
        .target(
            name: "CoreModel"
        ),
        .testTarget(
            name: "CoreModelTests",
            dependencies: ["CoreModel"]
        ),
    ]
)
