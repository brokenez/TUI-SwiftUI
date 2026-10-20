import SwiftUI

/// Original pixel-mask matrix. `Font Size5` is deliberately kept as a separate
/// source value rather than silently merging it with Body L.
public enum TUISensitiveFontSize: String, CaseIterable, Sendable {
    case bodyLarge = "Body L"
    case bodyMedium = "Body M"
    case uiSmall = "UI S"
    case uiXSmall = "UI XS"
    case fontSize5 = "Font Size5"

    public var figmaNodeID: String {
        switch self {
        case .bodyLarge: "46866:304516"
        case .bodyMedium: "46866:304595"
        case .uiSmall: "46866:304647"
        case .uiXSmall: "46866:304698"
        case .fontSize5: "47079:304877"
        }
    }

    public var sourceSize: CGSize {
        switch self {
        case .bodyLarge, .fontSize5: CGSize(width: 170, height: 20)
        case .bodyMedium: CGSize(width: 135, height: 18)
        case .uiSmall: CGSize(width: 120, height: 16)
        case .uiXSmall: CGSize(width: 104, height: 14)
        }
    }
}

/// The runtime pixel mask described by the Sensitive Mode construction guide.
/// Source frame sizes are defaults; use `tuiSensitive` on an existing view to
/// inherit its actual content size instead of guessing a text width.
public struct TUISensitiveMode: View {
    public static let figmaComponentSetID = "46866:304541"
    public let fontSize: TUISensitiveFontSize
    public let color: Color
    public let width: CGFloat?
    public let height: CGFloat?
    public let cornerRadius: CGFloat
    public let seed: UInt64
    public var figmaNodeID: String { fontSize.figmaNodeID }

    public init(fontSize: TUISensitiveFontSize = .bodyLarge,
                color: Color = TUIColor.textPrimary, width: CGFloat? = nil,
                height: CGFloat? = nil, cornerRadius: CGFloat = TUIRadius.xSmall,
                seed: UInt64 = 0) {
        self.fontSize = fontSize
        self.color = color
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
        self.seed = seed
    }

    public var body: some View {
        TUISensitiveCanvas(color: color, cornerRadius: cornerRadius, seed: seed)
            .frame(width: max(0, width ?? fontSize.sourceSize.width),
                   height: max(0, height ?? fontSize.sourceSize.height))
            .allowsHitTesting(false)
    }
}

/// Attach this attribute to the exact fragment whose foreground color is hidden.
/// Display the resulting Text inside TUISensitiveText so the glyphs are replaced
/// by pixels while native shaping, wrapping and link hit geometry are retained.
public extension Text {
    func tuiSensitive(isHidden: Bool = true, color: Color = TUIColor.textPrimary,
                      seed: UInt64 = 0) -> Text {
        let styled = foregroundStyle(color)
        return isHidden ? styled.customAttribute(TUISensitiveTextAttribute(color: color, seed: seed)) : styled
    }
}

public struct TUISensitiveText: View {
    let content: Text

    public init(_ content: Text) { self.content = content }

    /// Every literal occurrence is masked. An empty or absent substring leaves
    /// the original text intact; no substring matching changes the label value.
    public init(_ value: String, masking sensitiveValue: String, isHidden: Bool = true,
                color: Color = TUIColor.textPrimary, seed: UInt64 = 0) {
        content = Self.annotatedText(value, masking: isHidden ? sensitiveValue : "", color: color, seed: seed)
    }

    public var body: some View {
        content.textRenderer(TUISensitiveTextRenderer())
    }

    static func annotatedText(_ value: String, masking sensitiveValue: String,
                              color: Color, seed: UInt64 = 0) -> Text {
        guard !sensitiveValue.isEmpty else { return Text(verbatim: value) }
        var interpolation = LocalizedStringKey.StringInterpolation(literalCapacity: value.count, interpolationCount: 0)
        var remaining = value.startIndex..<value.endIndex
        while let match = value.range(of: sensitiveValue, options: .literal, range: remaining) {
            interpolation.appendInterpolation(Text(verbatim: String(value[remaining.lowerBound..<match.lowerBound])))
            interpolation.appendInterpolation(Text(verbatim: String(value[match])).tuiSensitive(color: color, seed: seed))
            remaining = match.upperBound..<value.endIndex
        }
        interpolation.appendInterpolation(Text(verbatim: String(value[remaining])))
        return Text(LocalizedStringKey(stringInterpolation: interpolation))
    }
}

