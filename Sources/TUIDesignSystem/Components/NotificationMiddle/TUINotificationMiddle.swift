import SwiftUI

/// Centered notification surface from TUI Mobile. Pass nil to hide the caption.
public struct TUINotificationMiddle<Icon: View>: View {
    public let text: String?
    @ViewBuilder public let icon: Icon
    @Environment(\.colorScheme) private var colorScheme

    public init(text: String? = "Text", @ViewBuilder icon: () -> Icon) {
        self.text = text
        self.icon = icon()
    }

    public var body: some View {
        VStack(spacing: text == nil ? 0 : TUISpacing.x4) {
            icon.frame(width: 40, height: 40)
            if let text {
                Text(text)
                    .tuiTypography(.bodyMedium)
                    .foregroundStyle(TUIColor.named("Text/Primary"))
                    .frame(minWidth: 100, maxWidth: 300)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, TUISpacing.x5)
        .padding(.vertical, text == nil ? TUISpacing.x5 : TUISpacing.x8)
        .fixedSize(horizontal: true, vertical: false)
        .background(TUIColor.named("Background/Elevation 3"), in: RoundedRectangle(cornerRadius: 20))
        .shadow(
            color: TUIShadow.popupColor,
            radius: TUIShadow.popupBlur(theme: colorScheme == .dark ? .night : .day),
            x: 0,
            y: TUIShadow.popupYOffset(theme: colorScheme == .dark ? .night : .day)
        )
        .accessibilityElement(children: .combine)
    }
}

public extension TUINotificationMiddle where Icon == TUILoader {
    init(text: String? = "Text") {
        self.init(text: text) { TUILoader(size: .x40) }
    }
}
