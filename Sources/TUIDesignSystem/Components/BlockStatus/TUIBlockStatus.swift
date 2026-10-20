import SwiftUI

public enum TUIBlockStatusType: String, CaseIterable, Sendable {
    case fullscreen = "Fullscreen"
    case card = "Card"
}

/// Zero-state and error-state content block with the iOS Fullscreen and Card layouts.
public struct TUIBlockStatus: View {
    @Environment(\.colorScheme) private var colorScheme
    public let type: TUIBlockStatusType
    public let title: String
    public let text: String
    public let showsButton: Bool
    public let showsSecondaryButton: Bool
    public let showsImage: Bool
    public let showsTitle: Bool
    public let showsText: Bool
    public let primaryAction: () -> Void
    public let secondaryAction: () -> Void

    public var figmaNodeID: String {
        switch (type, showsButton) {
        case (.fullscreen, true): "43816:296051"
        case (.card, true): "46555:321088"
        case (.fullscreen, false): "46719:307391"
        case (.card, false): "46719:307399"
        }
    }

    public init(
        type: TUIBlockStatusType = .fullscreen,
        title: String = "Title",
        text: String = "Text",
        showsButton: Bool = true,
        showsSecondaryButton: Bool = false,
        showsImage: Bool = true,
        showsTitle: Bool = true,
        showsText: Bool = true,
        primaryAction: @escaping () -> Void = {},
        secondaryAction: @escaping () -> Void = {}
    ) {
        self.type = type
        self.title = title
        self.text = text
        self.showsButton = showsButton
        self.showsSecondaryButton = showsSecondaryButton
        self.showsImage = showsImage
        self.showsTitle = showsTitle
        self.showsText = showsText
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }

    public var body: some View {
        VStack(spacing: 0) {
            if showsImage {
                image
                    .padding(.bottom, type == .fullscreen ? TUISpacing.x6 : TUISpacing.x4)
            }

            textContent

            if showsButton {
                buttons
                    .padding(.top, type == .fullscreen ? TUISpacing.x6 : 0)
            }
        }
        .frame(width: type == .card ? 335 : 375)
        .padding(.horizontal, type == .card ? TUISpacing.x5 : 0)
        .padding(.top, type == .card ? TUISpacing.x8 : 0)
        .padding(.bottom, type == .card ? TUISpacing.x5 : 0)
        .frame(minHeight: type == .card && showsImage && showsTitle && showsText ? (showsButton ? 214 : 182) : nil)
        .background {
            if type == .card {
                RoundedRectangle(cornerRadius: TUIRadius.xLarge)
                    .fill(TUIColor.named("Background/Neutral 1", fallback: 0xF7F7F8))
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier(figmaNodeID)
    }

    @ViewBuilder
    private var image: some View {
        if type == .fullscreen {
            ZStack {
                Image(
                    colorScheme == .dark
                        ? "tui-block-status-magnifier-bubble-dark"
                        : "tui-block-status-magnifier-bubble",
                    bundle: .module
                )
                    .resizable()
                    .frame(width: 116.36, height: 116.36)
                Image(
                    colorScheme == .dark
                        ? "tui-block-status-magnifier-handle-dark"
                        : "tui-block-status-magnifier-handle",
                    bundle: .module
                )
                    .resizable()
                    .frame(width: 93.91, height: 92.08)
                    .offset(x: 4.5, y: 1.5)
            }
            .frame(width: 128, height: 128)
            .accessibilityHidden(true)
        } else {
            Image("tui-block-status-alert-vector", bundle: .module)
                .renderingMode(.template)
                .resizable()
                .foregroundStyle(.white)
                .frame(width: 24, height: 24)
                .frame(width: 56, height: 56)
                .background(TUIColor.named("Background/Neutral 4", fallback: 0xBFC2C6), in: Circle())
                .accessibilityHidden(true)
        }
    }

    private var textContent: some View {
        VStack(spacing: TUISpacing.x2) {
            if showsTitle {
                Text(title)
                    .tuiTypography(.headingSmall)
                    .foregroundStyle(TUIColor.textPrimary)
                    .frame(maxWidth: 290)
                    .fixedSize(horizontal: false, vertical: true)
            }
            if showsText {
                Text(text)
                    .tuiTypography(.bodyMedium)
                    .foregroundStyle(TUIColor.textSecondary)
                    .frame(maxWidth: 290)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: type == .card ? .infinity : nil)
        .accessibilityElement(children: .combine)
    }

    private var buttons: some View {
        VStack(spacing: TUISpacing.x2) {
            if showsSecondaryButton && type == .card {
                actionButton(title: "Label", action: secondaryAction, hasBackground: true)
                    .padding(.top, TUISpacing.x6)
            }
            actionButton(
                title: "Label",
                action: primaryAction,
                hasBackground: type == .fullscreen || (type == .card && !showsSecondaryButton)
            )
            if showsSecondaryButton && type == .fullscreen {
                actionButton(title: "Label", action: secondaryAction, hasBackground: false)
            }
        }
        .frame(width: type == .fullscreen ? 290 : nil)
        .frame(maxWidth: type == .card ? .infinity : nil)
    }

    private func actionButton(title: String, action: @escaping () -> Void, hasBackground: Bool) -> some View {
        Button(action: action) {
            Text(title)
                .tuiTypography(.bodyMedium)
                .foregroundStyle(TUIColor.action)
                .padding(.horizontal, TUISpacing.x2)
                .padding(.vertical, TUISpacing.x0_5 + 1)
                .frame(minHeight: 44)
                .background {
                    if hasBackground {
                        RoundedRectangle(cornerRadius: TUIRadius.medium)
                            .fill(TUIColor.named("Background/Neutral 1", fallback: 0xF7F7F8))
                    }
                }
                .contentShape(RoundedRectangle(cornerRadius: TUIRadius.medium))
        }
        .buttonStyle(.plain)
    }
}
