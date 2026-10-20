import SwiftUI
import UIKit
import XCTest
@testable import TUIDesignSystem

final class TextfieldTests: XCTestCase {
    @MainActor func testCenterAlignmentUsesNativeEditorAndHidesOnlyFocusedPlaceholder() async throws {
        for state in [TUITextfieldState.normal, .focus, .invalidFocus] {
            for value in ["", "12345"] {
                let host = TUITextfieldTestHost(TUITextfield(text: .constant(value), state: .constant(state),
                    placeholder: "Код из СМС", showsClearButton: false, textAlignment: .center))
                defer { host.close() }
                await host.settle()
                let native = try XCTUnwrap(host.editor)
                XCTAssertEqual(native.textAlignment, .center)
                XCTAssertEqual(native.text, value)
                XCTAssertEqual(native.attributedPlaceholder?.string ?? "", state.isFocused ? "" : "Код из СМС")
                XCTAssertEqual(native.bounds.height, 20, accuracy: 0.5)
            }
        }
        // Existing consumers retain UIKit's natural alignment and placeholder.
        let host = TUITextfieldTestHost(TUITextfield(text: .constant(""), state: .constant(.focus), placeholder: "Placeholder"))
        defer { host.close() }
        await host.settle()
        let native = try XCTUnwrap(host.editor)
        XCTAssertEqual(native.textAlignment, .natural)
        XCTAssertEqual(native.attributedPlaceholder?.string, "Placeholder")
    }

    @MainActor func testFlushAccessoryChangesOnlyItsTrailingInsetAndKeepsNativeEditorAdaptive() async throws {
        for width: CGFloat in [200, 320, 600] {
            var widths: [CGFloat] = []
            for inset in [true, false] {
                let host = TUITextfieldTestHost(TUITextfield(text: .constant("Value"), label: "Label",
                    endContent: AnyView(Color.blue.frame(width: 40, height: 56)),
                    trailingAccessoryInset: inset), width: width)
                defer { host.close() }
                await host.settle()
                let native = try XCTUnwrap(host.editor)
                let frame = native.convert(native.bounds, to: host.view)
                XCTAssertEqual(frame.minX, TUISpacing.x3, accuracy: 0.5)
                XCTAssertEqual(frame.height, 20, accuracy: 0.5)
                widths.append(frame.width)
            }
            XCTAssertEqual(widths[1] - widths[0], TUISpacing.x3, accuracy: 0.5)
            // Without a custom accessory, the same option cannot alter input geometry.
            let ordinary = TUITextfieldTestHost(TUITextfield(text: .constant("Value")), width: width)
            defer { ordinary.close() }
            await ordinary.settle()
            let noAccessory = TUITextfieldTestHost(TUITextfield(text: .constant("Value"), trailingAccessoryInset: false), width: width)
            defer { noAccessory.close() }
            await noAccessory.settle()
            XCTAssertEqual(try XCTUnwrap(ordinary.editor).bounds.width,
                           try XCTUnwrap(noAccessory.editor).bounds.width, accuracy: 0.5)
        }
    }

    @MainActor func testErrorMotionFollowsGuidePositionsAndDurationTokens() {
        let first = TUITextfieldErrorMotion(repeated: false)
        let repeated = TUITextfieldErrorMotion(repeated: true)
        XCTAssertEqual(first.duration.seconds, 0.5, accuracy: 0.00001)
        XCTAssertEqual(repeated.duration.seconds, 0.3, accuracy: 0.00001)
        for (motion, positions) in [(first, [0.0, -3, 3, -3, 3, 0]), (repeated, [0.0, -3, 3, 0])] {
            for (index, expected) in positions.enumerated() {
                XCTAssertEqual(motion.offset(progress: Double(index) / Double(positions.count - 1)), expected, accuracy: 0.00001)
            }
        }
    }

