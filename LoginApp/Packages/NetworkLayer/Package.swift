// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "NetworkLayer",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "NetworkLayer",
            targets: ["NetworkLayer"]),
    ],
    dependencies: [
        // No external dependencies
    ],
    targets: [
        .target(
            name: "NetworkLayer",
            dependencies: []),
        .testTarget(
            name: "NetworkLayerTests",
            dependencies: ["NetworkLayer"]),
    ]
)