/// Covers a whole text block or component while keeping its layout and actions.
/// Pass the component radius for badges; text uses the source 4 pt default.
public extension View {
    func tuiSensitive(isHidden: Bool, color: Color = TUIColor.textPrimary,
                      cornerRadius: CGFloat = TUIRadius.xSmall, seed: UInt64 = 0) -> some View {
        // Zero opacity can remove a native control's hit surface. Mask only
        // its rendered pixels; preserve the control's own interaction tree.
        mask { Color.white.opacity(isHidden ? 0 : 1) }
            .overlay {
                if isHidden {
                    TUISensitiveCanvas(color: color, cornerRadius: cornerRadius, seed: seed)
                        .allowsHitTesting(false)
                }
            }
    }
}

private struct TUISensitiveCanvas: View {
    let color: Color
    let cornerRadius: CGFloat
    let seed: UInt64

    var body: some View {
        Canvas { context, size in
            TUISensitivePixelGrid.draw(in: CGRect(origin: .zero, size: size), color: color,
                                      cornerRadius: cornerRadius, seed: seed, context: &context)
        }
    }
}

struct TUISensitiveTextAttribute: TextAttribute {
    let color: Color
    let seed: UInt64
}

struct TUISensitiveTextRenderer: TextRenderer {
    func draw(layout: Text.Layout, in context: inout GraphicsContext) {
        for line in layout {
            guard line.contains(where: { $0[TUISensitiveTextAttribute.self] != nil }) else {
                context.draw(line)
                continue
            }
            for run in line {
                if let attribute = run[TUISensitiveTextAttribute.self] {
                    TUISensitivePixelGrid.draw(in: run.typographicBounds.rect, color: attribute.color,
                        cornerRadius: TUIRadius.xSmall, seed: attribute.seed, context: &context)
                } else { context.draw(run) }
            }
        }
    }
}

enum TUISensitivePixelGrid {
    struct Tile {
        let rect: CGRect
        let opacity: Double
    }

    static func rowCount(height: CGFloat) -> Int {
        guard height.isFinite, height >= 32 else { return 2 }
        return 3 + Int((height - 32) / 16)
    }

    static func tiles(in bounds: CGRect, seed: UInt64) -> [Tile] {
        guard bounds.width.isFinite, bounds.height.isFinite,
              bounds.width > 0, bounds.height > 0 else { return [] }
        let rows = rowCount(height: bounds.height)
        let side = bounds.height / CGFloat(rows)
        let columns = Int((bounds.width / side).rounded(.up))
        return (0..<rows).flatMap { row in
            (0..<columns).map { column in
                // SplitMix64 yields stable pseudo-random values, with no timer
                // or invented animation. Unsigned overflow is intentional.
                var value = seed &+ UInt64(row * columns + column) &+ 0x9E3779B97F4A7C15
                value = (value ^ (value >> 30)) &* 0xBF58476D1CE4E5B9
                value = (value ^ (value >> 27)) &* 0x94D049BB133111EB
                value ^= value >> 31
                let opacity = 0.2 + Double(value >> 11) / Double(UInt64(1) << 53) * 0.2
                return Tile(rect: CGRect(x: bounds.minX + CGFloat(column) * side,
                    y: bounds.minY + CGFloat(row) * side, width: side, height: side), opacity: opacity)
            }
        }
    }

    static func draw(in bounds: CGRect, color: Color, cornerRadius: CGFloat,
                     seed: UInt64, context: inout GraphicsContext) {
        var clipped = context
        clipped.clip(to: Path(roundedRect: bounds,
                             cornerRadius: max(0, min(cornerRadius, min(bounds.width, bounds.height) / 2))))
        for tile in tiles(in: bounds, seed: seed) {
            clipped.fill(Path(tile.rect), with: .color(color.opacity(tile.opacity)))
        }
    }
}

#Preview("Sensitive Mode · native text and component") {
    VStack(spacing: TUISpacing.x4) {
        TUISensitiveMode()
        TUISensitiveText("Оплатить 1 000 ₽", masking: "1 000 ₽")
            .tuiTypography(.bodyLarge)
        Text("Sensitive text").tuiTypography(.uiSmall)
            .padding(TUISpacing.x1)
            .background(TUIColor.action, in: Capsule())
            .tuiSensitive(isHidden: true, color: TUIColor.action, cornerRadius: TUIRadius.round)
    }.padding()
}
