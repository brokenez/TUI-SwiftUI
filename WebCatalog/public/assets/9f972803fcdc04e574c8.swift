import SwiftUI

public enum TUIRowButtonVerticalQuantity: String, CaseIterable, Hashable, Sendable {
    case oneToThree = "1-3"
    case fourOrMore = "4+"

    public var figmaNodeID: String {
        switch self {
        case .oneToThree: "48183:324280"
        case .fourOrMore: "48700:323898"
        }
    }

    fileprivate var visibleCount: Int { self == .oneToThree ? 3 : 4 }
}

/// A clipped horizontal row of vertical action buttons from TUI Mobile.
public struct TUIRowButtonVertical: View {
    public let quantity: TUIRowButtonVerticalQuantity
    public let labels: [String]
    public let onTap: (Int) -> Void

    public init(
        quantity: TUIRowButtonVerticalQuantity = .oneToThree,
        labels: [String] = ["Label", "Label", "Label", "Label"],
        onTap: @escaping (Int) -> Void = { _ in }
    ) {
        self.quantity = quantity
        self.labels = labels
        self.onTap = onTap
    }

    public var body: some View {
        HStack(spacing: TUISpacing.x3) {
            ForEach(Array(labels.prefix(quantity.visibleCount).enumerated()), id: \.offset) { index, label in
                TUIButtonVertical(label) {
                    onTap(index)
                }
            }
        }
        .frame(width: 375, height: 70, alignment: quantity == .oneToThree ? .center : .leading)
        .padding(.horizontal, quantity == .oneToThree ? 0 : TUISpacing.x4)
        .frame(width: 375, alignment: .leading)
        .clipped()
    }
}