    @MainActor func testErrorMotionReturnsToRestAndDoesNotOvershoot() {
        for repeated in [false, true] {
            let motion = TUITextfieldErrorMotion(repeated: repeated)
            XCTAssertEqual(motion.offset(progress: -1), 0)
            XCTAssertEqual(motion.offset(progress: 2), 0)
            for tick in 0...1000 {
                let eased = TUIMotionCurve.productiveStandard.unitCurve.value(at: Double(tick) / 1000)
                XCTAssertLessThanOrEqual(abs(motion.offset(progress: eased)), 3)
            }
        }
    }

    @MainActor func testAll22SourceVariantsResolveWithoutInventedCombinations() {
        let variants = TUILibraryCatalog.shared.variants(for: TUITextfield.figmaComponentSetID)
        XCTAssertEqual(variants.count, 22)
        for variant in variants {
            let p = variant.properties
            let field = TUITextfield(text: .constant(p["is-filled"] == "on" ? "Value" : ""),
                state: .constant(TUITextfieldState(rawValue: p["state"]!)!),
                label: p["show-label"] == "on" ? "Label" : nil,
                isSkeleton: p["skeleton"] == "on")
            XCTAssertEqual(field.figmaNodeID, variant.id)
        }
        XCTAssertNil(TUITextfield(text: .constant(""), state: .constant(.normal)).figmaNodeID)
    }

    @MainActor func testPasteLimitPreservesExtendedGraphemeClusters() {
        var value = "ab"
        var state = TUITextfieldState.invalidFocus
        let editor = makeEditor(text: Binding(get: { value }, set: { value = $0 }),
            state: Binding(get: { state }, set: { state = $0 }), limit: 4)
        let coordinator = editor.makeCoordinator()
        let native = TUITextfieldNativeEditor(); native.text = value
        XCTAssertFalse(coordinator.textField(native, shouldChangeCharactersIn: NSRange(location: 2, length: 0),
                                             replacementString: "👨‍👩‍👧‍👦e\u{301}xyz"))
        XCTAssertEqual(value, "ab👨‍👩‍👧‍👦e\u{301}")
        XCTAssertEqual(value.count, 4)
        XCTAssertEqual(state, .focus)
        XCTAssertEqual(native.text, value)
    }

