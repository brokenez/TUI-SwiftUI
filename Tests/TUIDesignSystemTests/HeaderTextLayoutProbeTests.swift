import SwiftUI
import UIKit
import XCTest
@testable import TUIDesignSystem

/// Diagnostic native layout evidence for soft wraps, paragraph breaks and inline attachments.
final class HeaderTextLayoutProbeTests: XCTestCase {
    @MainActor
    func testNativeLineCharacterRanges() throws {
        let cases: [(String, Text)] = [
            ("natural", Text("Длинный заголовок, очень длинный, на три строки, с иконкой в конце и дополнительным текстом")),
            ("paragraph", Text("Первая строка\nВторая строка\nТретья строка\nЧетвёртая строка")),
            ("attachment", Text("Первая строка\nВторая строка\nСтрока с \(Image(systemName: "star.fill")) и ещё текстом"))
        ]
        for (name, text) in cases {
            let store = HeaderNativeLayoutStore()
            let font = TUIFigmaTextFont.displayBold(size: 30)
            let content = text.font(Font(font)).kerning(0.36)
                .lineSpacing(36 - font.lineHeight)
                .textRenderer(HeaderNativeLayoutProbe(store: store))
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: 343)
            let renderer = ImageRenderer(content: content)
            renderer.scale = 3
            XCTAssertNotNil(renderer.uiImage)
            XCTAssertFalse(store.rows.isEmpty)
            let offsets = store.rows.compactMap { $0["characterOffsets"] as? [Int] }
            if name == "natural" {
                for pair in zip(offsets, offsets.dropFirst()) {
                    XCTAssertGreaterThan(try XCTUnwrap(pair.1.min()), try XCTUnwrap(pair.0.max()),
                                         "A native soft wrap must continue the paragraph's character range")
                }
            } else if name == "paragraph" {
                XCTAssertEqual(offsets.compactMap { $0.min() }, [0, 0, 0, 0],
                               "Explicit paragraphs must restart the iOS 26 character range")
            } else {
                XCTAssertEqual(offsets.prefix(3).compactMap { $0.min() }, [0, 0, 0])
                XCTAssertGreaterThan(try XCTUnwrap(offsets[3].min()), try XCTUnwrap(offsets[2].max()),
                                     "An inline image must remain inside its paragraph's native character range")
            }
            let data = try JSONSerialization.data(withJSONObject: store.rows, options: [.prettyPrinted, .sortedKeys])
            let attachment = XCTAttachment(data: data, uniformTypeIdentifier: "public.json")
            attachment.name = "header-native-layout-" + name
            attachment.lifetime = .keepAlways
            add(attachment)
        }
    }
}

private final class HeaderNativeLayoutStore: @unchecked Sendable {
    private let lock = NSLock()
    private var storage: [[String: Any]] = []
    var rows: [[String: Any]] { lock.withLock { storage } }
    func set(_ rows: [[String: Any]]) { lock.withLock { storage = rows } }
}

private struct HeaderNativeLayoutProbe: TextRenderer {
    let store: HeaderNativeLayoutStore
    func draw(layout: Text.Layout, in context: inout GraphicsContext) {
        let indices = layout.flatMap { $0.flatMap { $0.characterIndices } }
        guard let first = indices.min() else { return }
        var rows: [[String: Any]] = []
        for line in layout {
            rows.append([
                "originX": line.origin.x, "originY": line.origin.y,
                "width": line.typographicBounds.width,
                "characterOffsets": line.flatMap { $0.characterIndices }.map { first.distance(to: $0) },
                "slices": line.flatMap { run in run.map { slice in
                    ["width": slice.typographicBounds.width,
                     "x": slice.typographicBounds.origin.x,
                     "offsets": slice.characterIndices.map { first.distance(to: $0) }] as [String: Any]
                } }
            ])
            context.draw(line)
        }
        store.set(rows)
    }
}
