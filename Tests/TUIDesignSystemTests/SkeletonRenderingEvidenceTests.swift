import SwiftUI
import UIKit
import XCTest
@testable import TUIDesignSystem

final class SkeletonRenderingEvidenceTests: XCTestCase {
    @MainActor
    func testAllTextSkeletonStylesProduceNativeRenderingEvidence() throws {
        for style in TUISkeletonText.TextStyle.allCases {
            let content = TUISkeletonText(textStyle: style, isAnimating: false)
                .background(Color.white)
                .environment(\.colorScheme, .light)
            let renderer = ImageRenderer(content: content)
            renderer.scale = 3
            renderer.isOpaque = true
            let rendered = renderer.uiImage
            let image = try XCTUnwrap(rendered)
            XCTAssertEqual(image.cgImage?.width, 276)
            XCTAssertEqual(image.cgImage?.height, Int(style.height * 3))
            let attachment = XCTAttachment(
                data: try XCTUnwrap(image.pngData()), uniformTypeIdentifier: "public.png")
            attachment.name = "skeleton-text-\(style.figmaNodeID.replacingOccurrences(of: ":", with: "-"))-day-3x"
            attachment.lifetime = .keepAlways
            add(attachment)
        }
    }

    @MainActor
    func testBothSkeletonKeyframesRenderWithTheFoundationColors() throws {
        for keyframe in TUISkeletonKeyframe.allCases {
            for theme in TUITheme.allCases {
                let dark = theme == .night
                let content = TUISkeleton(keyframe: keyframe, isAnimating: false)
                    .background(dark ? Color.black : Color.white)
                    .environment(\.colorScheme, dark ? .dark : .light)
                let renderer = ImageRenderer(content: content)
                renderer.scale = 3
                renderer.isOpaque = true
                let rendered = renderer.uiImage
                let image = try XCTUnwrap(rendered)
                let cgImage = try XCTUnwrap(image.cgImage)
                XCTAssertEqual(cgImage.width, 120)
                XCTAssertEqual(cgImage.height, 120)

                // Figma: black at 3% on white, white at 10% on black;
                // keyframe 2 applies 50% layer opacity to either color.
                let expected: Int = dark
                    ? (keyframe == .first ? 26 : 13)
                    : (keyframe == .first ? 247 : 251)
                let center = try rgb(cgImage, x: 60, y: 60)
                for channel in center {
                    XCTAssertLessThanOrEqual(abs(channel - expected), 1,
                        "\(theme.rawValue), keyframe \(keyframe.rawValue): 8-bit rounding only")
                }
                XCTAssertEqual(try rgb(cgImage, x: 0, y: 0),
                    Array(repeating: dark ? 0 : 255, count: 3))

                let attachment = XCTAttachment(
                    data: try XCTUnwrap(image.pngData()), uniformTypeIdentifier: "public.png")
                let node = keyframe == .first ? "37840-45834" : "37840-45835"
                attachment.name = "skeleton-\(node)-\(theme.rawValue.lowercased())-3x"
                attachment.lifetime = .keepAlways
                add(attachment)
            }
        }
    }

    private func rgb(_ image: CGImage, x: Int, y: Int) throws -> [Int] {
        var pixels = [UInt8](repeating: 0, count: image.width * image.height * 4)
        let colorSpace = try XCTUnwrap(CGColorSpace(name: CGColorSpace.sRGB))
        let context = try XCTUnwrap(CGContext(
            data: &pixels, width: image.width, height: image.height,
            bitsPerComponent: 8, bytesPerRow: image.width * 4, space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
                | CGBitmapInfo.byteOrder32Big.rawValue))
        context.draw(image, in: CGRect(x: 0, y: 0, width: image.width, height: image.height))
        let offset = (y * image.width + x) * 4
        return pixels[offset..<(offset + 3)].map(Int.init)
    }
}
