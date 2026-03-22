// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "CoreNetwork",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "CoreNetwork",
            targets: ["CoreNetwork"]
        ),
    ],
    dependencies: [
        .package(path: "../CoreModel"),
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            from: "11.15.0"
        )
    ],
    targets: [
        .target(
            name: "CoreNetwork",
            dependencies: [
                .product(name: "CoreModel", package: "CoreModel"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk")
            ]
        ),
        .testTarget(
            name: "CoreNetworkTests",
            dependencies: [
                "CoreNetwork",
                .product(name: "CoreModel", package: "CoreModel")
            ]
        ),
    ]
)
