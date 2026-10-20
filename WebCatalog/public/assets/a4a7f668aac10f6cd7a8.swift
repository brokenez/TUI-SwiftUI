import SwiftUI
import UIKit

public enum TUITextfieldState: String, CaseIterable, Sendable {
    case normal, focus, invalid
    case invalidFocus = "invalid-focus"
    case readOnly = "read-only"
    case disabled

    public var isFocused: Bool { self == .focus || self == .invalidFocus }
    public var isInvalid: Bool { self == .invalid || self == .invalidFocus }
    public var isEditable: Bool { self != .readOnly && self != .disabled }
}

/// Single-line TUI Mobile input. The native editor owns selection, the keyboard,
/// composing text and the insertion point; the package owns the Figma appearance.
/// Read-only permits selection and copying. Disabled does not permit interaction.
public struct TUITextfield: View {
    public enum HintVisibility: String, CaseIterable, Sendable { case focused, always }
    public static let figmaComponentSetID = "65702:51131"

    @Binding private var text: String
    @Binding private var state: TUITextfieldState
    public let label: String?
    public let placeholder: String
    public let isSkeleton: Bool
    public let isSkeletonAnimating: Bool
    public let showsClearButton: Bool
    public let isLoading: Bool
    public let startContent: AnyView?
    public let endContent: AnyView?
    public let hint: AnyView?
    public let errorHint: AnyView?
    public let hintText: String?
    public let errorText: String?
    public let hintVisibility: HintVisibility
    public let characterLimit: Int?
    /// Increment for each validation attempt, including a repeated invalid result.
    /// Entering an invalid state already triggers feedback; changing both in one
    /// update produces one event. Initial invalid previews remain still.
    public let validationTrigger: Int
    public let keyboardType: UIKeyboardType
    public let returnKeyType: UIReturnKeyType
    public let textContentType: UITextContentType?
    public let onSubmit: () -> Void
    public let action: (() -> Void)?
    @State private var isPressed = false
    @State private var nativeFocused = false
    @Environment(TUITextfieldFormSession.self) private var formSession: TUITextfieldFormSession?
    @Environment(\.tuiTextfieldFormID) private var formID

    public init(
        text: Binding<String>,
        state: Binding<TUITextfieldState> = .constant(.normal),
        label: String? = nil,
        placeholder: String = "",
        isSkeleton: Bool = false,
        isSkeletonAnimating: Bool = true,
        showsClearButton: Bool = true,
        isLoading: Bool = false,
        startContent: AnyView? = nil,
        endContent: AnyView? = nil,
        hint: AnyView? = nil,
        errorHint: AnyView? = nil,
        hintText: String? = nil,
        errorText: String? = nil,
        hintVisibility: HintVisibility = .focused,
        characterLimit: Int? = nil,
        validationTrigger: Int = 0,
        keyboardType: UIKeyboardType = .default,
        returnKeyType: UIReturnKeyType = .default,
        textContentType: UITextContentType? = nil,
        onSubmit: @escaping () -> Void = {},
        action: (() -> Void)? = nil
    ) {
        _text = text; _state = state
        self.label = label; self.placeholder = placeholder
        self.isSkeleton = isSkeleton; self.isSkeletonAnimating = isSkeletonAnimating
        self.showsClearButton = showsClearButton
        self.isLoading = isLoading; self.startContent = startContent
        self.endContent = endContent; self.hint = hint; self.errorHint = errorHint
        self.hintText = hintText; self.errorText = errorText
        self.hintVisibility = hintVisibility
        self.characterLimit = characterLimit.map { max(0, $0) }
        self.validationTrigger = validationTrigger
        self.keyboardType = keyboardType; self.returnKeyType = returnKeyType
        self.textContentType = textContentType; self.onSubmit = onSubmit; self.action = action
    }

