// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "DangerSwiftFormat",
  platforms: [
    .macOS(.v10_12)
  ],
  products: [
    .library(name: "DangerSwiftFormat", targets: ["DangerSwiftFormat"]),
    .library(name: "DangerSwiftFormatDlib", type: .dynamic, targets: ["DangerSwiftFormat"]),
  ],
  targets: [
    .target(
      name: "DangerSwiftFormat",
      dependencies: []
    ),
    .testTarget(
      name: "DangerSwiftFormatTests",
      dependencies: ["DangerSwiftFormat"]
    ),
  ]
)
