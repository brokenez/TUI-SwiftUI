import SwiftUI
import UIKit
import XCTest
@testable import TUIDesignSystem

final class HeaderLargeTests: XCTestCase {
    @MainActor
    func testVariantMatrixMatchesAllApplicableFigmaNodes() {
        XCTAssertEqual(Set(TUIHeaderLarge.Variant.allCases.map(\.figmaNodeID)),
                       Set(["42565:305013", "17714:51940", "547:151714", "17714:51950",
                            "42565:305051", "18083:44942", "17714:51980", "547:151734",
                            "17714:51990", "18083:44906"]))
        XCTAssertEqual(TUIHeaderLarge().variant, .subheaderLeading)
        XCTAssertTrue(TUIHeaderLarge().showsSubheader)
        XCTAssertFalse(TUIHeaderLarge().showsIcon)
        XCTAssertEqual(TUIHeaderLarge.Variant.allCases.filter(\.isExtended).count, 2)
        XCTAssertFalse(TUIHeaderLarge.Variant.allCases.contains { $0.isExtended && ($0.isCentered || $0.isSkeleton) })
    }

    @MainActor
    func testExactLegacyFontFacesTrackingAndAX1Cap() {
        for (title, description, face, size, height, tracking) in [
            (true, false, "SFProDisplay-Bold", 30.0, 36.0, 0.36),
            (false, true, "SFProText-Regular", 17.0, 20.0, -0.41),
            (false, false, "SFProText-Regular", 15.0, 18.0, -0.24)
        ] {
            let standard = TUIHeaderFontMetrics.make(style: .init(), title: title,
                                                    description: description, size: .large)
            XCTAssertEqual(standard.font.fontName, face)
            XCTAssertEqual(standard.font.pointSize, size, accuracy: 0.001)
            XCTAssertEqual(standard.lineHeight, height)
            XCTAssertEqual(standard.firstBaseline, title ? 29 : description ? 16 : 14)
            XCTAssertEqual(standard.tracking, tracking, accuracy: 0.001)
            let ax1 = TUIHeaderFontMetrics.make(style: .init(), title: title, description: description, size: .accessibility1)
            let ax5 = TUIHeaderFontMetrics.make(style: .init(), title: title, description: description, size: .accessibility5)
            XCTAssertEqual(ax1.font.pointSize, ax5.font.pointSize)
            XCTAssertGreaterThan(ax1.font.pointSize, standard.font.pointSize)
        }
        let supplied = UIFont.systemFont(ofSize: 24, weight: .medium)
        let custom = TUIHeaderFontMetrics.make(style: .init(font: supplied, lineHeight: 30),
                                              title: true, description: false, size: .large)
        XCTAssertEqual(custom.font.fontName, supplied.fontName)
        XCTAssertEqual(custom.font.pointSize, 24)
        XCTAssertEqual(custom.lineHeight, 30)
        let foundation = TUIHeaderFontMetrics.make(style: .init(role: .headingMedium),
                                                  title: true, description: false, size: .large)
        XCTAssertEqual(foundation.font.pointSize, TUITypographyRole.headingMedium.metrics.size)
        XCTAssertEqual(foundation.lineHeight, TUITypographyRole.headingMedium.metrics.lineHeight.rounded())
    }

