import SwiftUI

/// A text block that can be expanded and collapsed, matching the iOS `tui-text-expandable` variants.
public struct TUITextExpandable: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    public enum Size: String, CaseIterable, Sendable, Hashable {
        case uiSmall = "UI S"
        case bodyMedium = "Body M"
        case bodyLarge = "Body L"

        var typography: TUITypographyRole {
            switch self {
            case .uiSmall: .uiSmall
            case .bodyMedium: .bodyMedium
            case .bodyLarge: .bodyLarge
            }
        }

        var tracking: CGFloat {
            switch self {
            case .uiSmall: -0.08
            case .bodyMedium: -0.24
            case .bodyLarge: -0.41
            }
        }

        var collapsedHeight: CGFloat {
            switch self {
            case .uiSmall: 64
            case .bodyMedium: 90
            case .bodyLarge: 100
            }
        }

        var skeletonHeight: CGFloat {
            switch self {
            case .uiSmall: 64
            case .bodyMedium: 74
            case .bodyLarge: 82
            }
        }

        var skeletonAssetHeight: CGFloat {
            switch self {
            case .uiSmall: 56
            case .bodyMedium: 64
            case .bodyLarge: 72
            }
        }

        var rowHeight: CGFloat {
            switch self {
            case .uiSmall: 80
            case .bodyMedium: 106
            case .bodyLarge: 116
            }
        }
    }

    public enum Style: String, CaseIterable, Sendable, Hashable {
        case primary = "Primary"
        case secondary = "Secondary"
    }

    public let text: String
    public let size: Size
    public let style: Style
    public let showsMoreButton: Bool
    public let isSkeleton: Bool
    @State private var isExpanded = false

    public init(
        _ text: String,
        size: Size = .bodyMedium,
        style: Style = .primary,
        showsMoreButton: Bool = true,
        isSkeleton: Bool = false
    ) {
        self.text = text
        self.size = size
        self.style = style
        self.showsMoreButton = showsMoreButton
        self.isSkeleton = isSkeleton
    }

    public var body: some View {
        Group {
            if isSkeleton {
                skeletonContent
            } else {
                textContent
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, TUISpacing.x4)
        .padding(.vertical, TUISpacing.x2)
        .frame(width: size == .uiSmall && style == .secondary ? 360 : 375)
        .frame(height: isSkeleton ? size.skeletonHeight + 16 : (!isExpanded ? size.rowHeight : nil), alignment: .topLeading)
        .background(TUIColor.named("Background/Base", fallback: 0xFFFFFF))
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier(figmaNodeID ?? "44305:306527")
        .onChange(of: size) { _, _ in isExpanded = false }
        .onChange(of: style) { _, _ in isExpanded = false }
        .onChange(of: showsMoreButton) { _, _ in isExpanded = false }
        .onChange(of: isSkeleton) { _, _ in isExpanded = false }
    }

    public var figmaNodeID: String? {
        switch (size, style, isSkeleton) {
        case (.bodyMedium, .primary, false): "44305:306528"
        case (.bodyMedium, .secondary, false): "44305:306611"
        case (.bodyLarge, .primary, false): "49780:289467"
        case (.bodyLarge, .secondary, false): "49780:289476"
        case (.uiSmall, .primary, false): "49808:291011"
        case (.uiSmall, .secondary, false): "49808:291020"
        case (.bodyLarge, .primary, true): "56039:297548"
        case (.bodyMedium, .primary, true): "56039:297557"
        case (.uiSmall, .primary, true): "56039:297566"
        case (_, .secondary, true): nil
        }
    }

    private var textColor: Color {
        TUIColor.named(style == .primary ? "Text/Primary" : "Text/Secondary", fallback: style == .primary ? 0x333333 : 0x9299A2)
    }

    private var textContent: some View {
        VStack(alignment: .trailing, spacing: TUISpacing.x2) {
            Text(text)
                .font(Font(TUIFigmaTextFont.regular(size: size.typography.metrics.size)))
                .tracking(size.tracking)
                .foregroundStyle(textColor)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: isExpanded ? nil : size.collapsedHeight, alignment: .topLeading)
                .overlay(alignment: .bottomTrailing) {
                    if showsMoreButton && !isExpanded {
                        moreButton
                    }
                }
                .clipped()
            if showsMoreButton && isExpanded {
                Button("свернуть") {
                    withAnimation(reduceMotion ? nil : .default) { isExpanded = false }
                }
                .font(Font(TUIFigmaTextFont.regular(size: size.typography.metrics.size)))
                .tracking(size.tracking)
                .foregroundStyle(TUIColor.named("Text/Action", fallback: 0x428BF9))
                .buttonStyle(.plain)
                .accessibilityLabel("Свернуть текст")
            }
        }
    }

    private var moreButton: some View {
        Button {
            withAnimation(reduceMotion ? nil : .default) { isExpanded = true }
        } label: {
            Text("еще")
                .font(Font(TUIFigmaTextFont.regular(size: size.typography.metrics.size)))
                .tracking(size.tracking)
                .foregroundStyle(TUIColor.named("Text/Action", fallback: 0x428BF9))
                .fixedSize()
                .padding(.leading, TUISpacing.x2)
                .background(TUIColor.backgroundPrimary)
                .background(alignment: .leading) {
                    LinearGradient(
                        colors: [TUIColor.backgroundPrimary.opacity(0), TUIColor.backgroundPrimary],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: TUISpacing.x6, height: size.typography.metrics.lineHeight)
                    .offset(x: -TUISpacing.x6)
                }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Показать весь текст")
    }

    private var skeletonContent: some View {
        Image(skeletonAssetName, bundle: .module)
            .resizable()
            .frame(width: 303, height: size.skeletonAssetHeight)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 5)
            .frame(height: size.skeletonHeight, alignment: .topLeading)
            .accessibilityHidden(true)
    }

    private var skeletonAssetName: String {
        switch size {
        case .bodyLarge: "tui-text-expandable-skeleton-body-l"
        case .bodyMedium: "tui-text-expandable-skeleton-body-m"
        case .uiSmall: "tui-text-expandable-skeleton-ui-s"
        }
    }
}
