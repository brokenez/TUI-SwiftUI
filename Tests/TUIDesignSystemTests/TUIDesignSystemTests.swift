import Testing
import CoreGraphics
import SwiftUI
import UIKit
@testable import TUIDesignSystem

@MainActor
@Test func checkiconPreservesFigmaRowHeightsForEveryContentCombination() {
    // Figma TextCont: caption 16, title 20, description 16, gaps 4,
    // vertical insets 8 and minimum cell height 56. Measure actual SwiftUI
    // hosting layout to catch fractional intrinsic font heights.
    for variant in TUICellCheckicon.Variant.allCases {
        for options in 0..<16 {
            let caption = options & 2 != 0
            let description = options & 4 != 0
            let cell = TUICellCheckicon(
                variant: variant, showAvatar: options & 1 != 0,
                showCaption: caption, showDescription: description,
                showSelected: options & 8 != 0, action: {}
            )
            let host = UIHostingController(rootView: cell.frame(width: 375)
                .environment(\.dynamicTypeSize, .large))
            let size = host.sizeThatFits(in: CGSize(width: 375, height: 1_000))
            let expectedHeight: CGFloat = caption && description ? 76 : 56
            // Flexible text uses natural font leading; Figma reports whole
            // points while UIKit snaps the hosting measurement to device pixels.
            // Fixed and skeleton containers must retain exact source heights.
            let heightTolerance: CGFloat = variant == .flexibleHeight ? 1.0 / 3.0 + 0.0001 : 0.01
            #expect(abs(size.width - 375) < 0.01)
            #expect(abs(size.height - expectedHeight) < heightTolerance,
                    "Figma height mismatch: \(variant), content options \(options), actual \(size.height)")
        }
    }
}

@Test func tokenCatalogLoadsFigmaCollections() {
    let names = TUITokenCatalog.shared.collectionNames
    #expect(names.contains("Primitive"))
    #expect(names.contains("Theme"))
    #expect(names.contains("Platform"))
    #expect(names.contains("State"))
}

@Test func libraryCatalogLoadsCompleteFigmaIndexes() {
    #expect(TUILibraryCatalog.shared.components.count == 128)
    #expect(TUILibraryCatalog.shared.assets.count == 3_518)
    #expect(TUILibraryCatalog.shared.variants.count == 3_927)
    #expect(TUILibraryCatalog.shared.components.filter { !$0.specificationURLs.isEmpty }.count == 108)
    #expect(TUILibraryCatalog.shared.variants.filter(\.isIOS).count == 2_008)
    #expect(TUILibraryCatalog.shared.variants(for: "55278:70443").count == 15)
    #expect(TUILibraryCatalog.shared.variants(for: "41658:296906").count == 147)
}

@Test func catalogLoadsGeneratedReadinessAndSeparatesHistoricalVariants() {
    let catalog = TUILibraryCatalog.shared
    #expect(catalog.coverageEntries.count == catalog.components.count)
    #expect(Set(catalog.coverageEntries.map(\.id)) == Set(catalog.components.map(\.id)))
    #expect(catalog.variants.filter(\.isHistoricalIOS18).count == 75)
    #expect(catalog.coverageEntries.reduce(0) { $0 + $1.applicableVariantCount } == 1_933)
    #expect(catalog.coverageEntries.reduce(0) { $0 + $1.historicalVariantCount } == 75)
    #expect(catalog.coverage(for: "41637:306903")?.applicableVariantCount == 3)
    #expect(catalog.coverage(for: "9151:1662")?.historicalVariantCount == 1)
    #expect(catalog.coverage(for: "not-a-component") == nil)
}

@MainActor @Test func buttonStylesCoverEveryImportedIOSVariant() {
    #expect(TUIButton.importedVariantCount == 147)
}

@Test func paymentLogosMapEveryImportedFigmaVariant() {
    let variants = TUILibraryCatalog.shared.variants(for: "45931:47324")
    let networks = TUIPaymentLogo.Network.allCases

    #expect(networks.count == 13)
    #expect(variants.count == networks.count)
    #expect(Set(networks.map(\.figmaNodeID)) == Set(variants.map(\.id)))

    for network in networks {
        #expect(variants.contains {
            $0.id == network.figmaNodeID && $0.properties["logo"] == network.rawValue
        })
    }
}

@Test func underlinesMapBothImportedFigmaSets() {
    let catalog = TUILibraryCatalog.shared
    for style in TUIUnderline.Style.allCases {
        let variants = catalog.variants(for: style.figmaComponentSetID)
        #expect(variants.count == 2)
        #expect(Set([style.figmaVariantID(pseudo: false), style.figmaVariantID(pseudo: true)]) == Set(variants.map(\.id)))
        #expect(variants.contains { $0.properties["pseudo"] == "No" })
        #expect(variants.contains { $0.properties["pseudo"] == "Yes" })
    }
}

