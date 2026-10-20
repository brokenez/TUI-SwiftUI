import SwiftUI
import UIKit
import XCTest
@testable import TUIDesignSystem

final class ButtonTests: XCTestCase {
    @MainActor func testLongLabelKeepsIconAtSourceConstructionInset() throws {
        for size in TUIButtonSize.allCases {
            let inset: CGFloat = size == .large ? 16 : size == .medium ? 10 : 7
            let icon: CGFloat = size == .small ? 16 : 24
            let side: CGFloat = size == .large ? 56 : size == .medium ? 44 : 30
            let only = try render(TUIButton("Добавить", size: size, showsIcon: true, showsLabel: false, action: {}),
                                  size: .small, theme: .day)
            let long = try render(TUIButton("Очень длинное название кнопки, которое не должно сдвигать иконку",
                                           size: size, showsIcon: true, action: {}), size: size, theme: .day, width: 335)
            let rect = CGRect(x: inset * 3, y: (side - icon) / 2 * 3, width: icon * 3, height: icon * 3)
            let a = UIImage(cgImage: try XCTUnwrap(only.cgImage?.cropping(to: rect)))
            let b = UIImage(cgImage: try XCTUnwrap(long.cgImage?.cropping(to: rect)))
            XCTAssertEqual(a.pngData(), b.pngData(), "\(size): long label must preserve the exact source icon slot")
        }
    }

    @MainActor func testSmallIntrinsicWidthGrowsWithDynamicTypeBeforeOverflow() throws {
        var previous = CGFloat.zero
        for type in [DynamicTypeSize.large, .accessibility1, .accessibility5] {
            let image = try render(TUIButton("Продолжить", size: .small, showsIcon: true, action: {}),
                                   size: .small, theme: .day, dynamicType: type)
            let category: UIContentSizeCategory = type == .large ? .large
                : type == .accessibility1 ? .accessibilityMedium : .accessibilityExtraExtraExtraLarge
            let label = UILabel()
            let font = UIFontMetrics(forTextStyle: .footnote).scaledFont(
                for: .systemFont(ofSize: 13, weight: .semibold),
                compatibleWith: UITraitCollection(preferredContentSizeCategory: category))
            label.attributedText = NSAttributedString(string: "Продолжить", attributes: [.font: font, .kern: -0.08])
            let required = label.intrinsicContentSize.width + (type == .large ? 16 : 20) + 8 + 14
            XCTAssertGreaterThanOrEqual(image.size.width + 1, required,
                                         "Unconstrained Small must fit its complete native label")
            XCTAssertGreaterThan(image.size.width, previous)
            previous = image.size.width
        }
    }

    @MainActor func testDynamicTypeKeepsMinimumHeightAndGrowsWithLabel() throws {
        for size in TUIButtonSize.allCases {
            let minimum: CGFloat = size == .large ? 56 : size == .medium ? 44 : 30
            var previous = CGFloat.zero
            for type in [DynamicTypeSize.large, .accessibility1, .accessibility5] {
                let normal = try render(TUIButton("Очень длинное название действия, которое должно плавно исчезать",
                                                  size: size, showsIcon: true, action: {}),
                                        size: size, theme: .day, dynamicType: type, width: 180)
                let loading = try render(TUIButton("Очень длинное название действия, которое должно плавно исчезать",
                                                   size: size, state: .loading, showsIcon: true, action: {}),
                                         size: size, theme: .day, dynamicType: type, width: 180)
                XCTAssertEqual(normal.size.width, 180)
                XCTAssertEqual(normal.size, loading.size)
                XCTAssertGreaterThanOrEqual(normal.size.height, minimum)
                XCTAssertGreaterThanOrEqual(normal.size.height, previous)
                if type == .large { XCTAssertEqual(normal.size.height, minimum) }
                if type == .accessibility5 { XCTAssertGreaterThan(normal.size.height, minimum) }
                previous = normal.size.height
            }
        }
    }

