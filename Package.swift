// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-bio",
    platforms: [
        .macOS(.v10_13),
    ],
    products: [
        .executable(name: "biosw", targets: ["Run"]),
        .library(name: "Bio", targets: ["Bio"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        //.package(url: "https://github.com/mtynior/ColorizeSwift.git", from: "1.2.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.1"),
        //.package(url: "https://github.com/apple/swift-numerics", from: "0.0.5"),
        // logging
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        // csv reader
        //.package(url: "https://github.com/yaslab/CSV.swift", from: "2.4.0"),
        // Swift version of python-requests
        //.package(url: "https://github.com/saeta/Just", from: "0.7.3"),
        // Path
        //.package(url: "https://github.com/mxcl/Path.swift", from: "0.16.3"),
        // logging
        
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Bio",
            dependencies: ["Logging",
                           /*"CSV","Just", "Path",*/
                           /*.product(name: "Numerics", package: "swift-numerics"),*/]),
        .target(
            name: "Run",
            dependencies: ["Bio", "ArgumentParser"]),
        .testTarget(
            name: "BioSwiftTests",
            dependencies: ["Bio"]),
    ]
)
