// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "UIComponents",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "UIComponents",
            targets: ["UIComponents"]),
    ],
    dependencies: [
        // No external dependencies
    ],
    targets: [
        .target(
            name: "UIComponents",
            dependencies: []),
        .testTarget(
            name: "UIComponentsTests",
            dependencies: ["UIComponents"]),
    ]
)
