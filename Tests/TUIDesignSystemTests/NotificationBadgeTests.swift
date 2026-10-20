import SwiftUI
import UIKit
import XCTest
@testable import TUIDesignSystem

final class NotificationBadgeTests: XCTestCase {
    @MainActor func testSourceSizesLongCountsAndThemesRenderWithoutClipping() throws {
        for theme in TUITheme.allCases {
            for size in TUINotificationBadgeSize.allCases {
                for count in ["1", "99+", "123456"] {
                    let image = try render(TUINotificationBadge(count, size: size), theme: theme)
                    let expected: CGFloat = size == .small ? 6 : size == .medium ? 18 : 24
                    XCTAssertEqual(image.size.height, expected, accuracy: 0.01)
                    XCTAssertGreaterThanOrEqual(image.size.width, image.size.height)
                    if count == "1" || size == .small {
                        XCTAssertEqual(image.size.width, expected, accuracy: 0.01)
                    }
                    if size != .small { try assertWhiteTextHasVerticalClearance(image) }
                    attach(image, name: "notification-\(size.rawValue)-\(count)-\(theme.rawValue)-standard")
                }
            }
        }
    }

    @MainActor func testNativeDynamicTypeGrowsBothContainersAndCapsAtAX1() throws {
        for size in [TUINotificationBadgeSize.medium, .large] {
            for count in ["1", "99+", "123456"] {
                let standard = try render(TUINotificationBadge(count, size: size))
                let ax1 = try render(TUINotificationBadge(count, size: size), typeSize: .accessibility1)
                let ax5 = try render(TUINotificationBadge(count, size: size), typeSize: .accessibility5)
                XCTAssertGreaterThan(ax1.size.height, standard.size.height)
                XCTAssertGreaterThan(ax1.size.width, standard.size.width)
                XCTAssertGreaterThanOrEqual(ax1.size.width, ax1.size.height)
                XCTAssertEqual(ax1.size, ax5.size)
                XCTAssertEqual(ax1.pngData(), ax5.pngData())
                try assertWhiteTextHasVerticalClearance(ax1)
                attach(ax1, name: "notification-\(size.rawValue)-\(count)-AX1")
                attach(ax5, name: "notification-\(size.rawValue)-\(count)-AX5-capped")
            }
        }
        let dot = try render(TUINotificationBadge(size: .small))
        let largeDot = try render(TUINotificationBadge(size: .small), typeSize: .accessibility5)
        XCTAssertEqual(dot.size, CGSize(width: 6, height: 6))
        XCTAssertEqual(dot.pngData(), largeDot.pngData(), "The textless source dot does not scale with text")
    }

    @MainActor func testIntermediateSizesGrowMonotonicallyAndDoNotShrinkMinimums() throws {
        for size in [TUINotificationBadgeSize.medium, .large] {
            var previousHeight: CGFloat = 0
            for category in [DynamicTypeSize.xSmall, .small, .medium, .large, .xLarge, .xxLarge, .xxxLarge, .accessibility1] {
                let image = try render(TUINotificationBadge("99+", size: size), typeSize: category)
                XCTAssertGreaterThanOrEqual(image.size.height, size == .medium ? 18 : 24)
                XCTAssertGreaterThanOrEqual(image.size.height, previousHeight)
                try assertWhiteTextHasVerticalClearance(image)
                previousHeight = image.size.height
            }
        }
    }

    @MainActor private func render<V: View>(_ view: V, theme: TUITheme = .day,
                                           typeSize: DynamicTypeSize = .large) throws -> UIImage {
        let renderer = ImageRenderer(content: view.environment(\.colorScheme, theme == .day ? .light : .dark)
            .environment(\.dynamicTypeSize, typeSize))
        renderer.scale = 3
        return try XCTUnwrap(renderer.uiImage)
    }

    private func assertWhiteTextHasVerticalClearance(_ image: UIImage) throws {
        let cg = try XCTUnwrap(image.cgImage)
        let width = cg.width, height = cg.height
        var pixels = [UInt8](repeating: 0, count: width * height * 4)
        let context = try XCTUnwrap(CGContext(data: &pixels, width: width, height: height, bitsPerComponent: 8,
            bytesPerRow: width * 4, space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue))
        context.draw(cg, in: CGRect(x: 0, y: 0, width: width, height: height))
        let rows = (0..<height).filter { y in
            (0..<width).contains { x in
                let index = 4 * (y * width + x)
                return pixels[index] > 235 && pixels[index + 1] > 235 && pixels[index + 2] > 235 && pixels[index + 3] > 235
            }
        }
        XCTAssertFalse(rows.isEmpty, "The rendered count must remain visible")
        XCTAssertGreaterThan(try XCTUnwrap(rows.first), 0, "Text must not touch the clipped top")
        XCTAssertLessThan(try XCTUnwrap(rows.last), height - 1, "Text must not touch the clipped bottom")
    }

    private func attach(_ image: UIImage, name: String) {
        let attachment = XCTAttachment(image: image)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
