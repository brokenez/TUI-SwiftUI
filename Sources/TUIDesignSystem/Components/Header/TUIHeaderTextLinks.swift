import SwiftUI
import Foundation

struct TUIHeaderInlineLinkAttribute: TextAttribute {
    let url: URL
}

struct TUIHeaderTextLink {
    let label: String
    let url: URL
}

/// Draw-time hit geometry, independent of SwiftUI state updates during rendering.
final class TUIHeaderLinkHitMap: @unchecked Sendable {
    struct Region { let rect: CGRect; let url: URL }
    private let lock = NSLock()
    private var regions: [Region] = []
    private var measurement: (width: CGFloat, textWidth: CGFloat)?

    func measure(proposal: ProposedViewSize, size: CGSize) {
        guard let width = proposal.width, width > 0, width.isFinite else { return }
        lock.withLock { measurement = (width, size.width) }
    }

    func update(_ rawRegions: [Region], baselineOffset: CGFloat, centered: Bool, height: CGFloat) {
        lock.withLock {
            guard let measurement else { regions = []; return }
            let offsetX = centered ? (measurement.width - measurement.textWidth) / 2 : 0
            let bounds = CGRect(x: 0, y: 0, width: measurement.width, height: height)
            regions = rawRegions.compactMap { region in
                let rect = region.rect.offsetBy(dx: offsetX, dy: baselineOffset).intersection(bounds)
                return rect.isNull || rect.isEmpty ? nil : Region(rect: rect, url: region.url)
            }
        }
    }

    func url(at point: CGPoint) -> URL? {
        lock.withLock { regions.first { $0.rect.contains(point) }?.url }
    }
}

extension AttributedString {
    var tuiHeaderLinks: [TUIHeaderTextLink] {
        var links: [TUIHeaderTextLink] = []
        var lastURL: URL?
        for run in runs {
            if let url = run.link {
                let label = String(self[run.range].characters)
                if url == lastURL, let last = links.last {
                    links[links.count - 1] = TUIHeaderTextLink(label: last.label + label, url: url)
                } else {
                    links.append(TUIHeaderTextLink(label: label, url: url))
                }
                lastURL = url
            } else { lastURL = nil }
        }
        return links
    }

    var tuiHeaderAnnotatedText: Text {
        var interpolation = LocalizedStringKey.StringInterpolation(literalCapacity: 0, interpolationCount: runs.count)
        for run in runs {
            var segment = Text(AttributedString(self[run.range]))
            if let url = run.link { segment = segment.customAttribute(TUIHeaderInlineLinkAttribute(url: url)) }
            interpolation.appendInterpolation(segment)
        }
        return Text(LocalizedStringKey(stringInterpolation: interpolation))
    }
}

struct TUIHeaderLinkedTextAccessibility: ViewModifier {
    let links: [TUIHeaderTextLink]
    let label: String
    @Environment(\.openURL) private var openURL

    @ViewBuilder func body(content: Content) -> some View {
        if links.isEmpty { content }
        else {
            content.accessibilityElement(children: .ignore)
                .accessibilityLabel(Text(label))
                .accessibilityActions {
                    ForEach(Array(links.enumerated()), id: \.offset) { item in
                        Button("Открыть ссылку: \(item.element.label)") { openURL(item.element.url) }
                    }
                }
        }
    }
}
