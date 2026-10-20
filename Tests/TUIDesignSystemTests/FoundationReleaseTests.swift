import SwiftUI
import UIKit
import XCTest
@testable import TUIDesignSystem

/// Release checks for the selected native iOS 26 Foundations contract.
/// These do not accept the historical component snapshots or extra AX modes.
final class FoundationReleaseTests: XCTestCase {
    func testUnknownModesCannotSilentlySelectAnotherThemeOrPlatform() {
        let catalog = TUITokenCatalog.shared
        XCTAssertEqual(catalog.modes(in: "Theme"), ["Day", "Night"])
        XCTAssertNil(catalog.value(named: "Text/Primary", collection: "Theme", mode: "Nihgt"))
        XCTAssertNil(catalog.number(named: "Typography/UI/L/Font Size", collection: "Platform", mode: "Day"))
        XCTAssertNotNil(catalog.value(named: "Text/Primary", collection: "theme", mode: "night"))
    }

    @MainActor func testEveryThemeColorMatchesItsResolvedSourceInBothNativeThemes() throws {
        let catalog = TUITokenCatalog.shared
        var count = 0
        for name in catalog.variableNames(in: "Theme") {
            guard catalog.value(named: name, collection: "Theme", mode: "Day") is [String: Any],
                  let source = catalog.value(named: name, collection: "Theme", mode: "Day") as? [String: Any],
                  source["r"] != nil else { continue }
            for (mode, style) in [("Day", UIUserInterfaceStyle.light), ("Night", .dark)] {
                let expected = try XCTUnwrap(catalog.value(named: name, collection: "Theme", mode: mode) as? [String: NSNumber])
                let native = UIColor(TUIColor.named(name)).resolvedColor(with: UITraitCollection(userInterfaceStyle: style))
                var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
                XCTAssertTrue(native.getRed(&r, green: &g, blue: &b, alpha: &a), name)
                for (actual, channel) in zip([r, g, b, a], ["r", "g", "b", "a"]) {
                    XCTAssertEqual(Double(actual), try XCTUnwrap(expected[channel]).doubleValue,
                                   accuracy: 0.00001, "\(mode)/\(name)/\(channel)")
                }
                count += 1
            }
        }
        XCTAssertEqual(count, 578, "All 289 source colors, in both themes")
        for style in [UIUserInterfaceStyle.light, .dark] {
            let traits = UITraitCollection(userInterfaceStyle: style)
            XCTAssertEqual(UIColor(TUIColor.separator).resolvedColor(with: traits),
                           UIColor(TUIColor.named("Border/Normal")).resolvedColor(with: traits))
        }
    }

    @MainActor func testNativeFontDecisionUsesSystemFacesAndShipsNoFontBinaries() throws {
        for size: CGFloat in [9, 11, 12, 13, 15, 17, 20, 30, 48] {
            XCTAssertEqual(TUIFigmaTextFont.regular(size: size), UIFont.systemFont(ofSize: size, weight: .regular))
            XCTAssertEqual(TUIFigmaTextFont.displayBold(size: size), UIFont.systemFont(ofSize: size, weight: .bold))
        }
        let enumerator = try XCTUnwrap(FileManager.default.enumerator(at: Bundle.module.bundleURL,
            includingPropertiesForKeys: nil))
        let fonts = enumerator.compactMap { $0 as? URL }.filter {
            ["otf", "ttf", "woff", "woff2"].contains($0.pathExtension.lowercased())
        }
        XCTAssertTrue(fonts.isEmpty, "The package must use native fonts without distributing font files")
    }

    @MainActor func testEveryIOSRoleRendersWithNativeFontsInDayAndNight() throws {
        XCTAssertEqual(TUITypographyRole.allCases.count, 31)
        for theme in TUITheme.allCases {
            let content = VStack(alignment: .leading, spacing: TUISpacing.x4) {
                ForEach(TUITypographyRole.allCases, id: \.self) { role in
                    VStack(alignment: .leading, spacing: TUISpacing.x1) {
                        Text(role.rawValue).font(.system(size: 10)).foregroundStyle(TUIColor.textSecondary)
                        Text("Зарплатный клуб · 123 ₽").tuiTypography(role).foregroundStyle(TUIColor.textPrimary)
                    }
                }
            }
            .padding(TUISpacing.x4).frame(width: 402, alignment: .leading)
            .background(TUIColor.backgroundPrimary)
            .environment(\.colorScheme, theme == .day ? .light : .dark)
            .environment(\.dynamicTypeSize, .large)
            let renderer = ImageRenderer(content: content)
            renderer.scale = 3
            let image = try XCTUnwrap(renderer.uiImage)
            XCTAssertEqual(image.size.width, 402)
            let attachment = XCTAttachment(image: image)
            attachment.name = "foundation-native-sf-31-roles-\(theme.rawValue)-3x"
            attachment.lifetime = .keepAlways
            add(attachment)
        }
    }
}
