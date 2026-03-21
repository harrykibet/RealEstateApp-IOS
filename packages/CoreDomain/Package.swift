
// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "CoreDomain",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "CoreDomain",
            targets: ["CoreDomain"]
        ),
    ],
    targets: [
        .target(
            name: "CoreDomain"
        ),
        .testTarget(
            name: "CoreDomainTests",
            dependencies: ["CoreDomain"]
        ),
    ]
)