    private var hasLabel: Bool { label != nil }
    private var effectiveState: TUITextfieldState {
        guard nativeFocused, state.isEditable else { return state }
        return state.isInvalid ? .invalidFocus : .focus
    }
    private var editorState: Binding<TUITextfieldState> {
        Binding(get: { effectiveState }, set: { state = $0; nativeFocused = $0.isFocused })
    }
    private var hasSmallLabel: Bool { hasLabel && (!text.isEmpty || effectiveState.isFocused) }
    private var showsClear: Bool {
        showsClearButton && effectiveState.isFocused && !text.isEmpty && endContent == nil && !isLoading && action == nil
    }
    private var showsLock: Bool { state == .readOnly || state == .disabled }
    private var visibleHint: AnyView? {
        if state.isInvalid { return errorHint ?? errorText.map { AnyView(sourceHint($0)) } }
        guard effectiveState.isFocused || hintVisibility == .always else { return nil }
        return hint ?? hintText.map { AnyView(sourceHint($0)) }
    }
    private var valueColor: Color {
        if state == .disabled { return TUIColor.textSecondary }
        return state.isInvalid && !hasLabel ? TUIColor.negative : TUIColor.textPrimary
    }
    private var labelColor: Color { state.isInvalid ? TUIColor.negative : TUIColor.textSecondary }

