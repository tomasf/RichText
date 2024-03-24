// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RichText",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "RichText", targets: ["RichText"]),
    ],
    dependencies: [
        .package(url: "https://github.com/tomasf/SwiftSCAD.git", branch: "main"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
    ],
    targets: [
        .target(name: "RichText", dependencies: [
            "SwiftSCAD",
            .product(name: "Logging", package: "swift-log")
        ]),
    ]
)
