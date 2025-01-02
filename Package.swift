// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "RichText",
    platforms: [.macOS(.v13)],
    products: [
        .library(name: "RichText", targets: ["RichText"]),
    ],
    dependencies: [
        .package(url: "https://github.com/tomasf/SwiftSCAD.git", .upToNextMinor(from: "0.9.0")),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.6.1"),
    ],
    targets: [
        .target(name: "RichText", dependencies: [
            .product(name: "SwiftSCAD", package: "SwiftSCAD"),
            .product(name: "Logging", package: "swift-log"),
        ])
    ]
)