@MainActor
@Test func spacingIndicatorCoversTheImportedFigmaScale() {
    let catalog = TUILibraryCatalog.shared
    let variants = catalog.variants(for: "28406:482266")
    let sizeCases = TUISpacingIndicator.Size.allCases
    var expectedVariantIDs: Set<String> = []

    for size in sizeCases {
        #expect(size.points == CGFloat(Int(size.label) ?? -1))
        let ids = size.figmaVariantIDs
        expectedVariantIDs.insert(ids.visible)
        #expect(variants.contains {
            $0.id == ids.visible && $0.properties["Size"] == size.rawValue && $0.properties["Visible"] == "on"
        })
        if let hiddenID = ids.hidden {
            expectedVariantIDs.insert(hiddenID)
            #expect(variants.contains {
                $0.id == hiddenID && $0.properties["Size"] == size.rawValue && $0.properties["Visible"] == "off"
            })
        }
    }

    #expect(TUISpacingIndicator(size: .x2, visible: false).figmaVariantID == "28406:482305")
    #expect(TUISpacing.x0_5 == 2)
    #expect(variants.count == 21)
    #expect(expectedVariantIDs == Set(variants.map(\.id)))
}

@Test func bulletTypesMapEveryImportedFigmaVariant() {
    let variants = TUILibraryCatalog.shared.variants(for: "53309:296335")
    let types = TUIBulletType.allCases

    #expect(variants.count == 3)
    #expect(types.count == variants.count)
    #expect(Set(types.map(\.figmaNodeID)) == Set(variants.map(\.id)))

    for type in types {
        #expect(variants.contains {
            $0.id == type.figmaNodeID && $0.properties["Type"] == type.rawValue
        })
    }
}

@MainActor @Test func counterMapsEveryIOSSizeAndPresetVariant() {
    let variants = TUILibraryCatalog.shared.variants(for: "16661:51922").filter { $0.properties["System"] == "iOS" }
    var expectedIDs: Set<String> = []

    for size in TUICounter.Size.allCases {
        for preset in TUICounter.Preset.allCases {
            let counter = TUICounter(value: .constant(2), size: size, preset: preset)
            let expectedID = counter.figmaNodeID
            expectedIDs.insert(expectedID)
            let variant = variants.first {
                $0.id == expectedID &&
                $0.properties["Size"] == size.rawValue &&
                $0.properties["Preset"] == preset.rawValue &&
                $0.properties["System"] == "iOS"
            }
            #expect(variant != nil)
            #expect(variant?.width == 200)
            #expect(variant?.height == Double(size.height))
        }
    }

    #expect(variants.count == 9)
    #expect(expectedIDs == Set(variants.map(\.id)))
}

@Test func chipGroupSetsMapEveryIOSLayoutVariant() {
    let catalog = TUILibraryCatalog.shared
    let expected: [String: [(id: String, scrollable: String, size: String, alignment: String?, width: Double, height: Double)]] = [
        "115603:32334": [
            ("115603:32335", "on", "S", nil, 375, 46),
            ("115603:32343", "on", "M", nil, 375, 52),
            ("115603:32367", "off", "S", nil, 375, 84),
            ("115603:32397", "off", "M", nil, 375, 96)
        ],
        "44286:300575": [
            ("44286:300576", "on", "S", "Start", 375, 46),
            ("44286:300584", "on", "M", "Start", 375, 52),
            ("44286:300608", "off", "S", "Start", 375, 84),
            ("44286:300623", "off", "M", "Start", 375, 96),
            ("513:134820", "off", "S", "Center", 375, 84),
            ("513:134835", "off", "M", "Center", 375, 96)
        ],
        "44286:300668": [
            ("44286:300669", "on", "S", "Start", 375, 46),
            ("44286:300677", "on", "M", "Start", 375, 52),
            ("44286:300701", "off", "S", "Start", 375, 84),
            ("44286:300716", "off", "M", "Start", 375, 96),
            ("513:134424", "off", "S", "Center", 375, 84),
            ("513:134439", "off", "M", "Center", 375, 96)
        ],
        "44286:300482": [
            ("44286:300483", "on", "S", "Start", 375, 46),
            ("44286:300491", "on", "M", "Start", 375, 52),
            ("44286:300515", "off", "S", "Start", 375, 84),
            ("44286:300530", "off", "M", "Start", 375, 96),
            ("513:134095", "off", "S", "Center", 375, 84),
            ("513:134110", "off", "M", "Center", 375, 96)
        ]
    ]

    for (setID, references) in expected {
        let variants = catalog.variants(for: setID).filter { $0.properties["System"] == "iOS" }
        #expect(variants.count == references.count)
        #expect(Set(variants.map(\.id)) == Set(references.map(\.id)))
        for reference in references {
            let variant = variants.first { $0.id == reference.id }
            #expect(variant?.properties["Scrollable"] == reference.scrollable)
            #expect(variant?.properties["Size"] == reference.size)
            if let alignment = reference.alignment {
                #expect(variant?.properties["Alignment"] == alignment)
            } else {
                #expect(variant?.properties["Alignment"] == nil)
            }
            #expect(variant?.width == reference.width)
            #expect(variant?.height == reference.height)
        }
    }
}

@Test func chipLabelSizesMatchFigmaVariants() {
    let variants = TUILibraryCatalog.shared.variants(for: "42638:295990")
    for size in TUIChipSize.allCases {
        for leading in TUIChipLeadingContent.allCases {
            for trailing in TUIChipTrailingContent.allCases {
                let variant = variants.first {
                    $0.properties["system"] == "ios"
                        && $0.properties["size"] == size.rawValue
                        && $0.properties["appearance"] == "neutral"
                        && $0.properties["left content"] == leading.rawValue
                        && $0.properties["right content"] == trailing.rawValue
                        && $0.properties["skeleton"] == "off"
                        && $0.properties["is-disable"] == "off"
                }
                #expect(variant?.width == Double(size.minimumWidth(leading: leading, trailing: trailing)))
                #expect(variant?.height == Double(size.height))
            }
        }
    }
}

