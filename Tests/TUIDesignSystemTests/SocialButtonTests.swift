import SwiftUI
import UIKit
import Testing
@testable import TUIDesignSystem

@Test @MainActor func socialButtonsMapAllEighteenIOSVariants() {
    var shareIDs: Set<String> = []
    var likeIDs: Set<String> = []
    let catalog = TUILibraryCatalog.shared
    let shareVariants = catalog.variants(for: "44290:299199")
    let likeVariants = catalog.variants(for: "44290:299166")
    for appearance in TUISocialButtonAppearance.allCases {
        for state in TUISocialButtonState.allCases {
            let share = TUIButtonShare(appearance: appearance, state: state) {}
            shareIDs.insert(share.figmaNodeID)
            let source = shareVariants.first { $0.id == share.figmaNodeID }
            #expect(source?.properties["appearance"] == appearance.rawValue)
            #expect(source?.properties["state"] == state.rawValue)
            #expect(source?.properties["system"] == "ios")
            #expect(source?.width == 44 && source?.height == 44)
            for selected in [false, true] {
                let like = TUIButtonLike(isSelected: .constant(selected), appearance: appearance, state: state)
                likeIDs.insert(like.figmaNodeID)
                let source = likeVariants.first { $0.id == like.figmaNodeID }
                #expect(source?.properties["appearance"] == appearance.rawValue)
                #expect(source?.properties["state"] == state.rawValue)
                #expect(source?.properties["is-selected"] == (selected ? "on" : "off"))
                #expect(source?.properties["system"] == "ios")
                #expect(source?.width == 44 && source?.height == 44)
            }
        }
    }
    #expect(shareIDs.count == 6 && shareIDs == Set(shareVariants.map(\.id)))
    #expect(likeIDs.count == 12 && likeIDs == Set(likeVariants.map(\.id)))
    #expect(TUIButtonShare {}.accessibilityLabel == "Поделиться")
    #expect(TUIButtonLike(isSelected: .constant(false)).accessibilityLabel == "В избранное")
}

@Test @MainActor func socialButtonsKeepTenPointInsetsAndCapAX1Growth() {
    // Actual hosted sizes across normal, XXXL, AX1 and AX5, both themes, every state.
    // Expectations come from the specification's 24/30 pt glyph and 10 pt inset.
    for typeSize in [DynamicTypeSize.large, .xxxLarge, .accessibility1, .accessibility5] {
        let expected: CGFloat = typeSize.isAccessibilitySize ? 50 : 44
        let expectedIcon: CGFloat = typeSize.isAccessibilitySize ? 30 : 24
        #expect(TUISocialButtonMetrics.iconSize(for: typeSize) == expectedIcon)
        for scheme in [ColorScheme.light, .dark] {
            for appearance in TUISocialButtonAppearance.allCases {
                for state in TUISocialButtonState.allCases {
                    let share = UIHostingController(rootView:
                        TUIButtonShare(appearance: appearance, state: state) {}
                            .dynamicTypeSize(typeSize).environment(\.colorScheme, scheme))
                    let size = share.sizeThatFits(in: CGSize(width: 320, height: 200))
                    #expect(abs(size.width - expected) < 0.01 && abs(size.height - expected) < 0.01)
                    for selected in [false, true] {
                        let like = UIHostingController(rootView:
                            TUIButtonLike(isSelected: .constant(selected), appearance: appearance, state: state)
                                .dynamicTypeSize(typeSize).environment(\.colorScheme, scheme))
                        let size = like.sizeThatFits(in: CGSize(width: 320, height: 200))
                        #expect(abs(size.width - expected) < 0.01 && abs(size.height - expected) < 0.01)
                    }
                }
            }
        }
    }
}
