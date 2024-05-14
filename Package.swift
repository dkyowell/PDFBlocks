// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PDFBlocks",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(
            name: "PDFBlocksExamples",
            targets: ["PDFBlocksExamples"]),
        .library(
            name: "PDFBlocks",
            targets: ["PDFBlocks"]),
    ],
    dependencies: [
            .package(url: "https://github.com/krzyzanowskim/CoreTextSwift.git", .upToNextMajor(from: "0.0.0")),
            .package(url: "https://github.com/apple/swift-algorithms.git", .upToNextMajor(from: "1.2.0")),
    ],
    targets: [
        .target(name: "PDFBlocks", dependencies: [.product(name: "Algorithms", package: "swift-algorithms"),
                                                  .product(name: "CoreTextSwift", package: "CoreTextSwift")]),
        .target(name: "PDFBlocksExamples", dependencies: ["PDFBlocks"], path: "Examples"),
        .testTarget(name: "PDFBlocksTests", dependencies: ["PDFBlocks"]),
    ]
)
