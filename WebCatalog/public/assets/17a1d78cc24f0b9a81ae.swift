import SwiftUI

/// The reusable circular avatar with the two compact labels used by `tui-row [avatar-labelled]`.
public struct TUIAvatarLabelled: View {
    public let title: String
    public let subtitle: String

    public init(title: String = "Avatar label", subtitle: String = "Avatar label") {
        self.title = title
        self.subtitle = subtitle
    }

    public var body: some View {
        VStack(spacing: 6) {
            Image("tui-avatar-labelled-star", bundle: .module)
                .resizable()
                .frame(width: 34, height: 34)
                .frame(width: 56, height: 56)
                .background(TUIColor.named("Background/Accent 2"), in: Circle())
                .padding(.leading, TUISpacing.x2)
                .frame(width: 72, alignment: .leading)

            VStack(spacing: 0) {
                Text(title)
                Text(subtitle)
            }
            .tuiTypography(.uiXSmall)
            .foregroundStyle(TUIColor.named("Text/Primary"))
            .multilineTextAlignment(.center)
            .frame(width: 72)
        }
        .frame(width: 72)
        .accessibilityElement(children: .combine)
    }
}

/// The iOS avatar-labelled row from TUI Mobile, including its six clipped items.
public struct TUIRowAvatarLabelled: View {
    public let labels: [(title: String, subtitle: String)]
    public static let figmaNodeID = "53606:308727"

    public init(labels: [(title: String, subtitle: String)] = Array(repeating: ("Avatar label", "Avatar label"), count: 6)) {
        self.labels = labels
    }

    public var body: some View {
        HStack(spacing: TUISpacing.x3) {
            ForEach(labels.indices, id: \.self) { index in
                TUIAvatarLabelled(title: labels[index].title, subtitle: labels[index].subtitle)
            }
        }
        .padding(.leading, TUISpacing.x2)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 90, alignment: .top)
        .clipped()
        .accessibilityElement(children: .contain)
    }
}
