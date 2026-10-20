import SwiftUI
import UIKit
import XCTest
@testable import TUIDesignSystem

final class OriginalSVGMaskTests: XCTestCase {
    @MainActor
    func testOriginalMaskedGlyphsRenderForSourceComparison() throws {
        for (name, image) in [
            ("note-plus", AnyView(TUIColor.named("Background/Accent 2")
                .mask(TUIOriginalSVGMask(resource: "tui-card-medium-note-plus"))
                .frame(width: 30, height: 30))),
            ("star-avatar", AnyView(ZStack {
                Circle().fill(TUIColor.named("Background/Accent 2"))
                Color.white.mask(TUIOriginalSVGMask(resource: "tui-card-medium-star"))
                    .frame(width: 34, height: 34)
            }.frame(width: 56, height: 56))),
            ("stack-mask", AnyView(Color.white.mask(TUIOriginalSVGMask(resource: "tui-card-medium-stack-mask"))
                .frame(width: 32.5006, height: 40)))
        ] {
            let renderer = ImageRenderer(content: image.environment(\.colorScheme, .light))
            renderer.scale = 3
            let rendered = try XCTUnwrap(renderer.uiImage)
            let attachment = XCTAttachment(image: rendered)
            attachment.name = "original-svg-mask-" + name + "-3x"
            attachment.lifetime = .keepAlways
            add(attachment)
            XCTAssertGreaterThan(try XCTUnwrap(rendered.pngData()).count, 500)
        }
    }

    func testUnverifiedSVGFeaturesFailInsteadOfChangingArtwork() {
        let source = "<svg width=\"30\" height=\"30\" viewBox=\"0 0 30 30\"><path d=\"M0 0A10 10 0 0 1 20 20\"/></svg>"
        XCTAssertThrowsError(try TUIParsedSVGMask(data: Data(source.utf8)))
    }
}
