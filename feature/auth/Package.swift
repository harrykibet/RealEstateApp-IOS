// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "auth",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "auth",
            targets: ["auth"]
        ),
    ],
    targets: [
        .target(
            name: "auth",
            path: "Sources/auth"
        ),
        .testTarget(
            name: "authTests",
            dependencies: ["auth"]
        ),
    ]
)