@MainActor @Test func textExpandableMapsEveryIOSStyleSizeAndSkeletonVariant() {
    let expected: [(id: String, size: TUITextExpandable.Size, style: TUITextExpandable.Style, skeleton: Bool, width: Double, height: Double)] = [
        ("49808:291011", .uiSmall, .primary, false, 375, 80),
        ("49808:291020", .uiSmall, .secondary, false, 360, 80),
        ("44305:306528", .bodyMedium, .primary, false, 375, 106),
        ("44305:306611", .bodyMedium, .secondary, false, 375, 106),
        ("49780:289467", .bodyLarge, .primary, false, 375, 116),
        ("49780:289476", .bodyLarge, .secondary, false, 375, 116),
        ("56039:297548", .bodyLarge, .primary, true, 375, 98),
        ("56039:297557", .bodyMedium, .primary, true, 375, 90),
        ("56039:297566", .uiSmall, .primary, true, 375, 80)
    ]
    let imported = TUILibraryCatalog.shared.variants(for: "44305:306527")
        .filter { $0.properties["System"] == "iOS" }

    #expect(imported.count == expected.count)
    #expect(Set(imported.map(\.id)) == Set(expected.map(\.id)))
    for item in expected {
        let component = TUITextExpandable("Example", size: item.size, style: item.style, isSkeleton: item.skeleton)
        let variant = imported.first { $0.id == item.id }
        #expect(component.figmaNodeID == item.id)
        #expect(variant?.properties["Size"] == item.size.rawValue)
        #expect(variant?.properties["Style"] == item.style.rawValue)
        #expect(variant?.properties["Skeleton"] == (item.skeleton ? "on" : "off"))
        #expect(variant?.width == item.width)
        #expect(variant?.height == item.height)
    }
    #expect(TUITextExpandable("Example", style: .secondary, isSkeleton: true).figmaNodeID == nil)
}

@Test func swipeActionsMapsEveryIOSContentsVariant() {
    let variants = TUILibraryCatalog.shared.variants(for: "53204:296101")
        .filter { $0.properties["System"] == "iOS" }
    #expect(variants.count == 2)
    #expect(Set(variants.map(\.id)) == Set(["53204:296102", "23373:45753"]))
    #expect(TUISwipeContents.cell.figmaNodeID == "53204:296102")
    #expect(TUISwipeContents.card.figmaNodeID == "23373:45753")
    #expect(variants.allSatisfy { $0.width == 405 })
    #expect(variants.first { $0.id == "53204:296102" }?.height == 56)
    #expect(variants.first { $0.id == "23373:45753" }?.height == 80)
}

@Test func walletButtonMapsBothIOSSizesAndFrameDimensions() {
    let variants = TUILibraryCatalog.shared.variants(for: "54757:286088")
        .filter { $0.properties["System"] == "iOS" }
    #expect(variants.count == 2)
    #expect(TUIButtonWallet.Size.large.figmaNodeID == "54757:286089")
    #expect(TUIButtonWallet.Size.medium.figmaNodeID == "54757:286101")
    #expect(TUIButtonWallet.Size.large.width == 343)
    #expect(TUIButtonWallet.Size.large.height == 56)
    #expect(TUIButtonWallet.Size.medium.width == 290)
    #expect(TUIButtonWallet.Size.medium.height == 48)
    #expect(variants.first { $0.id == "54757:286089" }?.width == 343)
    #expect(variants.first { $0.id == "54757:286089" }?.height == 56)
    #expect(variants.first { $0.id == "54757:286101" }?.width == 290)
    #expect(variants.first { $0.id == "54757:286101" }?.height == 48)
}

@Test func legacyFigmaFontRegistersTheExactTextFace() {
    let font = TUIFigmaTextFont.regular(size: 17)
    #expect(font.fontName == "SFProText-Regular")
    #expect(font.pointSize == 17)
}

@Test @MainActor func closeButtonRetainsInsetsWhenItsAccessibilityIconGrows() {
    let typeSizes: [DynamicTypeSize] = [.large, .xxxLarge, .accessibility1, .accessibility5]
    for size in TUIButtonClose.Size.allCases {
        for environment in TUIButtonClose.Environment.allCases {
            for typeSize in typeSizes {
                let button = TUIButtonClose(size: size, environment: environment) {}
                    .dynamicTypeSize(typeSize)
                let host = UIHostingController(rootView: button)
                let actual = host.sizeThatFits(in: CGSize(width: 100, height: 100))
                let expected = size.diameter + (typeSize.isAccessibilitySize ? 4 : 0)
                #expect(abs(actual.width - expected) < 0.01)
                #expect(abs(actual.height - expected) < 0.01)
            }
        }
    }
}

