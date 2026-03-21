
// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "CoreCommon",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "CoreCommon",
            targets: ["CoreCommon"]
        ),
    ],
    targets: [
        .target(
            name: "CoreCommon"
        ),
        .testTarget(
            name: "CoreCommonTests",
            dependencies: ["CoreCommon"]
        ),
    ]
)
