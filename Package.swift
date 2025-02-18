// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RZColorfulSwift",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "RZColorfulSwift",
            targets: ["RZColorfulSwift"]
        ),
    ],
    targets: [
        .target(
            name: "RZColorfulSwift",
            path: "RZColorfulSwift/Classes"
        )
    ],
    swiftLanguageVersions: [.v4_2, .v5]
)