    /// A node ID is supplied only when the actual configuration exists in the
    /// imported iOS matrix. Other supported runtime combinations have no invented ID.
    public var figmaNodeID: String? {
        TUILibraryCatalog.shared.variants(for: Self.figmaComponentSetID).first {
            let p = $0.properties
            return p["system"] == "iOS" && p["state"] == effectiveState.rawValue
                && p["is-filled"] == (text.isEmpty ? "off" : "on")
                && p["show-label"] == (hasLabel ? "on" : "off")
                && p["skeleton"] == (isSkeleton ? "on" : "off")
        }?.id
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if isSkeleton {
                // This source variant has radius 12; the ordinary field has 16.
                GeometryReader { geometry in
                    TUISkeleton(width: geometry.size.width, height: TUIControlSize.large,
                        isAnimating: isSkeletonAnimating)
                        .clipShape(RoundedRectangle(cornerRadius: TUIRadius.medium, style: .circular))
                }
                .frame(height: TUIControlSize.large)
            } else {
                container
                if let visibleHint {
                    visibleHint
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(TUISpacing.x3)
                        .transition(.asymmetric(
                            insertion: .opacity.animation(TUIMotionCurve.productiveEntrance.animation(duration: .moderate)),
                            removal: .opacity.animation(TUIMotionCurve.productiveExit.animation(duration: .fast))))
                }
            }
        }
        .disabled(state == .disabled)
        .allowsHitTesting(state != .disabled)
        .animation(TUIMotionCurve.productiveStandard.animation(duration: .fast), value: hasSmallLabel)
        .animation(state.isFocused || state.isInvalid
            ? TUIMotionCurve.productiveEntrance.animation(duration: .moderate)
            : TUIMotionCurve.productiveExit.animation(duration: .fast), value: visibleHint != nil)
        .modifier(TUITextfieldErrorFeedback(isInvalid: state.isInvalid,
            validationTrigger: validationTrigger, isEnabled: state.isEditable && !isSkeleton))
        .onGeometryChange(for: CGRect.self) { geometry in
            geometry.frame(in: .named(formSession?.coordinateSpace ?? "tuiStandaloneTextfield"))
        } action: { rect in
            if let formID { formSession?.updateFrame(rect, id: formID) }
        }
    }

    private var container: some View {
        HStack(spacing: TUISpacing.x2) {
            if let startContent { startContent.frame(minHeight: TUIControlSize.large) }
            VStack(alignment: .leading, spacing: TUISpacing.x0_5) {
                if let label, hasSmallLabel {
                    sourceText(label, role: .uiSmall, color: labelColor)
                }
                ZStack(alignment: .leading) {
                    if !hasSmallLabel, let label, text.isEmpty {
                        sourceText(label, role: .bodyLarge, color: labelColor)
                            .allowsHitTesting(false)
                    }
                    TUITextfieldEditor(text: $text, state: editorState,
                        placeholder: hasLabel && !hasSmallLabel ? "" : placeholder,
                        valueColor: valueColor,
                        placeholderColor: state == .readOnly ? TUIColor.textPrimary
                            : state.isInvalid && !hasLabel && !effectiveState.isFocused
                                ? TUIColor.negative : TUIColor.textSecondary,
                        characterLimit: characterLimit, keyboardType: keyboardType,
                        returnKeyType: returnKeyType, textContentType: textContentType,
                        allowsInteraction: action == nil, onSubmit: onSubmit,
                        onPressChanged: { pressed in
                            if pressed { isPressed = true }
                            else { withAnimation(TUIMotionCurve.productiveStandard.animation(duration: .fast)) { isPressed = false } }
                        })
                        // The legacy source's natural line boxes are measured in
                        // 65702:51258: value-container 20 pt, label 16 pt.
                        .frame(height: 20)
                }
            }
            .padding(.vertical, TUISpacing.x2)
            .frame(maxWidth: .infinity, minHeight: TUIControlSize.large, alignment: .leading)
            // Text/label taps belong to the field; accessory buttons own theirs.
            .contentShape(Rectangle())
            .simultaneousGesture(TapGesture().onEnded { activate() })
            if isLoading || showsLock || endContent != nil || showsClear {
              HStack(spacing: TUISpacing.x3) {
                if isLoading { TUILoader(size: .x24) }
                if showsLock {
                    Image("tui-textfield-lock", bundle: .module)
                        .renderingMode(.template).resizable()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(TUIColor.named("Text/Tertiary"))
                } else if let endContent { endContent }
                else if showsClear {
                    Button(action: clear) {
                        Image("tui-search-input-clear", bundle: .module)
                            .renderingMode(.template).resizable()
                            .frame(width: 16, height: 16)
                            .foregroundStyle(TUIColor.named("Text/Tertiary"))
                            .padding(.leading, TUISpacing.x2)
                            .padding(.trailing, TUISpacing.x3)
                            .frame(minHeight: TUIControlSize.large)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("tuiTextfieldClear")
                    .padding(.leading, -TUISpacing.x2).padding(.trailing, -TUISpacing.x3)
                    .transition(.asymmetric(
                        insertion: .opacity.animation(TUIMotionCurve.productiveStandard.animation(duration: .fast)),
                        removal: .identity))
                }
            }
            .frame(minHeight: TUIControlSize.large)
            .fixedSize(horizontal: true, vertical: false)
            }
        }
        .padding(.horizontal, TUISpacing.x3)
        .frame(minHeight: TUIControlSize.large)
        .background(TUIColor.named(isPressed && state.isEditable
            ? "State/Background/Neutral 1 Pressed" : "Background/Neutral 1"),
            in: RoundedRectangle(cornerRadius: TUIRadius.large, style: .circular))
        // Unoccupied padding remains tappable without bubbling accessory taps
        // into the editor or cancelling UIKit's long-press selection gesture.
        .background {
            Color.clear.contentShape(RoundedRectangle(cornerRadius: TUIRadius.large))
                .onTapGesture(perform: activate)
        }
        .onChange(of: state) { _, new in isPressed = false; nativeFocused = new.isFocused }
    }

    private func activate() {
        guard state != .disabled else { return }
        if let action { action() }
        else if state.isEditable { nativeFocused = true; state = state.isInvalid ? .invalidFocus : .focus }
    }

    private func sourceText(_ value: String, role: TUITypographyRole, color: Color) -> some View {
        let metrics = role.metrics
        let font = TUIFigmaTextFont.regular(size: metrics.size)
        return Text(value).font(Font(font)).kerning(metrics.letterSpacing)
            .foregroundStyle(color).lineLimit(1)
            .frame(height: role == .uiSmall ? 16 : 20)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func clear() {
        var transaction = Transaction(); transaction.disablesAnimations = true
        withTransaction(transaction) { text = ""; state = .focus; nativeFocused = true }
    }

    private func sourceHint(_ value: String) -> some View {
        Text(value)
            .font(Font(TUIFigmaTextFont.regular(size: TUITypographyRole.bodyMedium.metrics.size)))
            .kerning(TUITypographyRole.bodyMedium.metrics.letterSpacing)
            .foregroundStyle(TUIColor.textPrimary)
            .fixedSize(horizontal: false, vertical: true)
    }
}

struct TUITextfieldEditor: UIViewRepresentable {
    @Environment(TUITextfieldFormSession.self) private var formSession: TUITextfieldFormSession?
    @Environment(\.tuiTextfieldFormID) private var formID
    @Binding var text: String
    @Binding var state: TUITextfieldState
    let placeholder: String
    let valueColor: Color
    let placeholderColor: Color
    let characterLimit: Int?
    let keyboardType: UIKeyboardType
    let returnKeyType: UIReturnKeyType
    let textContentType: UITextContentType?
    let allowsInteraction: Bool
    let onSubmit: () -> Void
    var onPressChanged: (Bool) -> Void = { _ in }

    func makeUIView(context: Context) -> TUITextfieldNativeEditor {
        let field = TUITextfieldNativeEditor()
        field.delegate = context.coordinator
        field.borderStyle = .none; field.clearButtonMode = .never
        field.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        field.addTarget(context.coordinator, action: #selector(Coordinator.changed(_:)), for: .editingChanged)
        return field
    }

    func updateUIView(_ field: TUITextfieldNativeEditor, context: Context) {
        context.coordinator.owner = self
        let originalSelection = field.selectedTextRange.map {
            (field.offset(from: field.beginningOfDocument, to: $0.start),
             field.offset(from: field.beginningOfDocument, to: $0.end))
        }
        let unchangedValue = field.text == text
        let metrics = TUITypographyRole.bodyLarge.metrics
        field.font = TUIFigmaTextFont.regular(size: metrics.size)
        field.defaultTextAttributes = [.font: field.font!, .kern: metrics.letterSpacing,
                                       .foregroundColor: UIColor(valueColor)]
        // Never replace composing text or reset selection during a normal keystroke.
        if field.text != text, field.markedTextRange == nil { field.text = text }
        field.attributedPlaceholder = NSAttributedString(string: placeholder,
            attributes: [.font: field.font!, .kern: metrics.letterSpacing,
                         .foregroundColor: UIColor(placeholderColor)])
        field.tintColor = UIColor(TUIColor.named("Background/Accent 2"))
        field.keyboardType = keyboardType; field.returnKeyType = returnKeyType
        field.textContentType = textContentType
        field.onPressChanged = onPressChanged
        let inputModeChanged = field.readOnly != (state == .readOnly)
        field.readOnly = state == .readOnly
        // Read-only selection must not open UIKit's separate word-correction
        // popover. That popover bypasses the standard edit-menu filtering.
        field.autocorrectionType = field.readOnly ? .no : .default
        field.spellCheckingType = field.readOnly ? .no : .default
        if inputModeChanged { field.inputView = field.readOnly ? field.readOnlyInputView : nil }
        field.isUserInteractionEnabled = state != .disabled && allowsInteraction
        field.editingEnabled = state != .disabled
        field.wantsFocus = state.isFocused && allowsInteraction
        field.needsInputViewReload = field.needsInputViewReload || inputModeChanged
        // Resigning/becoming first responder synchronously here re-enters the
        // SwiftUI responder graph while it is updating (consumer submit hang).
        field.synchronizeFocusAfterUpdate()
        if unchangedValue, field.isFirstResponder, field.markedTextRange == nil,
           let (start, end) = originalSelection,
           let a = field.position(from: field.beginningOfDocument, offset: start),
           let b = field.position(from: field.beginningOfDocument, offset: end) {
            field.selectedTextRange = field.textRange(from: a, to: b)
        }
        field.accessibilityIdentifier = formID.map { "tuiTextfieldInput-\($0)" } ?? "tuiTextfieldInput"
        if let formID {
            formSession?.register(field, id: formID, state: $state,
                                  eligible: state.isEditable && allowsInteraction)
        }
    }

    static func dismantleUIView(_ field: TUITextfieldNativeEditor, coordinator: Coordinator) {
        if let id = coordinator.owner.formID { coordinator.owner.formSession?.unregister(field, id: id) }
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    final class Coordinator: NSObject, UITextFieldDelegate {
        var owner: TUITextfieldEditor
        init(_ owner: TUITextfieldEditor) { self.owner = owner }

        func textFieldDidBeginEditing(_ textField: UITextField) {
            if owner.state.isEditable {
                owner.state = owner.state.isInvalid ? .invalidFocus : .focus
                textField.selectedTextRange = textField.textRange(from: textField.endOfDocument, to: textField.endOfDocument)
            }
            if let id = owner.formID { owner.formSession?.began(id) }
        }
        func textFieldDidEndEditing(_ textField: UITextField) {
            if owner.state.isEditable { owner.state = owner.state.isInvalid ? .invalid : .normal }
            if let id = owner.formID { owner.formSession?.ended(id) }
        }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            guard owner.state.isEditable else { return false }
            if let id = owner.formID, let formSession = owner.formSession { formSession.advance(from: id) }
            else { owner.onSubmit() }
            return true
        }
        func textField(_ textField: UITextField, editMenuForCharactersIn ranges: [NSValue],
                       suggestedActions: [UIMenuElement]) -> UIMenu? {
            readOnlyMenu(suggestedActions)
        }
        func textField(_ textField: UITextField, editMenuForCharactersIn range: NSRange,
                       suggestedActions: [UIMenuElement]) -> UIMenu? {
            readOnlyMenu(suggestedActions)
        }
        private func readOnlyMenu(_ suggestedActions: [UIMenuElement]) -> UIMenu? {
            guard owner.state == .readOnly else { return nil }
            // AutoFill is supplied as a system submenu on iOS 26, independently
            // of canPerformAction. Keep native selection/copy and omit input actions.
            func filteringInputMenus(_ element: UIMenuElement) -> UIMenuElement? {
                if let command = element as? UICommand {
                    return command.action == #selector(UIResponderStandardEditActions.copy(_:))
                        || command.action == #selector(UIResponderStandardEditActions.select(_:))
                        || command.action == #selector(UIResponderStandardEditActions.selectAll(_:)) ? command : nil
                }
                guard let menu = element as? UIMenu else { return nil }
                guard menu.identifier != .autoFill else { return nil }
                let children = menu.children.compactMap(filteringInputMenus)
                return children.isEmpty ? nil : menu.replacingChildren(children)
            }
            return UIMenu(children: suggestedActions.compactMap(filteringInputMenus))
        }
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard owner.state.isEditable else { return false }
            guard textField.markedTextRange == nil, let limit = owner.characterLimit else { return true }
            let original = textField.text ?? ""
            guard let swiftRange = Range(range, in: original) else { return false }
            let next = original.replacingCharacters(in: swiftRange, with: string)
            // Permit deletion/recovery from an over-limit programmatic value.
            guard next.count > limit && next.count >= original.count else { return true }
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            // A rejected keystroke must not replace any existing suffix.
            guard string.count > 1 else { return false }
            applyLimitedReplacement(to: textField, original: original, range: swiftRange,
                                    replacement: string, limit: limit)
            changed(textField)
            return false
        }
        private func applyLimitedReplacement(to field: UITextField, original: String,
                                             range: Range<String.Index>, replacement: String, limit: Int) {
            let prefix = String(original[..<range.lowerBound])
            let suffix = String(original[range.upperBound...])
            let available = max(0, limit - prefix.count - suffix.count)
            let accepted = String(replacement.prefix(available))
            field.text = prefix + accepted + suffix
            if let cursor = field.position(from: field.beginningOfDocument, offset: prefix.utf16.count + accepted.utf16.count) {
                field.selectedTextRange = field.textRange(from: cursor, to: cursor)
            }
        }
        @objc func changed(_ textField: UITextField) {
            guard textField.markedTextRange == nil else { return }
            var value = textField.text ?? ""
            if let limit = owner.characterLimit, value != owner.text,
               value.count > limit, value.count >= owner.text.count {
                // An IME commits after shouldChangeCharacters. Limit only its
                // changed fragment, preserving the previously committed text.
                let before = Array(owner.text), after = Array(value)
                var prefix = 0, suffix = 0
                while prefix < min(before.count, after.count), before[prefix] == after[prefix] { prefix += 1 }
                while suffix < min(before.count, after.count) - prefix,
                      before[before.count - suffix - 1] == after[after.count - suffix - 1] { suffix += 1 }
                let start = owner.text.index(owner.text.startIndex, offsetBy: prefix)
                let end = owner.text.index(owner.text.endIndex, offsetBy: -suffix)
                applyLimitedReplacement(to: textField, original: owner.text, range: start..<end,
                                        replacement: String(after[prefix..<(after.count - suffix)]), limit: limit)
                value = textField.text ?? ""
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            }
            guard value != owner.text else { return }
            owner.text = value
            if owner.state.isInvalid { owner.state = .focus }
        }
    }
}

final class TUITextfieldNativeEditor: UITextField {
    var readOnly = false
    var wantsFocus = false
    var editingEnabled = true
    let readOnlyInputView = UIView(frame: .zero)
    var needsInputViewReload = false
    private var focusUpdateScheduled = false
    var onPressChanged: (Bool) -> Void = { _ in }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event); onPressChanged(true)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event); onPressChanged(false)
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event); onPressChanged(false)
    }
    func synchronizeFocusAfterUpdate() {
        guard !focusUpdateScheduled else { return }
        focusUpdateScheduled = true
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.focusUpdateScheduled = false
            self.isEnabled = self.editingEnabled
            // Read the latest flags; several SwiftUI updates can precede this
            // turn. A stale queued request must not restore an obsolete focus.
            if self.wantsFocus, self.window != nil, self.isEnabled, self.isUserInteractionEnabled {
                if !self.isFirstResponder { self.becomeFirstResponder() }
            } else if self.isFirstResponder && (!self.readOnly || !self.isEnabled || !self.isUserInteractionEnabled) {
                self.resignFirstResponder()
            }
            if self.needsInputViewReload {
                self.needsInputViewReload = false
                if self.isFirstResponder { self.reloadInputViews() }
            }
        }
    }
    override func didMoveToWindow() { super.didMoveToWindow(); synchronizeFocusAfterUpdate() }
    override func caretRect(for position: UITextPosition) -> CGRect {
        guard !readOnly else { return .zero }
        let rect = super.caretRect(for: position)
        return CGRect(x: rect.minX, y: rect.midY - 9.5, width: 2, height: 19)
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.placeholderRect(forBounds: bounds)
        if wantsFocus, text?.isEmpty != false {
            // Source cursor is 2 pt wide with -1 pt overlap before placeholder.
            rect.origin.x += 1; rect.size.width = max(0, rect.width - 1)
        }
        return rect
    }
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if readOnly {
            guard action == #selector(copy(_:)) || action == #selector(select(_:))
                || action == #selector(selectAll(_:)) else { return false }
        }
        return super.canPerformAction(action, withSender: sender)
    }
}

#Preview("Textfield") {
    @Previewable @State var text = ""
    @Previewable @State var state = TUITextfieldState.normal
    TUITextfield(text: $text, state: $state, label: "Имя", placeholder: "Введите имя")
        .padding(TUISpacing.x4)
}
