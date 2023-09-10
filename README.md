<img src="./Logo.png" width="128"> 

# Ignition

`Ignition` aims to help make your SwiftUI views feel more interactive. It does this by providing API that makes it easier to run animations.

> Built for performance and backwards compatibility using [Engine](https://github.com/nathantannar4/Engine)

## Requirements

- Deployment target: iOS 13.0, macOS 10.15, tvOS 13.0, or watchOS 6.0
- Xcode 14.1+

## Installation

### Xcode Projects

Select `File` -> `Swift Packages` -> `Add Package Dependency` and enter `https://github.com/nathantannar4/Ignition`.

### Swift Package Manager Projects

You can add `Ignition` as a package dependency in your `Package.swift` file:

```swift
let package = Package(
    //...
    dependencies: [
        .package(url: "https://github.com/nathantannar4/Ignition"),
    ],
    targets: [
        .target(
            name: "YourPackageTarget",
            dependencies: [
                .product(name: "Ignition", package: "Ignition"),
            ],
            //...
        ),
        //...
    ],
    //...
)
```