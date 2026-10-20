import SwiftUI
import UIKit
import XCTest
@testable import TUIDesignSystem

final class FloatingContainerTests: XCTestCase {
    @MainActor func testEveryApplicableSourceVariantMapsToPublicAPIAndNativeContentHeight() throws {
        let primary = TUIButton("Main action") {}
        let secondary = TUIButton("Secondary action", appearance: .flat) {}
        let cases: [(TUIFloatingContainer<TUIFloatingContainerActions>, String, CGFloat)] = [
            (TUIFloatingContainer(primary: primary), "44286:299616", 80),
            (TUIFloatingContainer(primary: primary, secondary: secondary), "44286:299510", 136),
            (TUIFloatingContainer(primary: primary, secondary: secondary, background: .elevation1), "55095:283896", 136),
            (TUIFloatingContainer(primary: primary, legalText: "Legal text, max 3 lines"), "44286:299553", 120),
            (TUIFloatingContainer(primary: primary, legalText: "Legal text, max 3 lines", background: .elevation1), "55095:283930", 120)
        ]
        var ids = Set<String>()
        for (container, sourceID, height) in cases {
            XCTAssertEqual(container.figmaNodeID, sourceID)
            XCTAssertEqual(container.figmaProperties["system"], "iOS")
            ids.insert(sourceID)
            for theme in TUITheme.allCases {
                for width: CGFloat in [240, 375, 430] {
                    let renderer = ImageRenderer(content: container.frame(width: width)
                        .environment(\.dynamicTypeSize, .large)
                        .environment(\.colorScheme, theme == .day ? .light : .dark))
                    renderer.scale = 3
                    let image = try XCTUnwrap(renderer.uiImage)
                    XCTAssertEqual(image.size, CGSize(width: width, height: height))
                    if width == 375 {
                        let attachment = XCTAttachment(image: image)
                        attachment.name = "floating-\(sourceID.replacingOccurrences(of: ":", with: "-"))-\(theme.rawValue)-3x"
                        attachment.lifetime = .keepAlways; add(attachment)
                    }
                }
            }
        }
        let custom = TUIFloatingContainer { Color.red.frame(height: 56) }
        XCTAssertEqual(custom.figmaNodeID, "44286:299621")
        ids.insert(try XCTUnwrap(custom.figmaNodeID))
        let imported = Set(TUILibraryCatalog.shared.variants(for: "44286:299509", iOSOnly: true).map(\.id))
        XCTAssertEqual(ids, imported)
    }

    @MainActor func testCustomContentKeepsActualHeightAndSingleHorizontalInset() throws {
        for width: CGFloat in [180, 375, 600] {
            for height: CGFloat in [30, 56, 120] {
                let renderer = ImageRenderer(content: TUIFloatingContainer {
                    Color.red.frame(height: height)
                }.frame(width: width))
                renderer.scale = 1
                let image = try XCTUnwrap(renderer.uiImage)
                XCTAssertEqual(image.size, CGSize(width: width, height: height + 24))
                // A real custom view fills the inner slot, rather than a fixed
                // editor Placeholder or nested container with doubled insets.
                XCTAssertEqual(try alpha(image, x: 15, y: 10), 0)
                XCTAssertEqual(try alpha(image, x: 16, y: 10), 255)
                XCTAssertEqual(try alpha(image, x: Int(width) - 17, y: 10), 255)
                XCTAssertEqual(try alpha(image, x: Int(width) - 16, y: 10), 0)
                XCTAssertEqual(try alpha(image, x: Int(width) / 2, y: Int(height) + 12), 0)
            }
        }
    }

    @MainActor func testRequiredFadeAndLegalLineLimitAdaptWithoutChangingPresetHeight() throws {
        let primary = TUIButton("Продолжить") {}
        XCTAssertFalse(TUIFloatingContainer(primary: primary).showsFade)
        XCTAssertTrue(TUIFloatingContainer(primary: primary, showsFade: true).showsFade)
        XCTAssertTrue(TUIFloatingContainer(primary: primary, secondary: primary).showsFade)
        let legal = TUIFloatingContainer(primary: primary,
            legalText: "Продолжая, вы соглашаетесь с условиями обслуживания и обработки данных. Ознакомьтесь с правилами сервиса.")
        XCTAssertTrue(legal.showsFade)
        for width: CGFloat in [180, 240, 375] {
            let renderer = ImageRenderer(content: legal.frame(width: width).environment(\.dynamicTypeSize, .large))
            XCTAssertEqual(try XCTUnwrap(renderer.uiImage).size, CGSize(width: width, height: 120))
        }
    }

    func testMotionUsesExplicitGuideDurationRatherThanPrimitiveFast() {
        XCTAssertEqual(TUIFloatingContainerMetrics.entranceDuration, 0.5, accuracy: 0.000001)
        XCTAssertEqual(TUIFloatingContainerMetrics.exitDuration, 0.2)
        XCTAssertEqual(TUIFloatingContainerMetrics.fadeHeight, 46)
        XCTAssertNotEqual(TUIFloatingContainerMetrics.exitDuration, TUIMotionDuration.fast.seconds)
    }

    private func alpha(_ image: UIImage, x: Int, y: Int) throws -> UInt8 {
        let cg = try XCTUnwrap(image.cgImage)
        var bytes = [UInt8](repeating: 0, count: cg.width * cg.height * 4)
        try bytes.withUnsafeMutableBytes { storage in
            let context = try XCTUnwrap(CGContext(data: storage.baseAddress,
                width: cg.width, height: cg.height, bitsPerComponent: 8,
                bytesPerRow: cg.width * 4, space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue))
            context.draw(cg, in: CGRect(x: 0, y: 0, width: cg.width, height: cg.height))
        }
        return bytes[(y * cg.width + x) * 4 + 3]
    }
}
