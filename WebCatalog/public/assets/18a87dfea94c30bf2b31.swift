import SwiftUI

/// Transaction detail summary used in operation-result screens.
public struct TUIBlockDetails: View {
    public var titleValueText: String
    public var titleDescriptionText: String
    public var amountDescriptionText: String
    public var commentText: String
    public var showAmount: Bool
    public var showAmountDescription: Bool
    public var showAmountDescription2: Bool
    public var showBadges: Bool
    public var showComment: Bool
    public var showStatus: Bool
    public var showTitleDescription: Bool
    public var skeleton: Bool
    public var preview: Image?
    public var iconStatus: Image?

    public init(
        titleValueText: String = "TitleValue",
        titleDescriptionText: String = "TitleDescription",
        amountDescriptionText: String = "AmountDescription",
        commentText: String = "Comment",
        showAmount: Bool = true,
        showAmountDescription: Bool = true,
        showAmountDescription2: Bool = false,
        showBadges: Bool = true,
        showComment: Bool = true,
        showStatus: Bool = true,
        showTitleDescription: Bool = true,
        skeleton: Bool = false,
        preview: Image? = nil,
        iconStatus: Image? = nil
    ) {
        self.titleValueText = titleValueText
        self.titleDescriptionText = titleDescriptionText
        self.amountDescriptionText = amountDescriptionText
        self.commentText = commentText
        self.showAmount = showAmount
        self.showAmountDescription = showAmountDescription
        self.showAmountDescription2 = showAmountDescription2
        self.showBadges = showBadges
        self.showComment = showComment
        self.showStatus = showStatus
        self.showTitleDescription = showTitleDescription
        self.skeleton = skeleton
        self.preview = preview
        self.iconStatus = iconStatus
    }

    public var body: some View {
        VStack(spacing: 0) {
            avatar
                .frame(height: 80)

            VStack(spacing: TUISpacing.x1) {
                if skeleton {
                    TUISkeleton(width: 92, height: 14)
                } else {
                    Text(titleValueText)
                        .tuiTypography(.bodyLarge)
                        .foregroundStyle(TUIColor.named("Text/Primary"))
                        .multilineTextAlignment(.center)
                }

                if showTitleDescription {
                    if skeleton {
                        TUISkeleton(width: 70, height: 10)
                    } else {
                        Text(titleDescriptionText)
                            .tuiTypography(.uiSmall)
                            .foregroundStyle(TUIColor.named("Text/Secondary"))
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, TUISpacing.x4)

            if showAmount {
                VStack(spacing: TUISpacing.x1) {
                    if skeleton {
                        TUISkeleton(width: 127, height: 24)
                    } else {
                        Text("−123\u{2006}₽")
                            .tuiTypography(.numberXLarge)
                            .foregroundStyle(TUIColor.named("Text/Primary"))
                    }
                    if showAmountDescription {
                        if skeleton {
                            TUISkeleton(width: 70, height: 10)
                        } else {
                            Text(amountDescriptionText)
                                .tuiTypography(.uiSmall)
                                .foregroundStyle(TUIColor.named("Text/Secondary"))
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                .padding(.top, TUISpacing.x5)
                .frame(maxWidth: .infinity)
            }

            if showAmountDescription2 {
                Group {
                    if skeleton {
                        TUISkeleton(width: 48, height: 12)
                    } else {
                        Text("ExtraDescription")
                            .tuiTypography(.uiSmall)
                            .foregroundStyle(TUIColor.named("Text/Secondary"))
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, TUISpacing.x4)
            }

            if showComment {
                comment
                    .padding(.top, 9)
            }

            if showBadges {
                if skeleton {
                    Capsule()
                        .fill(TUIColor.named("Service/Skeleton"))
                        .frame(width: 82, height: 24)
                        .padding(.top, TUISpacing.x5)
                } else {
                    badge
                        .padding(.top, TUISpacing.x5)
                }
            }

            if showStatus {
                Group {
                    if skeleton {
                        TUISkeleton(width: 48, height: 12)
                    } else {
                        HStack(spacing: TUISpacing.x1) {
                            if let iconStatus {
                                iconStatus
                                    .resizable()
                                    .frame(width: 16, height: 16)
                            } else {
                                Image("tui-block-details-clock", bundle: .module)
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                    .foregroundStyle(TUIColor.named("Background/Neutral 4"))
                            }
                            Text("Status")
                                .tuiTypography(.uiSmall)
                                .foregroundStyle(TUIColor.named("Text/Secondary"))
                        }
                    }
                }
                .padding(.top, TUISpacing.x5)
            }
        }
        .padding(.horizontal, TUISpacing.x4)
        .padding(.top, TUISpacing.x4)
        .padding(.bottom, TUISpacing.x8)
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Детали операции")
    }

    @ViewBuilder
    private var avatar: some View {
        if skeleton {
            Circle()
                .fill(TUIColor.named("Service/Skeleton"))
                .frame(width: 80, height: 80)
        } else if let preview {
            preview
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
        } else {
            Image("tui-block-details-avatar", bundle: .module)
                .resizable()
                .interpolation(.high)
                .frame(width: 80, height: 80)
                .clipShape(Circle())
        }
    }

    private var comment: some View {
        VStack(spacing: 0) {
            Image(skeleton ? "tui-block-details-skeleton-tail" : "tui-block-details-comment-tail", bundle: .module)
                .resizable()
                .frame(width: 24, height: 12)
            if skeleton {
                TUISkeleton(width: 92, height: 34)
                    .clipShape(RoundedRectangle(cornerRadius: TUIRadius.xLarge))
            } else {
                Text(commentText)
                    .tuiTypography(.bodyMedium)
                    .foregroundStyle(TUIColor.named("Text/Primary On Dark"))
                    .padding(.horizontal, TUISpacing.x3)
                    .padding(.vertical, TUISpacing.x2)
                    .frame(minWidth: 64)
                    .background(TUIColor.named("Background/Accent 2"), in: RoundedRectangle(cornerRadius: TUIRadius.xLarge))
            }
        }
    }

    private var badge: some View {
        HStack(spacing: 0) {
            Image("tui-block-details-crown", bundle: .module)
                .resizable()
                .frame(width: 14, height: 11)
                .frame(width: 16, height: 16)
                .padding(.leading, TUISpacing.x1)
            Text("Badge")
                .tuiTypography(.uiSmallBold)
                .foregroundStyle(TUIColor.named("Text/Primary"))
                .padding(.horizontal, TUISpacing.x1)
                .padding(.vertical, 3.5)
        }
        .frame(minHeight: 24)
        .background(TUIColor.named("Background/Accent 1"), in: Capsule())
    }
}
