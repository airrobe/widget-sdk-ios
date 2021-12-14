// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AirRobeWidget",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "AirRobeWidget",
            targets: ["AirRobeWidget"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "AirRobeWidget",
            dependencies: []),
        .testTarget(
            name: "AirRobeWidgetTests",
            dependencies: ["AirRobeWidget"],
            resources: [
                .copy("Resources/mappingInfo.json")
            ]),
    ]
)
