// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Ignition",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .macCatalyst(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
//        .visionOS(.v1),
    ],
    products: [
        .library(
            name: "Ignition",
            targets: ["Ignition"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/nathantannar4/Engine", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "Ignition",
            dependencies: [
                "Engine"
            ]
        )
    ]
)
