import SwiftUI

/// The six Figma `tui-rating` states (0…5), rendered as interactive SwiftUI controls.
public struct TUIRating: View {
    @Binding public var value: Int
    public let isEnabled: Bool

    public init(value: Binding<Int>, isEnabled: Bool = true) {
        _value = value
        self.isEnabled = isEnabled
    }

    public var body: some View {
        HStack(spacing: 16) {
            ForEach(1...5, id: \.self) { index in
                Button {
                    value = index
                } label: {
                    Image(index <= value ? "tui-rating-star-filled" : "tui-rating-star-empty", bundle: .module)
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                .buttonStyle(.plain)
                .disabled(!isEnabled)
                .accessibilityLabel("\(index) из 5")
                .accessibilityAddTraits(index == value ? .isSelected : [])
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Оценка")
        .accessibilityValue("\(value) из 5")
    }
}