    @MainActor func testIconOnlyContainerRemainsSquareAtDefaultAndAccessibilitySizes() throws {
        for size in TUIButtonSize.allCases {
            let side: CGFloat = size == .large ? 56 : size == .medium ? 44 : 30
            for type in [DynamicTypeSize.large, .accessibility1, .accessibility5] {
                let renderer = ImageRenderer(content: TUIButton("Добавить", size: size,
                    showsIcon: true, showsLabel: false, action: {}).environment(\.dynamicTypeSize, type))
                renderer.scale = 3
                XCTAssertEqual(try XCTUnwrap(renderer.uiImage).size, CGSize(width: side, height: side))
            }
        }
    }

    @MainActor func testDynamicTypeVisualEvidenceIncludesOverflowAndBothThemes() throws {
        for theme in TUITheme.allCases {
            for type in [DynamicTypeSize.large, .accessibility1, .accessibility5] {
                let view = VStack(alignment: .leading, spacing: 16) {
                    ForEach(TUIButtonSize.allCases, id: \.self) { size in
                        TUIButton("Продолжить", size: size, showsIcon: true, action: {})
                        TUIButton("Перевести зарплату на новый счёт без комиссии", size: size, showsIcon: true, action: {})
                        TUIButton("Добавить", size: size, showsIcon: true, showsLabel: false, action: {})
                    }
                }.padding(20).frame(width: 375)
                    .background(theme == .day ? Color.white : Color.black)
                    .environment(\.colorScheme, theme == .day ? .light : .dark)
                    .environment(\.dynamicTypeSize, type)
                let renderer = ImageRenderer(content: view)
                renderer.scale = 3
                let attachment = XCTAttachment(image: try XCTUnwrap(renderer.uiImage))
                attachment.name = "button-dynamic-type-\(type)-\(theme.rawValue)-3x"
                attachment.lifetime = .keepAlways
                add(attachment)
            }
        }
    }

    // Button specification 81:48109: loading replaces content visually but
    // retains the complete normal container, including small intrinsic width.
    @MainActor func testLoadingKeepsLabelAndIconContainerDimensionsInEveryAppearance() throws {
        for theme in TUITheme.allCases {
            for appearance in TUIButtonAppearance.allCases {
                for size in TUIButtonSize.allCases {
                    for icon in [false, true] {
                        for label in [false, true] where icon || label {
                            func button(_ state: TUIButtonState) -> TUIButton {
                                TUIButton("Продолжить перевод зарплаты", appearance: appearance, size: size,
                                          state: state, showsIcon: icon, showsLabel: label, action: {})
                            }
                            let normal = try render(button(.normal), size: size, theme: theme)
                            let loading = try render(button(.loading), size: size, theme: theme)
                            XCTAssertEqual(normal.size, loading.size, "\(appearance) / \(size) / icon \(icon) / label \(label)")
                        }
                    }
                }
            }
        }
    }

    @MainActor func testLoadingVisualEvidenceIncludesAllSizesAndBothThemes() throws {
        for theme in TUITheme.allCases {
            let view = VStack(alignment: .leading, spacing: 16) {
                ForEach(TUIButtonSize.allCases, id: \.self) { size in
                    TUIButton("Продолжить перевод зарплаты", size: size, showsIcon: true, action: {})
                    TUIButton("Продолжить перевод зарплаты", size: size, state: .loading, showsIcon: true, action: {})
                }
            }.padding(20).frame(width: 375)
                .background(theme == .day ? Color.white : Color.black)
                .environment(\.colorScheme, theme == .day ? .light : .dark)
            let renderer = ImageRenderer(content: view)
            renderer.scale = 3
            let attachment = XCTAttachment(image: try XCTUnwrap(renderer.uiImage))
            attachment.name = "button-normal-loading-sizes-\(theme.rawValue)-3x"
            attachment.lifetime = .keepAlways
            add(attachment)
        }
    }

    @MainActor private func render(_ button: TUIButton, size: TUIButtonSize, theme: TUITheme,
                                  dynamicType: DynamicTypeSize = .large, width: CGFloat? = nil) throws -> UIImage {
        let renderer = ImageRenderer(content: button.frame(width: width ?? (size == .small ? nil : 335))
            .environment(\.colorScheme, theme == .day ? .light : .dark)
            .environment(\.dynamicTypeSize, dynamicType))
        renderer.scale = 3
        return try XCTUnwrap(renderer.uiImage)
    }
}
