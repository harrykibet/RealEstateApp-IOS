// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "CoreDatabase",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "CoreDatabase",
            targets: ["CoreDatabase"]
        ),
    ],
    targets: [
        .target(
            name: "CoreDatabase"
        ),
        .testTarget(
            name: "CoreDatabaseTests",
            dependencies: ["CoreDatabase"]
        ),
    ]
)
