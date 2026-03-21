
// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "CoreData",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "CoreData",
            targets: ["CoreData"]
        ),
    ],
    dependencies: [
        .package(path: "../CoreModel"),
        .package(path: "../CoreNetwork")
    ],
    targets: [
        .target(
            name: "CoreData",
            dependencies: [
                .product(name: "CoreModel", package: "CoreModel"),
                .product(name: "CoreNetwork", package: "CoreNetwork")
            ]
        ),
        .testTarget(
            name: "CoreDataTests",
            dependencies: [
                "CoreData",
                .product(name: "CoreModel", package: "CoreModel"),
                .product(name: "CoreNetwork", package: "CoreNetwork")
            ]
        ),
    ]
)
