// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoreModule",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "CoreModule",
            targets: ["CoreModule"]
        )
    ],
    dependencies: [
        .package(url: "git@github.com:pointfreeco/swift-composable-architecture.git", from: "1.19.1")
    ],
    targets: [
        .target(
            name: "CoreModule",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            resources: [
                .copy("Resources/data.csv"),
                .process("Resources/Fonts"),
                .process("Resources/Assets"),
            ]
        )
    ]
)