@Test @MainActor func closeButtonMapsEveryIOSVariantAndSize() {
    let variants = TUILibraryCatalog.shared.variants(for: "30258:432933")
        .filter { $0.properties["system"] == "ios" }
    let mapping: [(TUIButtonClose.Environment, TUITheme, TUIButtonClose.Size, String)] = [
        (.onBase, .day, .small, "30258:432918"),
        (.onBase, .night, .small, "38487:470419"),
        (.onBase, .day, .xSmall, "38502:471895"),
        (.onBase, .night, .xSmall, "38502:471897"),
        (.onLight, .day, .small, "30258:432950"),
        (.onLight, .day, .xSmall, "38502:471901"),
        (.onDark, .day, .small, "30263:433024"),
        (.onDark, .day, .xSmall, "38502:471899")
    ]
    #expect(variants.count == mapping.count)
    for (environment, theme, size, nodeID) in mapping {
        let button = TUIButtonClose(size: size, environment: environment, theme: theme) {}
        #expect(button.figmaNodeID == nodeID)
        let variant = variants.first { $0.id == nodeID }
        #expect(variant?.width == Double(size.diameter))
        #expect(variant?.height == Double(size.diameter))
        #expect(variant?.properties["environment"] == environment.rawValue)
        #expect(variant?.properties["size"] == size.rawValue)
        #expect(variant?.properties["Theme"] == (environment == .onBase ? (theme == .day ? "light" : "dark") : "—"))
    }
}

@Test func skeletonKeyframesMapEveryImportedFigmaVariant() {
    let variants = TUILibraryCatalog.shared.variants(for: "37840:45833")
    let keyframes = TUISkeletonKeyframe.allCases

    #expect(variants.count == 2)
    #expect(keyframes.count == variants.count)
    #expect(Set(variants.map(\.id)) == Set(["37840:45834", "37840:45835"]))
    #expect(Set(variants.compactMap { $0.properties["keyframe"] }) == Set(keyframes.map(\.rawValue)))
    #expect(variants.allSatisfy { $0.name == "keyframe=\($0.properties["keyframe"] ?? "")" })
}

@MainActor @Test func notificationBadgeMapsEveryIOSSizeVariant() {
    let variants = TUILibraryCatalog.shared.variants(for: TUINotificationBadge.figmaComponentSetID)
        .filter { $0.properties["system"] == "iOS" }
    let sizes = TUINotificationBadgeSize.allCases

    #expect(variants.count == 3)
    #expect(Set(variants.map(\.id)) == Set(sizes.map(\.figmaNodeID)))
    for size in sizes {
        #expect(variants.contains {
            $0.id == size.figmaNodeID &&
            $0.properties["size"] == size.rawValue &&
            $0.properties["system"] == "iOS"
        })
    }
}

@Test func typographyUsesExactFigmaMetrics() {
    let heading = TUITypographyRole.headingLarge.metrics
    #expect(heading.size == 30)
    #expect(heading.lineHeight == 36)
    #expect(abs(heading.letterSpacing - 0.4) < 0.000001)

    let body = TUITypographyRole.bodyLarge.metrics
    #expect(body.size == 17)
    #expect(body.lineHeight == 24)
    #expect(abs(body.letterSpacing + 0.43) < 0.000001)
}

@Test func motionUsesFigmaDurationTokens() {
    #expect(abs(TUIMotionDuration.fast.seconds - 0.15) < 0.0001)
    #expect(abs(TUIMotionDuration.moderate.seconds - 0.30) < 0.0001)
}

@MainActor @Test func listSizeMappingMatchesImportedIOSVariants() {
    let catalog = TUILibraryCatalog.shared
    for id in ["53190:295267", "79180:42849", "79180:42610", "79180:42880"] {
        #expect(catalog.variants(for: id).count == 3)
    }
    let expected = [
        TUIListSize.large: (id: "53190:295268", width: 375.0, height: 136.0),
        TUIListSize.medium: (id: "53190:295277", width: 375.0, height: 124.0),
        TUIListSize.small: (id: "53190:295286", width: 360.0, height: 96.0)
    ]
    let bulletVariants = catalog.variants(for: "53190:295267").filter { $0.properties["System"] == "iOS" }
    #expect(bulletVariants.count == expected.count)
    for size in TUIListSize.allCases {
        let reference = expected[size]!
        let variant = bulletVariants.first { $0.id == reference.id }
        #expect(variant?.properties["Size"] == size.rawValue)
        #expect(variant?.properties["Style"] == "Primary")
        #expect(variant?.width == reference.width)
        #expect(variant?.height == reference.height)
        #expect(TUIListItem("Text", size: size).figmaNodeID == reference.id)
    }
    let numberedVariants = catalog.variants(for: "79180:42849").filter { $0.properties["System"] == "IOS" }
    let numberedExpected = [
        TUIListSize.large: (id: "79180:42850", width: 383.0, height: 136.0),
        TUIListSize.medium: (id: "79180:42855", width: 381.0, height: 124.0),
        TUIListSize.small: (id: "79180:42860", width: 366.0, height: 96.0)
    ]
    #expect(numberedVariants.count == numberedExpected.count)
    for size in TUIListSize.allCases {
        let reference = numberedExpected[size]!
        let variant = numberedVariants.first { $0.id == reference.id }
        #expect(variant?.properties["Size"] == size.rawValue)
        #expect(variant?.width == reference.width)
        #expect(variant?.height == reference.height)
        #expect(TUIListItem("Text", size: size, marker: .number("1.")).figmaNodeID == reference.id)
    }
    #expect(TUIListSize.large.componentLetterSpacing == -0.41)
    #expect(TUIListSize.medium.componentLetterSpacing == -0.24)
    #expect(TUIListSize.small.componentLetterSpacing == -0.08)
}

