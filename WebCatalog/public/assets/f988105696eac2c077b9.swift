import SwiftUI

/// A single-screen onboarding or status page with a TUI illustration and native sheet navigation.
/// Embed it in a `NavigationStack` presented as an iOS sheet to provide the native close toolbar item.
public struct TUIIllustrationScreen: View {
    public let title: String
    public let subtitle: String
    public let showPlaceholder: Bool
    public let closeTitle: String
    public let primaryTitle: String
    public let secondaryTitle: String?
    public let illustration: Image
    private let onClose: () -> Void
    private let primaryAction: () -> Void
    private let secondaryAction: () -> Void
    @Environment(\.dismiss) private var dismiss

    public init(
        title: String,
        subtitle: String,
        showPlaceholder: Bool = false,
        closeTitle: String = "Закрыть",
        primaryTitle: String = "Main action",
        secondaryTitle: String? = "Secondary action",
        illustration: Image? = nil,
        onClose: @escaping () -> Void = {},
        primaryAction: @escaping () -> Void = {},
        secondaryAction: @escaping () -> Void = {}
    ) {
        self.title = title
        self.subtitle = subtitle
        self.showPlaceholder = showPlaceholder
        self.closeTitle = closeTitle
        self.primaryTitle = primaryTitle
        self.secondaryTitle = secondaryTitle
        self.illustration = illustration ?? Image("tui-illustration-briefcase-light", bundle: .module)
        self.onClose = onClose
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }

    public var body: some View {
        VStack(spacing: 0) {
            illustrationSection
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .layoutPriority(1)

            textSection
                .padding(.horizontal, TUISpacing.x4)
                .padding(.bottom, TUISpacing.x3)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(TUIColor.named("Background/Elevation 1"))
        .safeAreaInset(edge: .bottom, spacing: 0) {
            actionSection
                .frame(maxWidth: 322)
                .frame(maxWidth: .infinity)
                .padding(.top, TUISpacing.x2)
                .padding(.bottom, TUISpacing.x2)
                .background(TUIColor.named("Background/Elevation 1"))
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(closeTitle) {
                    onClose()
                    dismiss()
                }
                .tuiTypography(.bodyLarge)
                .tint(TUIColor.named("Text/Action"))
                .accessibilityHint("Закрывает экран")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private var illustrationSection: some View {
        illustration
            .resizable()
            .scaledToFit()
            .frame(width: 220, height: 220)
            .accessibilityHidden(true)
            .padding(TUISpacing.x8)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var textSection: some View {
        VStack(spacing: TUISpacing.x2) {
            Text(title)
                .tuiTypography(.headingSmall)
                .foregroundStyle(TUIColor.named("Text/Primary"))
                .frame(maxWidth: .infinity)
                .fixedSize(horizontal: false, vertical: true)

            Text(subtitle)
                .tuiTypography(.bodyMedium)
                .foregroundStyle(TUIColor.named("Text/Secondary"))
                .frame(maxWidth: .infinity)
                .fixedSize(horizontal: false, vertical: true)

            if showPlaceholder {
                Text("Replace me")
                    .tuiTypography(.bodyMedium)
                    .foregroundStyle(TUIColor.named("Text/Secondary"))
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .overlay {
                        RoundedRectangle(cornerRadius: TUIRadius.small)
                            .strokeBorder(TUIColor.named("Text/Secondary"), style: StrokeStyle(lineWidth: 0.5, dash: [4, 3]))
                    }
                    .padding(.top, TUISpacing.x2)
            }
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: 290, minHeight: 140, alignment: .top)
    }

    private var actionSection: some View {
        VStack(spacing: TUISpacing.x2) {
            TUIButton(primaryTitle, appearance: .primary, size: .large, action: primaryAction)
                .frame(maxWidth: .infinity)

            if let secondaryTitle {
                TUIButton(secondaryTitle, appearance: .flat, size: .large, action: secondaryAction)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}
