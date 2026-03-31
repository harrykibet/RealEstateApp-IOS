// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "FeaturePayments",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "FeaturePayments", targets: ["FeaturePayments"]),
    ],
    dependencies: [
        .package(path: "../CoreData")
    ],
    targets: [
        .target(
            name: "FeaturePayments",
            dependencies: [
                .product(name: "CoreData", package: "CoreData")
            ]
        ),
        .testTarget(
            name: "FeaturePaymentsTests",
            dependencies: ["FeaturePayments"]
        ),
    ]
)
