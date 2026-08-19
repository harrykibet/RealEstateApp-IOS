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
    dependencies: [
        .package(url: "https://github.com/groue/GRDB.swift.git", .upToNextMajor(from: "6.0.0")),
    ],
    targets: [
        .target(
            name: "CoreDatabase",
            dependencies: [
                .product(name: "GRDB", package: "GRDB.swift")
            ]
        ),
        .testTarget(
            name: "CoreDatabaseTests",
            dependencies: ["CoreDatabase"]
        ),
    ]
)
