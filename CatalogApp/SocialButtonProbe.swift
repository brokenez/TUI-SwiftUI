#if DEBUG
import SwiftUI
import TUIDesignSystem

/// Uses the production components in a real scene for UI actions and material captures.
struct SocialButtonProbe: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var selected: Bool
    @State private var taps = 0
    private let specificationBackdrop: Bool
    private let isLike: Bool
    private let appearance: TUISocialButtonAppearance
    private let state: TUISocialButtonState
    private let theme: TUITheme
    private let typeSize: DynamicTypeSize
    private let label: String

    init() {
        let arguments = ProcessInfo.processInfo.arguments
        func value(_ key: String) -> String? {
            guard let index = arguments.firstIndex(of: key), index + 1 < arguments.count else { return nil }
            return arguments[index + 1]
        }
        specificationBackdrop = arguments.contains("--spec-dark-backdrop")
        isLike = value("--kind") == "like"
        appearance = TUISocialButtonAppearance(rawValue: value("--appearance") ?? "secondary") ?? .secondary
        state = TUISocialButtonState(rawValue: value("--state") ?? "normal") ?? .normal
        theme = value("--theme") == "night" ? .night : .day
        switch value("--type-size") {
        case "AX1": typeSize = .accessibility1
        case "AX5": typeSize = .accessibility5
        case "XXXL": typeSize = .xxxLarge
        default: typeSize = .large
        }
        _selected = State(initialValue: value("--selected") == "on")
        label = value("--label") ?? (isLike ? "В избранное" : "Поделиться")
    }

    var body: some View {
        if specificationBackdrop {
            specificationBoard
        } else {
            regularProbe
        }
    }

    private var specificationBoard: some View {
        // Exact 705 x 628 source preview; only the iOS column is recreated.
        // This fixture is catalog-only evidence, never a production background.
        ZStack(alignment: .topLeading) {
            Image("social-spec-dark").resizable().scaledToFill()
                .frame(width: 705, height: 628).clipped()
            ForEach(0..<4, id: \.self) { index in
                let row = [0, 3, 4, 6][index]
                TUIButtonLike(isSelected: .constant(index >= 2), appearance: .glassOnDark,
                    state: index == 1 || index == 3 ? .pressed : .normal)
                    .position(x: 298.5, y: CGFloat(62 + row * 84))
            }
        }
        .frame(width: 705, height: 628)
        .fixedSize()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .environment(\.colorScheme, .light)
        .dynamicTypeSize(.large)
        .navigationTitle("Source backdrop QA")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var regularProbe: some View {
        VStack(spacing: TUISpacing.x8) {
            Text(isLike ? "Like" : "Share")
            Text("\(appearance.rawValue) · \(state.rawValue)").font(.caption)
            Spacer()
            Group {
                if isLike {
                    TUIButtonLike(isSelected: $selected, appearance: appearance, state: state,
                        accessibilityLabel: label) { taps += 1 }
                } else {
                    TUIButtonShare(appearance: appearance, state: state,
                        accessibilityLabel: label) { taps += 1 }
                }
            }
            .dynamicTypeSize(typeSize)
            Spacer()
            Text("\(taps)").accessibilityIdentifier("socialProbeTapCount")
            Text(selected ? "on" : "off").accessibilityIdentifier("socialProbeSelection")
            Text(String(describing: scenePhase)).accessibilityIdentifier("socialProbeScene")
        }
        .padding(TUISpacing.x4)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme == .night ? Color.black : Color.white)
        .environment(\.colorScheme, theme == .night ? .dark : .light)
        .navigationTitle("Social button QA")
        .navigationBarTitleDisplayMode(.inline)
    }
}
#endif