@MainActor @Test func blockStatusMapsEveryIOSLayoutVariant() {
    let variants = TUILibraryCatalog.shared.variants(for: "43816:296648")
    let expected: [String: (String, String, Double, Double)] = [
        "43816:296051": ("Fullscreen", "on", 375, 266),
        "46719:307391": ("Fullscreen", "off", 375, 198),
        "46555:321088": ("Card", "on", 375, 214),
        "46719:307399": ("Card", "off", 375, 182)
    ]
    let iosVariants = variants.filter { $0.properties["System"] == "iOS" }
    #expect(iosVariants.count == expected.count)
    for (id, reference) in expected {
        let variant = iosVariants.first { $0.id == id }
        #expect(variant?.properties["Type"] == reference.0)
        #expect(variant?.properties["Button"] == reference.1)
        #expect(variant?.width == reference.2)
        #expect(variant?.height == reference.3)
    }
    #expect(TUIBlockStatus().figmaNodeID == "43816:296051")
    #expect(TUIBlockStatus(showsButton: false).figmaNodeID == "46719:307391")
    #expect(TUIBlockStatus(type: .card).figmaNodeID == "46555:321088")
    #expect(TUIBlockStatus(type: .card, showsButton: false).figmaNodeID == "46719:307399")
    #expect(TUIBlockStatus(type: .card, showsSecondaryButton: true).showsSecondaryButton)
}

@MainActor @Test func ratingMapsEveryIOSQuantityVariant() {
    let variants = TUILibraryCatalog.shared.variants(for: "10467:91596")
    let expected = [
        "0": "10467:91597",
        "1": "10467:91608",
        "2": "10467:91619",
        "3": "10467:91630",
        "4": "10467:91641",
        "5": "10467:91652"
    ]
    #expect(variants.count == expected.count)
    for (quantity, nodeID) in expected {
        let variant = variants.first { $0.properties["quantity"] == quantity }
        #expect(variant?.id == nodeID)
        #expect(variant?.width == 264)
        #expect(variant?.height == 40)
    }
    #expect(TUILibraryCatalog.shared.components.first { $0.id == "10467:91596" }?.properties.contains("quantity") == true)
}

@MainActor @Test func progressCircleMapsEveryIOSVariantAndDimension() {
    let variants = TUILibraryCatalog.shared.variants(for: "25942:708453")
        .filter(\.isIOS)
    let modes = Set(TUIProgressCircleMode.allCases.map(\.rawValue))
    let sizes = Set(TUIProgressCircleSize.allCases.map { String($0.rawValue) })
    let presets = Set(TUIProgressCirclePreset.allCases.map(\.rawValue))
    let thicknesses: Set<String> = ["2", "4", "6", "8", "12"]
    let skeletons: Set<String> = ["off", "on"]

    #expect(variants.count == 217)
    #expect(variants.allSatisfy { $0.width == $0.height })
    #expect(Set(variants.map { $0.properties["circleMode"] ?? "" }).isSubset(of: modes))
    #expect(Set(variants.map { $0.properties["Size"] ?? "" }).isSubset(of: sizes))
    #expect(Set(variants.map { $0.properties["Preset"] ?? "" }).isSubset(of: presets))
    #expect(Set(variants.map { $0.properties["Thickness"] ?? "" }).isSubset(of: thicknesses))
    #expect(Set(variants.map { $0.properties["Skeleton"] ?? "" }).isSubset(of: skeletons))

    let knownFrames = ["25942:710757", "26056:506834", "25942:708452"]
    #expect(knownFrames.allSatisfy { id in variants.contains { $0.id == id } })
    for variant in variants {
        let size = Double(variant.properties["Size"] ?? "")
        #expect(size == variant.width)
        #expect(size == variant.height)
    }
}

@Test func blockDetailsMapsBothIOSSkeletonStatesAndFrame() {
    let variants = TUILibraryCatalog.shared.variants(for: "47912:303878")
        .filter(\.isIOS)
    let expected: [String: String] = [
        "47901:306045": "off",
        "55902:297975": "on"
    ]

    #expect(variants.count == expected.count)
    #expect(Set(variants.map(\.id)) == Set(expected.keys))
    for variant in variants {
        #expect(variant.properties["skeleton"] == expected[variant.id])
        #expect(variant.properties["system"] == "iOS")
        #expect(variant.width == 375)
        #expect(variant.height == 395)
    }
}

@Test func badgedContentMapsEveryIOSBadgeVariant() {
    let variants = TUILibraryCatalog.shared.variants(for: "25745:690323")
        .filter(\.isIOS)
    let expected: [String: String] = [
        "25745:687845": "top-plus-bottom",
        "25745:690324": "bottom",
        "25745:690371": "off",
        "25745:690376": "top",
        "6328:52311": "t-client"
    ]

    #expect(variants.count == expected.count)
    #expect(Set(variants.map(\.id)) == Set(expected.keys))
    for variant in variants {
        #expect(variant.properties["Badge"] == expected[variant.id])
        #expect(variant.properties["System"] == "iOS")
        #expect(variant.width == 128)
        #expect(variant.height == 128)
    }
}

@MainActor @Test func avatarLabelledRowMapsItsIOSVariant() {
    let variants = TUILibraryCatalog.shared.variants(for: "53606:308726")
    #expect(variants.count == 1)
    #expect(variants.first?.id == TUIRowAvatarLabelled.figmaNodeID)
    #expect(variants.first?.properties["system"] == "iOS")
}