    @MainActor
    func testNativeVectorRenderingCanBeComparedWithSourceOutlines() throws {
        for variant in [TUIHeaderLarge.Variant.descriptionLeading, .subheaderLeading] {
            let renderer = ImageRenderer(content: TUIHeaderLarge(variant: variant)
                .frame(width: 375).background(Color.white)
                .environment(\.colorScheme, .light).environment(\.dynamicTypeSize, .large))
            let url = FileManager.default.temporaryDirectory.appendingPathComponent("header-\(variant.rawValue).pdf")
            var box = CGRect(x: 0, y: 0, width: 375, height: variant.showsDescription ? 104 : 102)
            let context = try XCTUnwrap(CGContext(url as CFURL, mediaBox: &box, nil))
            renderer.render(rasterizationScale: 3) { size, render in
                XCTAssertEqual(size, box.size)
                context.beginPDFPage(nil)
                render(context)
                context.endPDFPage()
                context.closePDF()
            }
            let data = try Data(contentsOf: url)
            XCTAssertTrue(data.starts(with: Data("%PDF".utf8)))
            let attachment = XCTAttachment(data: data, uniformTypeIdentifier: "com.adobe.pdf")
            attachment.name = "header-\(variant.figmaNodeID.replacingOccurrences(of: ":", with: "-"))-native-vector"
            attachment.lifetime = .keepAlways
            add(attachment)
        }
    }

    @MainActor
    func testAllTenVariantsRenderNativeEvidenceInBothThemes() throws {
        for theme in TUITheme.allCases {
            for variant in TUIHeaderLarge.Variant.allCases {
                let image = try render(TUIHeaderLarge(variant: variant, isSkeletonAnimating: false), theme: theme)
                XCTAssertEqual(image.cgImage?.width, 1125)
                XCTAssertEqual(image.cgImage?.height, (variant.showsDescription ? 104 : 102) * 3, variant.rawValue)
                attach(image, name: "header-\(variant.figmaNodeID.replacingOccurrences(of: ":", with: "-"))-\(theme.rawValue.lowercased())-3x")
            }
        }
    }

    @MainActor
    func testWrappedContentSingleLineAndHiddenSubheader() throws {
        let hidden = try render(TUIHeaderLarge(showsSubheader: false))
        XCTAssertEqual(hidden.size.height, 68)
        let wrapped = try render(TUIHeaderLarge("Длинный заголовок, который занимает несколько строк",
                                                description: "Описание тоже должно переноситься без потери текста и многоточия",
                                                variant: .descriptionLeading))
        XCTAssertGreaterThan(wrapped.size.height, 104)
        let fade = try render(TUIHeaderLarge("Длинный заголовок, который занимает несколько строк",
                                             description: "Описание тоже должно переноситься без потери текста и многоточия",
                                             variant: .descriptionLeading)
            .textStyles(title: .init(overflow: .singleLineFade), description: .init(overflow: .singleLineFade)))
        XCTAssertEqual(fade.size.height, 104)
        attach(wrapped, name: "header-wrap-day-3x")
        attach(fade, name: "header-fade-day-3x")
        attach(hidden, name: "header-no-subheader-day-3x")
    }

    @MainActor
    func testAccessorySourceAssetAndDynamicTypeReflowRender() throws {
        let icon = try render(TUIHeaderLarge(showsIcon: true))
        XCTAssertEqual(icon.size.height, 102)
        attach(icon, name: "header-avatar-day-3x")
        let base = TUIHeaderLarge("Несколько строк заголовка",
                                  subheader: "Дополнительный текст с переносом")
        let inline = try render(base.accessory { Toggle("Выбрано", isOn: .constant(true)).labelsHidden() }, size: .accessibility1)
        let reflow = try render(base.accessory(reflowsAtAX1: true) { Toggle("Выбрано", isOn: .constant(true)).labelsHidden() }, size: .accessibility1)
        let capped = try render(base.accessory(reflowsAtAX1: true) { Toggle("Выбрано", isOn: .constant(true)).labelsHidden() }, size: .accessibility5)
        XCTAssertEqual(reflow.size, capped.size)
        XCTAssertGreaterThan(reflow.size.height, 102)
        attach(inline, name: "header-accessory-inline-ax1-3x")
        attach(reflow, name: "header-accessory-reflow-ax1-3x")
        attach(capped, name: "header-accessory-reflow-ax5-capped-3x")
    }

