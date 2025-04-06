// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LoginApp",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "LoginApp", targets: ["LoginApp"]),
        .library(name: "HTTPServer", targets: ["HTTPServer"])
    ],
    dependencies: [
        // Add dependencies here if needed
    ],
    targets: [
        .executableTarget(
            name: "LoginApp",
            dependencies: [
                "HTTPServer"
            ],
            path: "Sources/LoginApp"
        ),
        .target(
            name: "HTTPServer",
            dependencies: [],
            path: "Sources/HTTPServer"
        )
    ]
)