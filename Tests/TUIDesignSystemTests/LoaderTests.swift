import SwiftUI
import UIKit
import XCTest
@testable import TUIDesignSystem

final class LoaderTests: XCTestCase {
    @MainActor
    func testAnimatedCircleConstructionAtSourcePoseHasNativeEvidenceForAllSizes() throws {
        for size in TUILoaderSize.allCases {
            for theme in TUITheme.allCases {
                // Explicit diameter exercises the same native Circle/round-cap
                // drawing used by animation, bypassing the static SVG branch.
                let image = try render(TUILoader(size: size, diameter: CGFloat(size.rawValue),
                                                 isAnimating: false), theme: theme)
                XCTAssertEqual(image.size, CGSize(width: size.rawValue, height: size.rawValue))
                try save(image, name: "native-circle-source-pose-\(size.rawValue)-\(theme.rawValue)")
            }
        }
    }

    func testSourceTimingGrowsThenShrinksLinearlyAndLoops() {
        let expected: [(Double, CGFloat, CGFloat, Double)] = [
            (0, 0, 0, 0), (0.5, 0, 0.2375, 90), (1, 0, 0.475, 180),
            (2, 0, 0.95, 360), (3, 0.475, 0.95, 540),
            (3.5, 0.7125, 0.95, 630), (4, 0, 0, 0), (5, 0, 0.475, 180)
        ]
        for (time, start, end, rotation) in expected {
            let frame = TUILoaderMotion.frame(at: time)
            XCTAssertEqual(frame.start, start, accuracy: 0.000001)
            XCTAssertEqual(frame.end, end, accuracy: 0.000001)
            XCTAssertEqual(frame.rotation, rotation, accuracy: 0.000001)
        }
        for invalid in [-1.0, .infinity, .nan] {
            XCTAssertEqual(TUILoaderMotion.frame(at: invalid), TUILoaderMotion.frame(at: 0))
        }
        XCTAssertEqual(TUILoader.recommendedMinimumVisibleDuration, .milliseconds(500))
    }

    @MainActor
    func testEveryMatrixVariantKeepsExactSourceContourInBothThemes() throws {
        let variants = TUILibraryCatalog.shared.variants(for: TUILoader.figmaComponentSetID)
        XCTAssertEqual(variants.count, 5)
        for size in TUILoaderSize.allCases {
            XCTAssertTrue(variants.contains { $0.id == size.figmaNodeID })
            for theme in TUITheme.allCases {
                let loader = TUILoader(size: size, isAnimating: false)
                let actual = try render(loader, theme: theme)
                let source = try render(Image("tui-loader-\(size.rawValue)", bundle: TUIResources.bundle)
                    .resizable().frame(width: CGFloat(size.rawValue), height: CGFloat(size.rawValue)), theme: theme)
                XCTAssertEqual(actual.pngData(), source.pngData(), "\(size) · \(theme)")
                XCTAssertEqual(actual.size.width, CGFloat(size.rawValue))
                XCTAssertEqual(actual.size.height, CGFloat(size.rawValue))
                XCTAssertEqual(loader.figmaNodeID, size.figmaNodeID)
                try save(actual, name: "\(size.rawValue)-\(theme.rawValue)")
            }
        }
    }

    @MainActor
    func testCustomGeometryColorAndThicknessActuallyRender() throws {
        let red = Color(.sRGB, red: 1, green: 0, blue: 0, opacity: 1)
        for diameter: CGFloat in [18, 28, 36] {
            for theme in TUITheme.allCases {
                let thin = try render(TUILoader(color: red, diameter: diameter, lineWidth: 1.5, isAnimating: false), theme: theme)
                let thick = try render(TUILoader(color: red, diameter: diameter, lineWidth: 4, isAnimating: false), theme: theme)
                XCTAssertEqual(thin.size.width, diameter)
                XCTAssertEqual(thin.size.height, diameter)
                XCTAssertGreaterThan(try redPixels(thin), 0)
                XCTAssertGreaterThan(try redPixels(thick), try redPixels(thin))
                try save(thin, name: "custom-\(Int(diameter))-thin-\(theme.rawValue)")
                try save(thick, name: "custom-\(Int(diameter))-thick-\(theme.rawValue)")
            }
        }
        let tinted = try render(TUILoader(color: red, isAnimating: false))
        XCTAssertGreaterThan(try redPixels(tinted), 0)
    }

    @MainActor
    func testAnimatedGeometryUsesSourceBrandTokenInBothThemes() throws {
        let sourceBrand = Color(.sRGB, red: 1, green: 221.0 / 255, blue: 45.0 / 255, opacity: 1)
        for theme in TUITheme.allCases {
            let actual = try render(TUILoader(diameter: 28, isAnimating: false), theme: theme)
            let expected = try render(TUILoader(color: sourceBrand, diameter: 28, isAnimating: false), theme: theme)
            XCTAssertEqual(actual.pngData(), expected.pngData())
        }
    }

    func testGeometryNeverProducesNonFiniteOrNegativeFrames() {
        let standard = TUILoader()
        XCTAssertEqual(standard.diameter, 24)
        XCTAssertEqual(standard.lineWidth, 2)
        let small = TUILoader(size: .x12)
        XCTAssertEqual(small.lineWidth, 1.5)
        let invalid = TUILoader(diameter: .nan, lineWidth: .infinity)
        XCTAssertEqual(invalid.diameter, 24)
        XCTAssertEqual(invalid.lineWidth, 2)
        let clamped = TUILoader(diameter: -1, lineWidth: 100)
        XCTAssertEqual(clamped.diameter, 1.5)
        XCTAssertEqual(clamped.lineWidth, 1.5)
    }

    @MainActor private func render<V: View>(_ view: V, theme: TUITheme = .day) throws -> UIImage {
        let renderer = ImageRenderer(content: view.environment(\.colorScheme, theme == .day ? .light : .dark))
        renderer.scale = 3
        return try XCTUnwrap(renderer.uiImage)
    }

    private func redPixels(_ image: UIImage) throws -> Int {
        let cg = try XCTUnwrap(image.cgImage)
        var bytes = [UInt8](repeating: 0, count: cg.width * cg.height * 4)
        let context = try XCTUnwrap(CGContext(data: &bytes, width: cg.width, height: cg.height,
            bitsPerComponent: 8, bytesPerRow: cg.width * 4, space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue))
        context.draw(cg, in: CGRect(x: 0, y: 0, width: cg.width, height: cg.height))
        return stride(from: 0, to: bytes.count, by: 4).filter {
            bytes[$0] > 100 && bytes[$0 + 1] < 10 && bytes[$0 + 2] < 10 && bytes[$0 + 3] > 100
        }.count
    }

    private func save(_ image: UIImage, name: String) throws {
        let attachment = XCTAttachment(image: image)
        attachment.name = "loader-\(name)"
        attachment.lifetime = .keepAlways
        add(attachment)
        guard let root = ProcessInfo.processInfo.environment["TUI_LOADER_EVIDENCE_DIRECTORY"] else { return }
        let folder = URL(fileURLWithPath: root)
        try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        try XCTUnwrap(image.pngData()).write(to: folder.appendingPathComponent("\(name).png"))
    }
}