@Test func browserChromeMapsEveryIOSVariant() {
    let variants = TUILibraryCatalog.shared.variants(for: "42221:48343")
    let previewVariants = TUISystemBrowserChromeVariant.allCases
    let expectedProperties = [
        "42221:48344": ("Address bar", "No"),
        "42221:48351": ("Address bar", "Yes"),
        "42221:48357": ("Tab bar", "No")
    ]
    #expect(variants.count == previewVariants.count)
    #expect(Set(variants.map(\.id)) == Set(previewVariants.map(\.figmaNodeID)))
    for variant in previewVariants {
        let expected = expectedProperties[variant.figmaNodeID]!
        #expect(variants.contains {
            $0.id == variant.figmaNodeID &&
            $0.properties["Type"] == expected.0 &&
            $0.properties["Scrolled"] == expected.1
        })
    }
}

@Test func verticalButtonRowMapsBothIOSQuantities() {
    let variants = TUILibraryCatalog.shared.variants(for: "48700:323897")
    let quantities = TUIRowButtonVerticalQuantity.allCases
    #expect(variants.count == quantities.count)
    #expect(Set(variants.map(\.id)) == Set(quantities.map(\.figmaNodeID)))
    for quantity in quantities {
        #expect(variants.contains {
            $0.id == quantity.figmaNodeID &&
            $0.properties["Quantity"] == quantity.rawValue &&
            $0.properties["System"] == "iOS"
        })
    }
}

@MainActor @Test func customRowMapsItsSingleIOSVariantAndFrame() {
    let variants = TUILibraryCatalog.shared.variants(for: "16753:52842")
    #expect(variants.count == 1)
    #expect(variants.first?.id == "16753:52841")
    #expect(variants.first?.properties["system"] == "iOS")
    #expect(variants.first?.width == 375)
    #expect(variants.first?.height == 100)
    #expect(TUIRowCustom(spacing: TUISpacing.x3) { EmptyView() }.spacing == 12)
}

@Test func notificationMiddleMapsBothIOSTextStates() {
    let variants = TUILibraryCatalog.shared.variants(for: "39739:293413")
        .filter { $0.properties["system"] == "iOS" }
    let expected = [
        "39739:293438": "off",
        "39739:293450": "on"
    ]

    #expect(variants.count == expected.count)
    #expect(Set(variants.map(\.id)) == Set(expected.keys))
    for variant in variants {
        #expect(variant.properties["text"] == expected[variant.id])
        #expect(variant.width == (variant.id == "39739:293438" ? 80 : 140))
        #expect(variant.height == (variant.id == "39739:293438" ? 80 : 138))
    }
}

@MainActor @Test func verticalButtonMapsEveryIOSVisualState() {
    let variants = TUILibraryCatalog.shared.variants(for: TUIButtonVertical.figmaComponentSetID)
        .filter { $0.properties["System"] == "iOS" }
    let cases: [(TUIButtonVertical, String, String)] = [
        (TUIButtonVertical("Label", action: {}), "Normal", "off"),
        (TUIButtonVertical("Label", state: .pressed, action: {}), "Pressed", "off"),
        (TUIButtonVertical("Label", state: .disabled, action: {}), "Disabled", "off"),
        (TUIButtonVertical("Label", skeleton: true, action: {}), "Normal", "on")
    ]

    #expect(variants.count == cases.count)
    #expect(Set(variants.map(\.id)) == Set(cases.map { $0.0.figmaNodeID }))
    for (button, state, skeleton) in cases {
        #expect(variants.contains {
            $0.id == button.figmaNodeID &&
            $0.properties["State"] == state &&
            $0.properties["Skeleton"] == skeleton &&
            $0.properties["System"] == "iOS" &&
            $0.width == 90 && $0.height == 70
        })
    }
}

@Test func linksMapEveryIOSSizeAndColorVariant() {
    let variants = TUILibraryCatalog.shared.variants(for: "55278:70443")
        .filter { $0.properties["platform"] == "iOS" }
    let expected: [String: (String, String)] = [
        "55278:70444": ("large", "default"),
        "55278:70458": ("medium", "default"),
        "55278:70472": ("small", "default"),
        "55278:70486": ("medium", "text-primary"),
        "55278:70500": ("medium", "text-secondary"),
        "55278:70514": ("medium", "text-primary-on-light"),
        "55278:70528": ("large", "text-primary"),
        "55278:70542": ("large", "text-secondary"),
        "55278:70556": ("large", "text-primary-on-light"),
        "55278:70570": ("small", "text-primary"),
        "55278:70584": ("small", "text-secondary"),
        "55278:70598": ("small", "text-primary-on-light"),
        "55278:70612": ("medium", "text-primary-on-dark"),
        "55278:70626": ("large", "text-primary-on-dark"),
        "55278:70640": ("small", "text-primary-on-dark")
    ]

    #expect(variants.count == expected.count)
    #expect(Set(variants.map(\.id)) == Set(expected.keys))
    for variant in variants {
        let properties = expected[variant.id]
        #expect(properties?.0 == variant.properties["size"])
        #expect(properties?.1 == variant.properties["mode"])
    }
}

