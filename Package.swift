// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AlertKit",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(name: "AlertKit", targets: ["AlertKit"]),
        .library(name: "ComposableAlertKit", targets: ["ComposableAlertKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.30.0"),
        .package(url: "https://github.com/diniska/swiftui-system-colors.git", from: "1.2.0")
    ],
    targets: [
        .target(
            name: "AlertKit",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "SystemColors", package: "swiftui-system-colors")
            ]),
        .target(
            name: "ComposableAlertKit",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "SystemColors", package: "swiftui-system-colors")
            ]),
        .testTarget(
            name: "AlertKitTests",
            dependencies: ["AlertKit"]),
    ]
)