    @MainActor
    func testSuffixHugsShortLabelAndRemainsVisibleAfterSingleLineFade() throws {
        func header(_ title: String) -> some View {
            TUIHeaderLarge(title, showsSubheader: false)
                .textStyles(title: .init(overflow: .singleLineFade))
                .titleTrailing { Rectangle().fill(Color(red: 1, green: 0, blue: 0)).frame(width: 16, height: 16) }
        }
        let short = try render(header("Hi"))
        let long = try render(header("Очень длинный заголовок, который не помещается в одну строку"))
        attach(short, name: "header-short-label-suffix-3x")
        attach(long, name: "header-faded-label-visible-suffix-3x")
        let shortBox = try redBounds(short)
        let longBox = try redBounds(long)
        XCTAssertEqual(shortBox.size, CGSize(width: 48, height: 48))
        XCTAssertEqual(longBox.size, shortBox.size)
        XCTAssertEqual(longBox.minX, 343 * 3)
        XCTAssertLessThan(shortBox.minX, longBox.minX - 100)
        XCTAssertEqual(longBox.minY, 18 * 3)
        XCTAssertEqual(long.size.height, 68)
    }

    @MainActor
    func testMultilineSlotsUseSourceCenterAndSupportIndependentAlignment() throws {
        let title = "Заголовок, который занимает несколько строк"
        var images: [TUIHeaderLarge.AccessoryAlignment: UIImage] = [:]
        for alignment in TUIHeaderLarge.AccessoryAlignment.allCases {
            let image = try render(TUIHeaderLarge(title, showsSubheader: false)
                .titleTrailing {
                    Rectangle().fill(Color(red: 1, green: 0, blue: 0))
                        .frame(width: 16, height: 16)
                        .alignmentGuide(.firstTextBaseline) { _ in 10 }
                }
                .textSlotAlignments(title: alignment))
            images[alignment] = image
            attach(image, name: "header-multiline-slot-\(alignment.rawValue)-3x")
        }
        let centered = try XCTUnwrap(images[.center])
        let labelHeight = centered.size.height - 8 - 24
        XCTAssertGreaterThan(labelHeight, 36)
        XCTAssertEqual(try redBounds(centered).midY, (8 + labelHeight / 2) * 3, accuracy: 0.5)
        XCTAssertEqual(try redBounds(XCTUnwrap(images[.firstLineCenter])).minY, 18 * 3)
        XCTAssertEqual(try redBounds(XCTUnwrap(images[.top])).minY, 8 * 3)
        XCTAssertEqual(try redBounds(XCTUnwrap(images[.bottom])).maxY, (8 + labelHeight) * 3)
        XCTAssertEqual(try redBounds(XCTUnwrap(images[.firstBaseline])).minY, (8 + 29 - 10) * 3)
    }

