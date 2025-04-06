// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "DigitalMenu",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "DigitalMenu",
            targets: ["DigitalMenu"]),
    ],
    dependencies: [
        // Dependency on NetworkLayer
        .package(path: "../NetworkLayer")
    ],
    targets: [
        .target(
            name: "DigitalMenu",
            dependencies: ["NetworkLayer"]),
        .testTarget(
            name: "DigitalMenuTests",
            dependencies: ["DigitalMenu"]),
    ]
)