@Test func systemCheckboxMapsEveryIOSStateToItsFigmaVariant() {
    let variants = TUILibraryCatalog.shared.variants(for: "10312:84")
        .filter { $0.properties["system"] == "iOS" }
    let states = TUISystemCheckboxState.allCases

    #expect(variants.count == states.count)
    #expect(Set(variants.map(\.id)) == Set(states.map(\.figmaNodeID)))
    for state in states {
        #expect(variants.contains {
            $0.id == state.figmaNodeID &&
            $0.properties["state"] == state.rawValue &&
            $0.properties["system"] == "iOS" &&
            $0.width == 22 && $0.height == 22
        })
    }
}

@Test func systemRadioButtonMapsEveryIOSStateToItsFigmaVariant() {
    let variants = TUILibraryCatalog.shared.variants(for: "28036:523553")
        .filter { $0.properties["system"] == "iOS" }
    let states = TUISystemRadioButtonState.allCases

    #expect(variants.count == states.count)
    #expect(Set(variants.map(\.id)) == Set(states.map(\.figmaNodeID)))
    for state in states {
        #expect(variants.contains {
            $0.id == state.figmaNodeID &&
            $0.properties["state"] == state.rawValue &&
            $0.properties["system"] == "iOS" &&
            $0.width == 22 && $0.height == 22
        })
    }
}

@Test func systemSwitchMapsEveryIOSPlatformStateToItsFigmaVariant() {
    let variants = TUILibraryCatalog.shared.variants(for: "9940:39560")
    let matrix = TUISystemSwitchVariant.all

    #expect(variants.count == 8)
    #expect(matrix.count == 8)
    #expect(Set(variants.map(\.id)) == Set(matrix.map(\.figmaNodeID)))
    for item in matrix {
        let expectedSize = item.platform == .iOS18 ? (width: 51.0, height: 33.0) : (width: 64.0, height: 28.0)
        #expect(variants.contains {
            $0.id == item.figmaNodeID &&
            $0.properties["system"] == item.platform.rawValue &&
            $0.properties["selected"] == (item.isOn ? "on" : "off") &&
            $0.properties["disabled"] == (item.isEnabled ? "off" : "on") &&
            $0.width == expectedSize.width && $0.height == expectedSize.height
        })
    }
}

@Test func systemActionSheetMapsBothNativeIOSGenerations() {
    let variants = TUILibraryCatalog.shared.variants(for: "9151:1662")
    let references = TUISystemActionSheetVariant.all
    let expected = ["1444:3120": "iOS 18", "90500:303337": "iOS 26"]

    #expect(variants.count == 2)
    #expect(Set(variants.map(\.id)) == Set(references.map(\.figmaNodeID)))
    for reference in references {
        #expect(variants.contains {
            $0.id == reference.figmaNodeID &&
            $0.properties["System"] == expected[reference.id]
        })
    }
}

@Test func systemContextMenuMapsBothIOSAppearanceVariants() {
    let variants = TUILibraryCatalog.shared.variants(for: "53362:296599")
        .filter { $0.properties["System"] == "iOS" }
    let appearances = TUISystemContextMenuVariant.all

    #expect(variants.count == appearances.count)
    #expect(Set(variants.map(\.id)) == Set(appearances.map(\.figmaNodeID)))
    for appearance in appearances {
        #expect(variants.contains {
            $0.id == appearance.figmaNodeID &&
            $0.properties["Dark Mode"] == (appearance.isDarkMode ? "True" : "False")
        })
    }
}

@Test func systemShareSheetMapsBothIOSAppearanceVariants() {
    let variants = TUILibraryCatalog.shared.variants(for: "44720:304564")
    let appearances = TUISystemShareSheetVariant.all

    #expect(variants.count == appearances.count)
    #expect(Set(variants.map(\.id)) == Set(appearances.map(\.figmaNodeID)))
    for appearance in appearances {
        #expect(variants.contains {
            $0.id == appearance.figmaNodeID &&
            $0.properties["Night Mode"] == (appearance.isDarkMode ? "on" : "off")
        })
    }
}

@Test @MainActor func loaderMapsEveryFigmaSizeToItsExactVectorAsset() throws {
    let variants = TUILibraryCatalog.shared.variants(for: "9999:26")
    let sizes = TUILoaderSize.allCases

    #expect(variants.count == sizes.count)
    #expect(Set(variants.map(\.id)) == Set(sizes.map(\.figmaNodeID)))
    for size in sizes {
        let variant = try #require(variants.first { $0.id == size.figmaNodeID })
        #expect(variant.width == Double(size.rawValue))
        #expect(variant.height == Double(size.rawValue))
        #expect(variant.properties["Size"] == "\(size.rawValue)x\(size.rawValue)")
        let image = try #require(UIImage(named: "tui-loader-\(size.rawValue)", in: .module, compatibleWith: nil))
        #expect(image.size == CGSize(width: size.rawValue, height: size.rawValue))
    }
}

@Test @MainActor func mediumCardRowMapsEveryIOSPresetAndUsesItsFigmaAssets() throws {
    let variants = TUILibraryCatalog.shared.variants(for: "16273:42831").filter(\.isIOS)
    let presets = TUIRowCardMediumPreset.allCases

    #expect(variants.count == presets.count)
    #expect(Set(variants.map(\.id)) == Set(presets.map(\.figmaNodeID)))
    for preset in presets {
        let variant = try #require(variants.first { $0.id == preset.figmaNodeID })
        #expect(variant.properties["preset"] == preset.rawValue)
        #expect(variant.properties["system"] == "iOS")
        #expect(variant.width == 375)
        #expect(variant.height == Double(preset.dimension))
    }
    #expect(UIImage(named: "tui-row-card-medium-star", in: .module, compatibleWith: nil) != nil)
    #expect(UIImage(named: "tui-row-card-medium-note", in: .module, compatibleWith: nil) != nil)
}

