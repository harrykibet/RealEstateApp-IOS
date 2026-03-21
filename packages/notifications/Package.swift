// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "CoreNotifications",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "CoreNotifications",
            targets: ["CoreNotifications"]
        ),
    ],
    targets: [
        .target(
            name: "CoreNotifications"
        ),
        .testTarget(
            name: "CoreNotificationsTests",
            dependencies: ["CoreNotifications"]
        ),
    ]
)
