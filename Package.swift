// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AlertKit",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(
            name: "AlertKit",
            targets: ["AlertKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.30.0"),
        .package(url: "https://github.com/SwiftUIX/SwiftUIX.git", from: "0.1.3")
    ],
    targets: [
        .target(
            name: "AlertKit",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "SwiftUIX", package: "SwiftUIX")
            ]),
        .testTarget(
            name: "AlertKitTests",
            dependencies: ["AlertKit"]),
    ]
)