@Test @MainActor func pagerMapsEveryIOSVariant() {
    let variants = TUILibraryCatalog.shared.variants(for: "34357:426019")
    var mapped: Set<String> = []
    for size in TUIPager.Size.allCases {
        for pages in 2...6 {
            let id = size.figmaNodeID(pages: pages)
            #expect(variants.contains {
                $0.id == id && $0.properties["size"] == size.rawValue && $0.properties["pages"] == (pages == 6 ? "6+" : String(pages))
            })
            if let id { mapped.insert(id) }
        }
        #expect(size.figmaNodeID(pages: 1) == nil)
        #expect(size.figmaNodeID(pages: 30) == size.figmaNodeID(pages: 6))
    }
    #expect(mapped == Set(variants.map(\.id)))
}

@Test func pagerWindowPreservesDirectionAndBoundaryStates() {
    var start = 0
    let forwardStarts = [0, 0, 0, 0, 2, 2, 2, 2]
    for current in 0..<8 {
        start = TUIPagerWindow.nextStart(pages: 8, oldSelection: max(0, current - 1), selection: current, start: start)
        #expect(start == forwardStarts[current])
        #expect((start..<start + 6).contains(current))
    }
    let reverseStarts = [2, 2, 2, 1, 0, 0, 0]
    for (offset, current) in (0..<7).reversed().enumerated() {
        start = TUIPagerWindow.nextStart(pages: 8, oldSelection: current + 1, selection: current, start: start)
        #expect(start == reverseStarts[offset])
    }
    #expect(TUIPagerWindow.dotState(page: 4, pages: 8, selection: 0, start: 0) == .previous)
    #expect(TUIPagerWindow.dotState(page: 5, pages: 8, selection: 0, start: 0) == .last)
    #expect(TUIPagerWindow.dotState(page: 7, pages: 8, selection: 5, start: 2) == .unselected)
    #expect(TUIPagerWindow.dotState(page: 7, pages: 8, selection: 4, start: 2) == .last)
    #expect(TUIPagerWindow.dotState(page: 2, pages: 8, selection: 5, start: 2) == .last)
    #expect(TUIPagerWindow.dotState(page: 3, pages: 8, selection: 5, start: 2) == .previous)
}

@Test @MainActor func skeletonLayoutsPreserveSourceGeometryAtEveryTextSize() {
    let sourceHeights: [TUISkeletonText.TextStyle: CGFloat] = [
        .headingLarge: 36, .headingMedium: 24, .headingSmall: 20,
        .bodyLarge: 20, .bodyMedium: 18, .bodySmall: 16,
        .uiLarge: 20, .uiMedium: 18, .uiSmall: 16,
        .uiXSmall: 14, .uiXXSmall: 13,
        .numbersXLarge: 36, .numbersMedium: 24
    ]
    for style in TUISkeletonText.TextStyle.allCases {
        for width: CGFloat in [0, 92, 96, 280] {
            for typeSize in [DynamicTypeSize.large, .accessibility5] {
                let host = UIHostingController(rootView:
                    TUISkeletonText(textStyle: style, width: width).dynamicTypeSize(typeSize))
                let actual = host.sizeThatFits(in: CGSize(width: 320, height: 100))
                #expect(abs(actual.width - width) < 0.01)
                #expect(abs(actual.height - (sourceHeights[style] ?? 0)) < 0.01)
            }
        }
    }
    for keyframe in TUISkeletonKeyframe.allCases {
        let host = UIHostingController(rootView: TUISkeleton(keyframe: keyframe))
        let actual = host.sizeThatFits(in: CGSize(width: 320, height: 100))
        #expect(actual == CGSize(width: 40, height: 40))
    }
}

@Test @MainActor func textSkeletonCoversAllLegacyIOSMetrics() {
    let variants = TUILibraryCatalog.shared.variants(for: "37840:45836")
    let styles = TUISkeletonText.TextStyle.allCases
    #expect(styles.count == 13)
    #expect(Set(styles.map(\.figmaNodeID)) == Set(variants.map(\.id)))
    for style in styles {
        let variant = variants.first { $0.id == style.figmaNodeID }
        #expect(variant?.properties["text-style"] == style.rawValue)
        #expect(variant?.height == Double(style.height))
        #expect(variant?.width == 92)
        #expect(style.height == style.barHeight + 2 * style.verticalInset)
    }
    #expect(TUISkeletonText(width: -1).width == 0)
}

@Test @MainActor func addCardButtonMapsTheCompleteIOSMatrix() {
    let variants = TUILibraryCatalog.shared.variants(for: "7319:38983")
    var ids: Set<String> = []
    for size in TUIButtonAddCard.Size.allCases {
        for state in TUIButtonAddCard.State.allCases {
            let id = size.figmaNodeID(state: state)
            ids.insert(id)
            let variant = variants.first { $0.id == id }
            #expect(variant?.properties["size"] == size.rawValue)
            #expect(variant?.properties["state"] == state.rawValue)
            #expect(variant?.width == Double(size.width))
            #expect(variant?.height == Double(size.height))
        }
    }
    #expect(ids == Set(variants.map(\.id)))
}
