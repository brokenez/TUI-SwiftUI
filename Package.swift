// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "TUI-SwiftUI",
    platforms: [
        .iOS(.v26)
    ],
    products: [
        .library(name: "TUI-SwiftUI", targets: ["TUIDesignSystem"]),
        .library(name: "TUIDesignSystem", targets: ["TUIDesignSystem"])
    ],
    targets: [
        .target(
            name: "TUIDesignSystem",
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "TUIDesignSystemTests",
            dependencies: ["TUIDesignSystem"]
        )
    ]
)
