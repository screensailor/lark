// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Lark",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(name: "Lark", targets: ["Lark"]),
    ],
    dependencies: [
        .package(url: "https://github.com/screensailor/Peek.git", .branch("trunk")),
        .package(url: "https://github.com/screensailor/Hope.git", .branch("trunk")),
    ],
    targets: [
        .target(name: "Lark", dependencies: ["Peek"]),
        .testTarget(name: "LarkTests", dependencies: ["Lark", "Peek", "Hope"]),
    ]
)