    @MainActor func testUnlimitedInputAndReadOnlyAndDisabledHaveDifferentContracts() {
        var value = "Value"
        var state = TUITextfieldState.normal
        let editor = makeEditor(text: Binding(get: { value }, set: { value = $0 }),
            state: Binding(get: { state }, set: { state = $0 }))
        let coordinator = editor.makeCoordinator()
        let native = TUITextfieldNativeEditor(); native.text = value
        XCTAssertTrue(coordinator.textField(native, shouldChangeCharactersIn: NSRange(location: 5, length: 0),
                                            replacementString: String(repeating: "x", count: 1000)))
        state = .readOnly
        XCTAssertFalse(coordinator.textField(native, shouldChangeCharactersIn: NSRange(location: 0, length: 5), replacementString: ""))
        coordinator.textFieldDidBeginEditing(native)
        XCTAssertEqual(state, .readOnly)
        native.readOnly = true
        XCTAssertFalse(native.canPerformAction(#selector(UIResponderStandardEditActions.paste(_:)), withSender: nil))
        XCTAssertFalse(native.canPerformAction(#selector(UIResponderStandardEditActions.cut(_:)), withSender: nil))
        state = .disabled
        XCTAssertFalse(coordinator.textField(native, shouldChangeCharactersIn: NSRange(location: 0, length: 5), replacementString: "Other"))
        XCTAssertEqual(value, "Value")
    }

    @MainActor func testTypingAtLimitDoesNotReplaceExistingSuffixOrResetError() {
        var value = "12345"
        var state = TUITextfieldState.invalidFocus
        let editor = makeEditor(text: Binding(get: { value }, set: { value = $0 }),
            state: Binding(get: { state }, set: { state = $0 }), limit: 5)
        let native = TUITextfieldNativeEditor(); native.text = value
        XCTAssertFalse(editor.makeCoordinator().textField(native,
            shouldChangeCharactersIn: NSRange(location: 2, length: 0), replacementString: "9"))
        XCTAssertEqual(native.text, "12345"); XCTAssertEqual(value, "12345")
        XCTAssertEqual(state, .invalidFocus)
    }

    @MainActor func testLimitedPasteKeepsUnselectedSuffixAndNativeInsertionPoint() throws {
        var value = "abcd"
        var state = TUITextfieldState.invalidFocus
        let editor = makeEditor(text: Binding(get: { value }, set: { value = $0 }),
            state: Binding(get: { state }, set: { state = $0 }), limit: 5)
        let native = TUITextfieldNativeEditor(); native.text = value
        XCTAssertFalse(editor.makeCoordinator().textField(native,
            shouldChangeCharactersIn: NSRange(location: 1, length: 1), replacementString: "👨‍👩‍👧‍👦e\u{301}xyz"))
        XCTAssertEqual(value, "a👨‍👩‍👧‍👦e\u{301}cd")
        XCTAssertEqual(value.count, 5); XCTAssertEqual(state, .focus)
        XCTAssertEqual(native.offset(from: native.beginningOfDocument, to: try XCTUnwrap(native.selectedTextRange).start),
                       "a👨‍👩‍👧‍👦e\u{301}".utf16.count)
    }

    @MainActor func testCommittedCompositionLimitKeepsPreviouslyCommittedSuffix() throws {
        var value = "abcd"
        var state = TUITextfieldState.invalidFocus
        let editor = makeEditor(text: Binding(get: { value }, set: { value = $0 }),
            state: Binding(get: { state }, set: { state = $0 }), limit: 5)
        let native = TUITextfieldNativeEditor(); native.text = "ab👨‍👩‍👧‍👦🇷🇺e\u{301}cd"
        editor.makeCoordinator().changed(native)
        XCTAssertEqual(value, "ab👨‍👩‍👧‍👦cd"); XCTAssertEqual(value.count, 5)
        XCTAssertEqual(state, .focus)
        XCTAssertEqual(native.offset(from: native.beginningOfDocument, to: try XCTUnwrap(native.selectedTextRange).start),
                       "ab👨‍👩‍👧‍👦".utf16.count)
    }

    @MainActor func testFocusPlacesInsertionPointAtEndAndEditingResetsError() {
        var value = "Long value"
        var state = TUITextfieldState.invalid
        let editor = makeEditor(text: Binding(get: { value }, set: { value = $0 }),
            state: Binding(get: { state }, set: { state = $0 }))
        let coordinator = editor.makeCoordinator()
        let native = TUITextfieldNativeEditor(); native.text = value
        coordinator.textFieldDidBeginEditing(native)
        XCTAssertEqual(state, .invalidFocus)
        XCTAssertEqual(native.offset(from: native.beginningOfDocument,
            to: native.selectedTextRange!.start), value.utf16.count)
        native.text = "Edited"; coordinator.changed(native)
        XCTAssertEqual(value, "Edited"); XCTAssertEqual(state, .focus)
        coordinator.textFieldDidEndEditing(native)
        XCTAssertEqual(state, .normal)
    }

    @MainActor func testReadOnlyOmitsAutoFillWithoutReplacingNativeCopyCommand() throws {
        var state = TUITextfieldState.readOnly
        let editor = makeEditor(text: .constant("Value"), state: Binding(get: { state }, set: { state = $0 }))
        let coordinator = editor.makeCoordinator()
        let copy = UICommand(title: "Copy", action: #selector(UIResponderStandardEditActions.copy(_:)))
        let autoFill = UIMenu(title: "AutoFill", identifier: .autoFill, children: [UIAction(title: "Contact") { _ in }])
        let nested = UIMenu(title: "Edit", children: [copy, autoFill])
        let menu = try XCTUnwrap(coordinator.textField(TUITextfieldNativeEditor(),
            editMenuForCharactersIn: [NSValue(range: NSRange(location: 0, length: 5))], suggestedActions: [nested]))
        let retained = try XCTUnwrap(menu.children.first as? UIMenu)
        XCTAssertEqual(retained.children.count, 1)
        XCTAssertTrue(retained.children.first === copy)
        state = .normal
        XCTAssertNil(coordinator.textField(TUITextfieldNativeEditor(),
            editMenuForCharactersIn: [], suggestedActions: [nested]))
    }

    @MainActor func testAllSourceVariantsHaveSourceHeightInBothThemesAndAdaptiveWidths() throws {
        for variant in TUILibraryCatalog.shared.variants(for: TUITextfield.figmaComponentSetID) {
            for theme in TUITheme.allCases {
                let p = variant.properties
                let view = TUITextfield(text: .constant(p["is-filled"] == "on" ? "Value" : ""),
                    state: .constant(TUITextfieldState(rawValue: p["state"]!)!),
                    label: p["show-label"] == "on" ? "Label" : nil,
                    placeholder: p["show-label"] == "on" || p["state"] == "focus" || p["state"] == "invalid-focus" ? "Placeholder" : "Label",
                    isSkeleton: p["skeleton"] == "on",
                    errorText: p["state"] == "invalid-focus" ? "Error" : nil)
                    .padding(.horizontal, TUISpacing.x4)
                    .environment(\.colorScheme, theme == .day ? .light : .dark)
                let size = sizeOf(view, width: 320)
                XCTAssertEqual(size.width, 320, accuracy: 0.5)
                XCTAssertEqual(size.height, variant.height, accuracy: 0.5)
            }
        }
        for width: CGFloat in [200, 390, 600] {
            let size = sizeOf(TUITextfield(text: .constant("Long input value"), label: "Label"), width: width)
            XCTAssertEqual(size.width, width, accuracy: 0.5)
            XCTAssertEqual(size.height, 56, accuracy: 0.5)
        }
    }

    @MainActor private func makeEditor(text: Binding<String>, state: Binding<TUITextfieldState>, limit: Int? = nil) -> TUITextfieldEditor {
        TUITextfieldEditor(text: text, state: state, placeholder: "Placeholder", valueColor: TUIColor.textPrimary,
            placeholderColor: TUIColor.textSecondary, characterLimit: limit, keyboardType: .default,
            returnKeyType: .done, textContentType: nil, allowsInteraction: true, onSubmit: {})
    }

    @MainActor private func sizeOf<V: View>(_ view: V, width: CGFloat) -> CGSize {
        let host = UIHostingController(rootView: view)
        return host.sizeThatFits(in: CGSize(width: width, height: 200))
    }

}

/// UITextField's UIViewRepresentable must be mounted in a visible UIKit window;
/// windowless sizeThatFits hosts can measure SwiftUI without creating the editor.
@MainActor final class TUITextfieldTestHost {
    let controller: UIHostingController<AnyView>
    let window: UIWindow
    private let previousKeyWindow: UIWindow?
    var view: UIView { controller.view }
    var editor: TUITextfieldNativeEditor? { findEditor(in: view) }

    init<V: View>(_ content: V, width: CGFloat = 320, height: CGFloat = 56) {
        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        previousKeyWindow = scenes.flatMap(\.windows).first(where: \.isKeyWindow)
        controller = UIHostingController(rootView: AnyView(content.ignoresSafeArea()))
        window = scenes.first.map(UIWindow.init(windowScene:)) ?? UIWindow(frame: .zero)
        window.frame = CGRect(x: 0, y: 0, width: width, height: height)
        window.rootViewController = controller
        window.makeKeyAndVisible()
    }

    func settle() async {
        // Yield to SwiftUI's UIKit update/layout pass, then wait for the actual
        // editor rather than accepting an empty hosting hierarchy as geometry.
        for _ in 0..<50 {
            await Task.yield()
            window.setNeedsLayout(); window.layoutIfNeeded()
            view.setNeedsLayout(); view.layoutIfNeeded()
            if let editor, editor.bounds.width > 0, editor.bounds.height > 0 { return }
            try? await Task.sleep(for: .milliseconds(10))
        }
    }

    func close() {
        view.endEditing(true)
        window.isHidden = true
        window.rootViewController = nil
        previousKeyWindow?.makeKey()
    }

    private func findEditor(in view: UIView) -> TUITextfieldNativeEditor? {
        if let editor = view as? TUITextfieldNativeEditor { return editor }
        return view.subviews.lazy.compactMap { self.findEditor(in: $0) }.first
    }
}