    @MainActor
    func testInlineSymbolFlowsAfterWrappedTextWithHeaderTypography() throws {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 16, height: 16))
        let marker = renderer.image { context in
            UIColor(red: 1, green: 0, blue: 0, alpha: 1).setFill()
            context.fill(CGRect(x: 0, y: 0, width: 16, height: 16))
        }
        let image = try render(TUIHeaderLarge(showsSubheader: false)
            .titleInlineText(Text("Заголовок, который занимает несколько строк \(Image(uiImage: marker))")))
        attach(image, name: "header-native-inline-symbol-wrap-3x")
        XCTAssertGreaterThan(image.size.height, 68)
        XCTAssertGreaterThan(try redBounds(image).minY, (8 + 36) * 3)
        // A short native Text composition inherits the same exact legacy line box.
        let short = try render(TUIHeaderLarge(showsSubheader: false).titleInlineText(Text("Header")))
        XCTAssertEqual(short.size.height, 68)
    }

    @MainActor
    func testDescriptionReflowPlacesAccessoryAfterAllText() throws {
        let image = try render(TUIHeaderLarge("Header", description: "Description", variant: .descriptionLeading)
            .accessory(reflowsAtAX1: true) {
                Rectangle().fill(Color(red: 1, green: 0, blue: 0)).frame(width: 16, height: 16)
            }, size: .accessibility1)
        attach(image, name: "header-description-reflow-ax1-3x")
        XCTAssertEqual(try redBounds(image).maxY, (image.size.height - 24) * 3,
                       "The accessory must be the final content block, above the 24 pt bottom inset")
    }

    @MainActor
    func testMultilineFadeCapsHeightAndFadesInlineContentOnlyOnLastLine() throws {
        let marker = UIGraphicsImageRenderer(size: CGSize(width: 306, height: 16)).image { context in
            UIColor(red: 1, green: 0, blue: 0, alpha: 1).setFill()
            context.fill(CGRect(x: 0, y: 0, width: 306, height: 16))
        }
        let text = Text("Первая строка\nВторая строка\n\(Image(uiImage: marker))\nЧетвёртая строка")
        let full = try render(TUIHeaderLarge(showsSubheader: false).titleInlineText(text))
        let limited = try render(TUIHeaderLarge(showsSubheader: false).titleInlineText(text)
            .textStyles(title: .init(overflow: .multilineFade(lineLimit: 3))))
        attach(full, name: "header-multiline-native-full-3x")
        attach(limited, name: "header-multiline-native-three-lines-fade-3x")
        XCTAssertGreaterThan(full.size.height, 140)
        XCTAssertEqual(limited.size.height, 140)
        let fullCG = try XCTUnwrap(full.cgImage), limitedCG = try XCTUnwrap(limited.cgImage)
        let firstTwoLines = CGRect(x: 0, y: 0, width: fullCG.width, height: (8 + 72) * 3)
        let fullPixels = try rgbaCrop(fullCG, firstTwoLines)
        let limitedPixels = try rgbaCrop(limitedCG, firstTwoLines)
        let differences = zip(fullPixels, limitedPixels).map { abs(Int($0) - Int($1)) }
        // An opaque mask can round antialiasing by one channel level. Compare
        // decoded pixels: PNG encoding is not evidence of a visual difference.
        XCTAssertLessThanOrEqual(differences.max() ?? 0, 1,
                                 "The fade must leave both earlier lines unchanged within 8-bit rounding")
        XCTAssertLessThan(Double(differences.reduce(0, +)) / Double(differences.count), 0.001,
                          "Earlier lines must retain their geometry and ink")
        let markerY = Int(try redBounds(full).midY)
        XCTAssertEqual(try rgbPixel(limitedCG, x: 216 * 3, y: markerY), [255, 0, 0])
        XCTAssertEqual(try rgbPixel(fullCG, x: 320 * 3, y: markerY), [255, 0, 0])
        XCTAssertGreaterThan(try rgbPixel(limitedCG, x: 320 * 3, y: markerY)[1], 50,
                             "The inline attachment fades with the final line, toward the white background")
        let short = TUIHeaderLarge("Первая\nВторая", showsSubheader: false)
        let shortFull = try render(short)
        let shortLimited = try render(short.textStyles(title: .init(overflow: .multilineFade(lineLimit: 3))))
        XCTAssertEqual(shortLimited.size, shortFull.size)
        XCTAssertEqual(shortLimited.pngData(), shortFull.pngData(), "Fitting content must not fade or reserve an extra line")
    }

    @MainActor
    func testMultilineFadeMatchesContinuousFinalLineWithoutEllipsis() throws {
        let title = "Длинный заголовок, очень длинный, на три строки, с иконкой в конце и дополнительным текстом"
        let header = TUIHeaderLarge(title, showsSubheader: false)
        let full = try render(header)
        let limited = try render(header.textStyles(title: .init(overflow: .multilineFade(lineLimit: 3))))
        attach(limited, name: "header-natural-multiline-final-word-fade-3x")
        let rect = CGRect(x: 308 * 3, y: (8 + 72) * 3, width: 50 * 3, height: 36 * 3)
        let fullPixels = try rgbaCrop(XCTUnwrap(full.cgImage), rect)
        let limitedPixels = try rgbaCrop(XCTUnwrap(limited.cgImage), rect)
        let gainedInk = stride(from: 0, to: fullPixels.count, by: 4).filter {
            fullPixels[$0] > 250 && limitedPixels[$0] < 240
        }.count
        XCTAssertGreaterThan(gainedInk, 10,
                             "The last line must continue into the fade, matching the Figma guide's word fragment")
        let expected = try render(TUIHeaderLarge("строки, с иконкой в конце и дополнительным текстом", showsSubheader: false)
            .textStyles(title: .init(overflow: .singleLineFade)))
        let actualPixels = try rgbaCrop(XCTUnwrap(limited.cgImage),
            CGRect(x: 0, y: (8 + 72) * 3, width: 375 * 3, height: 36 * 3))
        let expectedPixels = try rgbaCrop(XCTUnwrap(expected.cgImage),
            CGRect(x: 0, y: 8 * 3, width: 375 * 3, height: 36 * 3))
        let differences = zip(actualPixels, expectedPixels).map { abs(Int($0) - Int($1)) }
        XCTAssertLessThanOrEqual(differences.max() ?? 0, 1,
                                 "The last line must be continuous native text, with no ellipsis or reserved gap")
    }

    @MainActor
    func testMultilineFadeDoesNotContinueAnExplicitNewParagraph() throws {
        let limited = try render(TUIHeaderLarge("Первая строка\nВторая строка\nТретья строка\nЧетвёртая строка", showsSubheader: false)
            .textStyles(title: .init(overflow: .multilineFade(lineLimit: 3))))
        let expected = try render(TUIHeaderLarge("Третья строка", showsSubheader: false))
        let a = try rgbaCrop(XCTUnwrap(limited.cgImage), CGRect(x: 0, y: 80 * 3, width: 375 * 3, height: 36 * 3))
        let b = try rgbaCrop(XCTUnwrap(expected.cgImage), CGRect(x: 0, y: 8 * 3, width: 375 * 3, height: 36 * 3))
        XCTAssertLessThanOrEqual(zip(a, b).map { abs(Int($0) - Int($1)) }.max() ?? 0, 1)
        attach(limited, name: "header-multiline-explicit-paragraph-limit-3x")
    }

    @MainActor
    func testFadeLinkActionsPreserveLabelsAcrossStyledRuns() throws {
        var text = AttributedString("Первый Второй")
        let first = try XCTUnwrap(text.range(of: "Первый"))
        let second = try XCTUnwrap(text.range(of: "Второй"))
        let firstURL = try XCTUnwrap(URL(string: "https://go.tcsbank.ru/tui-header-specs"))
        let secondURL = try XCTUnwrap(URL(string: "https://go.tcsbank.ru/tui-text-specs"))
        text[first].link = firstURL
        text[second].link = secondURL
        text[try XCTUnwrap(text.range(of: "Пер"))].foregroundColor = TUIColor.action
        XCTAssertEqual(text.tuiHeaderLinks.map(\.label), ["Первый", "Второй"])
        XCTAssertEqual(text.tuiHeaderLinks.map(\.url), [firstURL, secondURL])
        XCTAssertTrue(AttributedString("Без ссылок").tuiHeaderLinks.isEmpty)
    }

    @MainActor
    func testRealLinkAccessoryProvidesNativeVectorBaselineEvidence() throws {
        for alignment in [TUIHeaderLarge.AccessoryAlignment.firstBaseline, .firstLineCenter] {
            let header = TUIHeaderLarge("Header\nSecond", showsSubheader: false)
                .accessory(alignment: alignment) {
                    TUILink("Все", showsLeadingIcon: false, showsTrailingIcon: false) {}
                }
            let renderer = ImageRenderer(content: header.frame(width: 375).background(Color.white)
                .environment(\.colorScheme, .light).environment(\.dynamicTypeSize, .large))
            let url = FileManager.default.temporaryDirectory.appendingPathComponent("header-link-\(alignment.rawValue).pdf")
            var box = CGRect(x: 0, y: 0, width: 375, height: 104)
            let context = try XCTUnwrap(CGContext(url as CFURL, mediaBox: &box, nil))
            renderer.render(rasterizationScale: 3) { size, draw in
                XCTAssertEqual(size, box.size)
                context.beginPDFPage(nil); draw(context); context.endPDFPage(); context.closePDF()
            }
            let attachment = XCTAttachment(data: try Data(contentsOf: url), uniformTypeIdentifier: "com.adobe.pdf")
            attachment.name = "header-link-accessory-\(alignment.rawValue)-native-vector"
            attachment.lifetime = .keepAlways
            add(attachment)
            attach(try render(header), name: "header-link-accessory-\(alignment.rawValue)-3x")
        }
    }

    @MainActor
    private func render<Content: View>(_ content: Content, theme: TUITheme = .day,
                                       size: DynamicTypeSize = .large) throws -> UIImage {
        let renderer = ImageRenderer(content: content.frame(width: 375)
            .background(theme == .day ? Color.white : Color.black)
            .environment(\.colorScheme, theme == .day ? .light : .dark)
            .environment(\.dynamicTypeSize, size))
        renderer.scale = 3
        renderer.isOpaque = true
        return try XCTUnwrap(renderer.uiImage)
    }

    private func attach(_ image: UIImage, name: String) {
        let attachment = XCTAttachment(image: image)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    private func redBounds(_ image: UIImage) throws -> CGRect {
        let cg = try XCTUnwrap(image.cgImage)
        var bytes = [UInt8](repeating: 0, count: cg.width * cg.height * 4)
        let context = try XCTUnwrap(CGContext(data: &bytes, width: cg.width, height: cg.height,
            bitsPerComponent: 8, bytesPerRow: cg.width * 4, space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue))
        context.draw(cg, in: CGRect(x: 0, y: 0, width: cg.width, height: cg.height))
        var minX = cg.width, minY = cg.height, maxX = -1, maxY = -1
        for y in 0..<cg.height {
            for x in 0..<cg.width {
                let offset = (y * cg.width + x) * 4
                if bytes[offset] > 240 && bytes[offset + 1] < 20 && bytes[offset + 2] < 20 {
                    minX = min(minX, x); maxX = max(maxX, x)
                    minY = min(minY, y); maxY = max(maxY, y)
                }
            }
        }
        XCTAssertGreaterThanOrEqual(maxX, 0, "Suffix must remain visible outside the text fade mask")
        return CGRect(x: minX, y: minY, width: maxX - minX + 1, height: maxY - minY + 1)
    }

    private func rgbaCrop(_ image: CGImage, _ rect: CGRect) throws -> [UInt8] {
        let crop = try XCTUnwrap(image.cropping(to: rect))
        var bytes = [UInt8](repeating: 0, count: crop.width * crop.height * 4)
        let context = try XCTUnwrap(CGContext(data: &bytes, width: crop.width, height: crop.height,
            bitsPerComponent: 8, bytesPerRow: crop.width * 4, space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue))
        context.draw(crop, in: CGRect(x: 0, y: 0, width: crop.width, height: crop.height))
        return bytes
    }

    private func rgbPixel(_ image: CGImage, x: Int, y: Int) throws -> [UInt8] {
        let sample = try XCTUnwrap(image.cropping(to: CGRect(x: x, y: y, width: 1, height: 1)))
        var bytes = [UInt8](repeating: 0, count: 4)
        let context = try XCTUnwrap(CGContext(data: &bytes, width: 1, height: 1,
            bitsPerComponent: 8, bytesPerRow: 4, space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue))
        context.draw(sample, in: CGRect(x: 0, y: 0, width: 1, height: 1))
        return Array(bytes.prefix(3))
    }
}
