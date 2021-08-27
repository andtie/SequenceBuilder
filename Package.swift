// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SequenceBuilder",
    platforms: [.macOS(.v11), .iOS(.v14), .watchOS(.v6), .tvOS(.v13)],
    products: [
        .library(name: "SequenceBuilder", targets: ["SequenceBuilder"]),
        .library(name: "SequenceBuilderExamples", targets: ["SequenceBuilderExamples"])
    ],
    dependencies: [],
    targets: [
        .target(name: "SequenceBuilder"),
        .target(name: "SequenceBuilderExamples", dependencies: ["SequenceBuilder"])
    ]
)
