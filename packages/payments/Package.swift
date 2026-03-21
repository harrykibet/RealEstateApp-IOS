// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "FeaturePayments",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "FeaturePayments",
            targets: ["FeaturePayments"]
        ),
    ],
    targets: [
        .target(
            name: "FeaturePayments"
        ),
        .testTarget(
            name: "FeaturePaymentsTests",
            dependencies: ["FeaturePayments"]
        ),
    ]
)
