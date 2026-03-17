
// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "property",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "property",
            targets: ["property"]
        ),
    ],
    dependencies: [
        .package(path: "../../core/model")
    ],
    targets: [
        .target(
            name: "property",
            dependencies: [
                .product(name: "model", package: "model")
            ]
        ),
        .testTarget(
            name: "propertyTests",
            dependencies: ["property"]
        ),
    ]
)
