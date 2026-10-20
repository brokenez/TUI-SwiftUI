import SwiftUI

public enum TUIListSize: String, CaseIterable, Sendable {
    case large = "Body L"
    case medium = "Body M"
    case small = "UI S"

    var fontSize: CGFloat {
        switch self {
        case .large: 17
        case .medium: 15
        case .small: 13
        }
    }

    // These values are measured on the list component text nodes. The older
    // component file differs slightly from the current Foundation token values.
    var componentLetterSpacing: CGFloat {
        switch self {
        case .large: -0.41
        case .medium: -0.24
        case .small: -0.08
        }
    }

    var markerTopPadding: CGFloat { self == .large ? 7 : 6 }
    var numberWidth: CGFloat { self == .large ? 14 : 12 }
    func rowWidth(isNumbered: Bool) -> CGFloat {
        if isNumbered {
            switch self {
            case .large: 383
            case .medium: 381
            case .small: 366
            }
        } else {
            self == .small ? 360 : 375
        }
    }
}

/// A single iOS row from `tui-list-item [bulleted]` or `tui-list-item [numbered]`.
public struct TUIListItem: View {
    public enum Marker: Sendable {
        case bullet
        case number(String)
    }

    public let text: String
    public let size: TUIListSize
    public let marker: Marker
    public let numberColumnWidth: CGFloat?

    public var figmaNodeID: String {
        switch (marker, size) {
        case (.bullet, .large): "53190:295268"
        case (.bullet, .medium): "53190:295277"
        case (.bullet, .small): "53190:295286"
        case (.number, .large): "79180:42850"
        case (.number, .medium): "79180:42855"
        case (.number, .small): "79180:42860"
        }
    }

    public init(_ text: String, size: TUIListSize = .large, marker: Marker = .bullet, numberColumnWidth: CGFloat? = nil) {
        self.text = text
        self.size = size
        self.marker = marker
        self.numberColumnWidth = numberColumnWidth
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 12) {
            switch marker {
            case .bullet:
                TUIBullet(type: .accent)
                    .padding(.top, size.markerTopPadding)
                    .accessibilityHidden(true)
            case .number(let label):
                Text(label)
                    .font(.system(size: size.fontSize, weight: .regular))
                    .tracking(size.componentLetterSpacing)
                    .foregroundStyle(TUIColor.textPrimary)
                    .frame(width: numberColumnWidth ?? size.numberWidth, alignment: .trailing)
                    .accessibilityHidden(true)
            }

            Text(text)
                .font(.system(size: size.fontSize, weight: .regular))
                .tracking(size.componentLetterSpacing)
                .foregroundStyle(TUIColor.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.leading, 16)
        .padding(.trailing, 16)
        .padding(.vertical, 8)
        .frame(width: size.rowWidth(isNumbered: isNumbered), alignment: .leading)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityText)
        .accessibilityIdentifier(figmaNodeID)
    }

    private var accessibilityText: String {
        switch marker {
        case .bullet: text
        case .number(let label): "\(label) \(text)"
        }
    }

    private var isNumbered: Bool {
        if case .number = marker { return true }
        return false
    }
}

/// The reusable iOS `tui-list` layout with any number of entries.
public struct TUIList: View {
    public enum Style: Sendable {
        case bulleted
        case numbered(startingAt: Int = 1)
    }

    public let items: [String]
    public let size: TUIListSize
    public let style: Style

    public init(_ items: [String], size: TUIListSize = .large, style: Style = .bulleted) {
        self.items = items
        self.size = size
        self.style = style
    }

    public var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                TUIListItem(item, size: size, marker: marker(at: index), numberColumnWidth: listNumberWidth)
            }
        }
    }

    private var listNumberWidth: CGFloat? {
        if case .numbered = style { return 14 }
        return nil
    }

    private func marker(at index: Int) -> TUIListItem.Marker {
        switch style {
        case .bulleted: .bullet
        case .numbered(let start): .number("\(start + index).")
        }
    }
}
