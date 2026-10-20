# Textfields

Это индекс сохранённых источников и текущей приёмки. Он не добавляет новых требований Figma.

Публикация через MCP: UNVERIFIED. Полные ID вариантов и определения свойств: [inventory.json](../inventory.json).

## [pwa] tui-input-search · 39867:46664

Назначение из описания Figma: Отдельный инпут поиска, стилизованный под нативный айос

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=39867-46664). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
Ссылка не импортирована; это не доказательство отсутствия спецификации в Figma.

Варианты: 8 всего; 8 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| filled | VARIANT | "off" | ["off", "on"] |
| state | VARIANT | "normal" | ["normal", "focus", "disabled", "pressed"] |

Свойства состояний из импортированной матрицы: state

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Background/Accent 2 | #428bf9 |
| Background/Neutral 2 | #0010240f |
| State/Background/Neutral 2 Pressed | #0010241f |
| Text/Primary | #333333 |
| Text/Secondary | #9299a2 |
| iOS/Body L | Font(family: "SF Pro Text", style: Regular, size: 17, weight: 400, lineHeight: 100, letterSpacing: -0.4099999964237213) |

Текущий публичный API: `TUISearchInput`, [реализация](../../Sources/TUIDesignSystem/Components/SearchInput/TUISearchInput.swift).
Зависимости, наблюдаемые в Swift-коде (не подтверждённый граф Figma): TUIColor.

### Сохранённые материалы и результат проверки

Материалы извлечения спецификации ещё не привязаны к паспорту: UNVERIFIED.

Реализация: IMPLEMENTED. Приёмка: **in-progress**.

- variantMapping: **pending**. Единая повторная приёмка ещё не выполнена.
- specification: **pending**. Единая повторная приёмка ещё не выполнена.
- visual: **pending**. Единая повторная приёмка ещё не выполнена.
- interaction: **pending**. Единая повторная приёмка ещё не выполнена.
- accessibility: **not-applicable**. Explicit user scope exclusion for interactive prototypes: no VoiceOver, accessibility font enlargement or extra accessibility modes. This is a delivery scope waiver, not evidence that Figma has no accessibility requirements or that these modes were tested. Original check retained in previousAccessibilityCheck.
- motion: **pending**. Единая повторная приёмка ещё не выполнена.
- integration: **pending**. Единая повторная приёмка ещё не выполнена.

Открытые вопросы:
- Восемь состояний: визуальное сравнение, заполнение/фокус/disabled, темы и ввод.

## tui-textfield · 65702:51131

Назначение из описания Figma: Поле для ввода текста. Используется в&nbsp;фреймворке SmartFields, PWA, WebView

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=65702-51131). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-textfield-specs) → [разрешённая ссылка Figma](https://www.figma.com/design/R4dFzxFzgDIGTcdlrqaRpe/%D0%9F%D0%BE%D0%BB%D1%8F-%D0%B2%D0%B2%D0%BE%D0%B4%D0%B0--tui-input--tui-textfield--tui-select--tui-combobox--tui-textarea-?node-id=4923-11438&t=A0a7aIw74809dP5N-11)

Варианты: 44 всего; 22 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| accessory-type#8820:45 | INSTANCE_SWAP | "65702:51106" | [{"type": "COMPONENT", "key": "8ac392dbafb663cc29de77706e4b9491761c9102"}, {"type": "COMPONENT", "key": "5ea997987c706211d85962d0f18d2afb7b5c96b7"}, {"type": "COMPONENT", "key": "d7f21dc5601e1234bec43157521731ad5fb11e86"}, {"type": "COMPONENT_SET", "key": "06cfffd0f9ecff20353e70ef5916cf79b066d875"}] |
| error-text#29897:268 | TEXT | "Error" | [] |
| hint-text#7615:480 | TEXT | "Hint text" | [] |
| is-filled | VARIANT | "off" | ["on", "off"] |
| label-text#29896:355 | TEXT | "Label" | [] |
| placeholder-text#29897:80 | TEXT | "Placeholder" | [] |
| show-end-accessory#8771:0 | BOOLEAN | false | [] |
| show-hint#7615:435 | BOOLEAN | false | [] |
| show-label | VARIANT | "on" | ["off", "on"] |
| show-loader#8783:45 | BOOLEAN | false | [] |
| show-placeholder#29897:120 | BOOLEAN | true | [] |
| show-start-accessory#6594:64 | BOOLEAN | false | [] |
| skeleton | VARIANT | "off" | ["off", "on"] |
| state | VARIANT | "normal" | ["normal", "focus", "invalid", "invalid-focus", "read-only", "disabled"] |
| system | VARIANT | "iOS" | ["iOS", "Android"] |
| value-text#29896:318 | TEXT | "Value" | [] |

Свойства состояний из импортированной матрицы: error-text#29897:268, state, skeleton

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/Body L | Font(family: "Roboto", style: Regular, size: 16, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/Body M | Font(family: "Roboto", style: Regular, size: 14, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/UI S | Font(family: "Roboto", style: Regular, size: 13, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Background/Accent 2 | #428bf9 |
| Background/Neutral 1 | #00102408 |
| Screen Padding | 16 |
| Service/Skeleton | #00000008 |
| Text/Negative | #f52222 |
| Text/Primary | #333333 |
| Text/Secondary | #9299a2 |
| Text/Tertiary | #00102438 |
| iOS/Body L | Font(family: "SF Pro Text", style: Regular, size: 17, weight: 400, lineHeight: 100, letterSpacing: -0.4099999964237213) |
| iOS/Body M | Font(family: "SF Pro Text", style: Regular, size: 15, weight: 400, lineHeight: 100, letterSpacing: -0.23999999463558197) |
| iOS/UI S | Font(family: "SF Pro Text", style: Regular, size: 13, weight: 400, lineHeight: 100, letterSpacing: -0.07999999821186066) |

Вложенные instances одного варианта `65702:51132`: [источник](../../Documentation/Inventory/2026-10-08/textfield-variant-metadata-mcp.json). Их main Component ID и полный граф остаются UNVERIFIED.
- `65702:51135` · placeholder-single · скрыт в наблюдаемом варианте: True
- `65702:51140` · placeholder · скрыт в наблюдаемом варианте: True

Текущий публичный API: `TUITextfield`, [реализация](../../Sources/TUIDesignSystem/Components/Textfield/TUITextfield.swift).
Зависимости, наблюдаемые в Swift-коде (не подтверждённый граф Figma): TUIColor, TUIControlSize, TUIFigmaTextFont, TUILibraryCatalog, TUILoader, TUIMotionCurve, TUIRadius, TUISkeleton, TUISpacing, TUITextfieldEditor, TUITextfieldErrorFeedback, TUITextfieldFormSession, TUITextfieldNativeEditor, TUITextfieldState, TUITypographyRole.

### Сохранённые материалы и результат проверки

- [Documentation/References/FloatingContainer/2026-10-12/specification-reading.md](../../Documentation/References/FloatingContainer/2026-10-12/specification-reading.md)
- [Documentation/References/Textfield/forms-reading-2026-10-09.md](../../Documentation/References/Textfield/forms-reading-2026-10-09.md)
- [Documentation/References/Textfield/observed-links-2026-10-09.json](../../Documentation/References/Textfield/observed-links-2026-10-09.json)
- [Documentation/References/Textfield/source-matrix-comparison-2026-10-09.json](../../Documentation/References/Textfield/source-matrix-comparison-2026-10-09.json)
- [Documentation/References/Textfield/source-review-manifest-2026-10-09.json](../../Documentation/References/Textfield/source-review-manifest-2026-10-09.json)
- [Documentation/References/Textfield/specification-reading-2026-10-09.md](../../Documentation/References/Textfield/specification-reading-2026-10-09.md)
- [Documentation/Validation/2026-10-12/TextfieldForm/verification-report.md](../../Documentation/Validation/2026-10-12/TextfieldForm/verification-report.md)

Реализация: IMPLEMENTED. Приёмка: **in-progress**.

- variantMapping: **pending**. 22 exact iOS source IDs and adaptive source heights exercised in both themes. Full instance-property mapping and remaining Guide options stay pending.
- specification: **pending**. Main Textfield/Forms texts and diagrams read before relevant implementation. Form navigation and current read-only restrictions now implemented and natively verified. Related Floating Container main texts/12 diagrams read on the observed native Design page; linked prototypes/fresh set matrix, remaining Textfield Guide options and exact error-step times stay UNVERIFIED.
- visual: **pending**. Current final implementation rendered as 44 active native PNGs; 22 exact Day pairs inspected with no alignment or RGB correction. Night source exports, font/caret residuals, source hint overflow and remaining customization still pending. Form layout separately measured at 98 pt including hint, with 12/16 pt source gaps. System SF Pro chosen by user on 2026-10-20; bundled legacy font inputs retired to historicalInputHashes. Historical renders do not accept the new system face.
- interaction: **pending**. Current final native suite passes input, clear, submit, limits, read-only Copy→Paste, disabled, slots/tap-only, public grouped forms in Day/Night, live catalog and external read-only/disabled form transitions. Full customization/Guide interaction acceptance remains pending.
- accessibility: **not-applicable**. Explicit user scope exclusion for interactive prototypes: no VoiceOver, accessibility font enlargement or extra accessibility modes. This is a delivery scope waiver, not evidence that Figma has no accessibility requirements or that these modes were tested. Original check retained in previousAccessibilityCheck.
- motion: **pending**. Current error geometry-only probe has 117 real samples and passes observed displacement/direction/approximate duration. Main-thread PNG capture caused 117 ms gaps in a rejected diagnostic trace and is now opt-in for a separate visual run. Exact source step timing, hint/clear/label transitions, whole-field hint scope and full focus/reset temporal observation remain pending; physical haptic UNVERIFIED.
- integration: **pending**. Final public component/consumer sources pass 19 package tests and 11 native tests; independent consumer and catalog built and installed in correct order. Current live form, 44 matrix captures and Copy→Paste are verified. A later catalog-only recorder change passes a separate geometry-motion run; public package/consumer sources unchanged. This is integration evidence, not full component acceptance. Related 12 Oct catalogue/consumer additions revalidated: existing independent Textfield Day/Night still passes; expanded 318-example corpus compiles/renders. Textfield/Form implementation remains unchanged.

Открытые вопросы:
- {'id': 'textfield-native-visual-acceptance', 'status': 'open', 'description': '22 Day native/source pairs inspected and 44 true native PNGs saved. Night source comparison, typography/caret residuals and full custom content acceptance remain pending. Initial transparent PNGs are not visual evidence.'}
- {'id': 'textfield-remaining-guide-behavior', 'status': 'open', 'description': 'Form coordination, visible-keyboard navigation, skip rules, boundaries, 12/16 pt geometry and dynamic read-only/disabled changes now pass. Remaining: temporal fidelity of hints/clear/label/error-step timing and hint scope, overflow/selection token, complete accessory hit areas and Screen Padding off, counter, prefix/suffix/dynamic-number applicability and full instance-property mapping. Linked dropdown/select/compound and Floating Container prototype acceptance remain UNVERIFIED.'}
- {'id': 'textfield-source-hint-overflow', 'status': 'open', 'description': '65702:51258 root is 320 pt, while error-container x=16 / width=320 makes the source export 336 pt. Source bounds inconsistency retained and documented; no text scaling or Figma edit.'}
- {'id': 'textfield-motion-source-conflict', 'status': 'open', 'description': 'Current textual Guide specifies ±3 pt; historical deprecated prototype includes −4/+2 pt at specific frames. Implemented textual Guide; no deprecated component imported or Figma mutation. Exact step timing and final reconciliation remain UNVERIFIED.'}
- Reverify native system SF Pro after explicit user decision 2026-10-20; legacy font binaries are no longer distributed. Historical visual evidence is not acceptance of the new face.

## tui-textfield [convert] · 26960:617080

Назначение из описания Figma: Смарт-поле для двух сумм для конвертации валют

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=26960-617080). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-textfield-convert) → [разрешённая ссылка Figma](https://www.figma.com/design/2KNW2dqkurLaAXPLixMOVU/tui-textfield%2C-Smartfields?node-id=2669-6488&t=ng1VSIEhdBJENllk-1)

Варианты: 88 всего; 44 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| currency-left | VARIANT | "off" | ["off", "on"] |
| filled | VARIANT | "off" | ["off", "on"] |
| hint | VARIANT | "off" | ["off", "on"] |
| invalid | VARIANT | "off" | ["off", "on"] |
| state | VARIANT | "normal" | ["normal", "focus", "pressed", "disabled"] |
| system | VARIANT | "iOS" | ["iOS", "Android"] |

Свойства состояний из импортированной матрицы: state

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/Body M | Font(family: "Roboto", style: Regular, size: 14, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/Numbers M | Font(family: "Open Runde", style: Bold, size: 20, weight: 700, lineHeight: 100, letterSpacing: 0) |
| Background/Accent 2 | #428bf9 |
| Background/Neutral 1 | #00102408 |
| Background/Neutral 1 Pressed | #0010240f |
| Service/Android/Ripple | #0000000a |
| Text/Negative | #f52222 |
| Text/Primary | #333333 |
| Text/Secondary | #9299a2 |
| iOS/Body M | Font(family: "SF Pro Text", style: Regular, size: 15, weight: 400, lineHeight: 100, letterSpacing: -0.23999999463558197) |
| iOS/Numbers M | Font(family: "SF Pro Rounded", style: Bold, size: 20, weight: 600, lineHeight: 100, letterSpacing: 0.3569999933242798) |

### Сохранённые материалы и результат проверки

Материалы извлечения спецификации ещё не привязаны к паспорту: UNVERIFIED.

Реализация: NOT_IMPLEMENTED. Приёмка: **catalogued**.

- variantMapping: **pending**. Единая повторная приёмка ещё не выполнена.
- specification: **pending**. Единая повторная приёмка ещё не выполнена.
- visual: **pending**. Единая повторная приёмка ещё не выполнена.
- interaction: **pending**. Единая повторная приёмка ещё не выполнена.
- accessibility: **not-applicable**. Explicit user scope exclusion for interactive prototypes: no VoiceOver, accessibility font enlargement or extra accessibility modes. This is a delivery scope waiver, not evidence that Figma has no accessibility requirements or that these modes were tested. Original check retained in previousAccessibilityCheck.
- motion: **pending**. Единая повторная приёмка ещё не выполнена.
- integration: **pending**. Единая повторная приёмка ещё не выполнена.

## tui-textfield [counter] · 54443:283316

Назначение из описания Figma: UNVERIFIED: описание в импорте отсутствует.

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=54443-283316). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-textfield-counter) → [разрешённая ссылка Figma](https://www.figma.com/design/2KNW2dqkurLaAXPLixMOVU/tui-textfield%2C-Smartfields?node-id=2141-16576&t=l92i5Vsd75Qfa5gg-1)

Варианты: 44 всего; 22 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| error | VARIANT | "No" | ["No", "Yes"] |
| filled | VARIANT | "No" | ["Yes", "No"] |
| hint | VARIANT | "No" | ["No", "Yes"] |
| state | VARIANT | "normal" | ["normal", "pressed", "focus", "disabled"] |
| system | VARIANT | "iOS" | ["iOS", "Android"] |

Свойства состояний из импортированной матрицы: state, error

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/Body L | Font(family: "Roboto", style: Regular, size: 16, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/Body M | Font(family: "Roboto", style: Regular, size: 14, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/Numbers M | Font(family: "Open Runde", style: Bold, size: 20, weight: 700, lineHeight: 100, letterSpacing: 0) |
| Background/Accent 2 | #428bf9 |
| Background/Elevation 1 | #ffffff |
| Background/Neutral 1 | #00102408 |
| Hide from publishing/Shadow/Small/Blur | 20 |
| Hide from publishing/Shadow/Small/Color | #0000001a |
| Hide from publishing/Shadow/Small/Y-axis | 5 |
| Service/Android/Ripple | #0000000a |
| Shadow/Small | Effect(type: DROP_SHADOW, color: Hide from publishing/Shadow/Small/Color, offset: (0, Hide from publishing/Shadow/Small/Y-axis), radius: Hide from publishing/Shadow/Small/Blur, spread: 0) |
| State/Background/Neutral 1 Pressed | #0010240f |
| Text/Negative | #f52222 |
| Text/Primary | #333333 |
| Text/Secondary | #9299a2 |
| Text/Tertiary | #00102438 |
| [Deprecated]/shadow-small | Effect(type: DROP_SHADOW, color: #0000001A, offset: (0, 5), radius: 20, spread: 0) |
| iOS/Body L | Font(family: "SF Pro Text", style: Regular, size: 17, weight: 400, lineHeight: 100, letterSpacing: -0.4099999964237213) |
| iOS/Body M | Font(family: "SF Pro Text", style: Regular, size: 15, weight: 400, lineHeight: 100, letterSpacing: -0.23999999463558197) |
| iOS/Numbers M | Font(family: "SF Pro Rounded", style: Bold, size: 20, weight: 600, lineHeight: 100, letterSpacing: 0.3569999933242798) |
| tui-button/radius-medium | 12 |

### Сохранённые материалы и результат проверки

Материалы извлечения спецификации ещё не привязаны к паспорту: UNVERIFIED.

Реализация: NOT_IMPLEMENTED. Приёмка: **catalogued**.

- variantMapping: **pending**. Единая повторная приёмка ещё не выполнена.
- specification: **pending**. Единая повторная приёмка ещё не выполнена.
- visual: **pending**. Единая повторная приёмка ещё не выполнена.
- interaction: **pending**. Единая повторная приёмка ещё не выполнена.
- accessibility: **not-applicable**. Explicit user scope exclusion for interactive prototypes: no VoiceOver, accessibility font enlargement or extra accessibility modes. This is a delivery scope waiver, not evidence that Figma has no accessibility requirements or that these modes were tested. Original check retained in previousAccessibilityCheck.
- motion: **pending**. Единая повторная приёмка ещё не выполнена.
- integration: **pending**. Единая повторная приёмка ещё не выполнена.

## tui-textfield [multiline] · 69850:48152

Назначение из описания Figma: Поле для ввода текста. Используется в&nbsp;фреймворке SmartFields, PWA, WebView

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=69850-48152). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-textfield-multiline-specs) → [разрешённая ссылка Figma](https://www.figma.com/design/R4dFzxFzgDIGTcdlrqaRpe/%D0%9F%D0%BE%D0%BB%D1%8F-%D0%B2%D0%B2%D0%BE%D0%B4%D0%B0--tui-input--tui-textfield--tui-select--tui-combobox--tui-textarea-?node-id=7021-69558&t=A0a7aIw74809dP5N-11)

Варианты: 44 всего; 22 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| error-text#29897:268 | TEXT | "Error" | [] |
| hint-text#7615:480 | TEXT | "Hint text" | [] |
| is-filled | VARIANT | "off" | ["on", "off"] |
| label-text#29896:355 | TEXT | "Label" | [] |
| placeholder-text#29897:80 | TEXT | "Placeholder" | [] |
| show-hint#7615:435 | BOOLEAN | false | [] |
| show-label | VARIANT | "on" | ["off", "on"] |
| show-loader#8783:45 | BOOLEAN | false | [] |
| show-placeholder#29897:120 | BOOLEAN | true | [] |
| skeleton | VARIANT | "off" | ["off", "on"] |
| state | VARIANT | "normal" | ["normal", "focus", "invalid", "invalid-focus", "read-only", "disabled"] |
| system | VARIANT | "iOS" | ["iOS", "Android"] |
| value-text#29896:318 | TEXT | "Value" | [] |

Свойства состояний из импортированной матрицы: error-text#29897:268, state, skeleton

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/Body L | Font(family: "Roboto", style: Regular, size: 16, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/Body M | Font(family: "Roboto", style: Regular, size: 14, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/UI S | Font(family: "Roboto", style: Regular, size: 13, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Background/Accent 2 | #428bf9 |
| Background/Neutral 1 | #00102408 |
| Screen Padding | 16 |
| Service/Skeleton | #00000008 |
| Text/Negative | #f52222 |
| Text/Primary | #333333 |
| Text/Secondary | #9299a2 |
| Text/Tertiary | #00102438 |
| iOS/Body L | Font(family: "SF Pro Text", style: Regular, size: 17, weight: 400, lineHeight: 100, letterSpacing: -0.4099999964237213) |
| iOS/Body M | Font(family: "SF Pro Text", style: Regular, size: 15, weight: 400, lineHeight: 100, letterSpacing: -0.23999999463558197) |
| iOS/UI S | Font(family: "SF Pro Text", style: Regular, size: 13, weight: 400, lineHeight: 100, letterSpacing: -0.07999999821186066) |

### Сохранённые материалы и результат проверки

Материалы извлечения спецификации ещё не привязаны к паспорту: UNVERIFIED.

Реализация: NOT_IMPLEMENTED. Приёмка: **catalogued**.

- variantMapping: **pending**. Единая повторная приёмка ещё не выполнена.
- specification: **pending**. Единая повторная приёмка ещё не выполнена.
- visual: **pending**. Единая повторная приёмка ещё не выполнена.
- interaction: **pending**. Единая повторная приёмка ещё не выполнена.
- accessibility: **not-applicable**. Explicit user scope exclusion for interactive prototypes: no VoiceOver, accessibility font enlargement or extra accessibility modes. This is a delivery scope waiver, not evidence that Figma has no accessibility requirements or that these modes were tested. Original check retained in previousAccessibilityCheck.
- motion: **pending**. Единая повторная приёмка ещё не выполнена.
- integration: **pending**. Единая повторная приёмка ещё не выполнена.

## tui-textfield [number] · 69850:47618

Назначение из описания Figma: Поле для ввода текста. Используется в&nbsp;фреймворке SmartFields, PWA, WebView  keywords: amount, sum, money, quiantity, number аналог в десктопе tui-input-number

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=69850-47618). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-textfield-number-specs) → [разрешённая ссылка Figma](https://www.figma.com/design/R4dFzxFzgDIGTcdlrqaRpe/%D0%9F%D0%BE%D0%BB%D1%8F-%D0%B2%D0%B2%D0%BE%D0%B4%D0%B0--tui-input--tui-textfield--tui-select--tui-combobox--tui-textarea-?node-id=9361-154458&t=A0a7aIw74809dP5N-11)

Варианты: 26 всего; 13 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| accessory-slot#9385:0 | INSTANCE_SWAP | "65702:51106" | [{"type": "COMPONENT_SET", "key": "06cfffd0f9ecff20353e70ef5916cf79b066d875"}, {"type": "COMPONENT", "key": "8ac392dbafb663cc29de77706e4b9491761c9102"}, {"type": "COMPONENT_SET", "key": "087ee6a1bf535507bd5c5f443b67315bb70ca62e"}] |
| error-text#29897:268 | TEXT | "Error" | [] |
| hint-text#7615:480 | TEXT | "Hint text" | [] |
| is-filled | VARIANT | "off" | ["on", "off"] |
| label-text#29896:355 | TEXT | "Label" | [] |
| placeholder-text#29897:80 | TEXT | "Placeholder" | [] |
| prefix-text#9361:380 | TEXT | "$" | [] |
| show-accessory-slot#9385:27 | BOOLEAN | true | [] |
| show-end-accessories#9361:515 | BOOLEAN | false | [] |
| show-hint#7615:435 | BOOLEAN | false | [] |
| show-label | VARIANT | "on" | ["off", "on"] |
| show-loader#8783:45 | BOOLEAN | true | [] |
| show-placeholder#29897:120 | BOOLEAN | false | [] |
| show-prefix#9361:407 | BOOLEAN | false | [] |
| show-suffix#9361:434 | BOOLEAN | true | [] |
| skeleton | VARIANT | "off" | ["off", "on"] |
| state | VARIANT | "normal" | ["normal", "focus", "invalid", "invalid-focus", "read-only", "disabled"] |
| suffix-text#9361:461 | TEXT | "₽" | [] |
| system | VARIANT | "iOS" | ["iOS", "Android"] |
| value-text#29896:318 | TEXT | "1000" | [] |

Свойства состояний из импортированной матрицы: error-text#29897:268, state, skeleton

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/Body L | Font(family: "Roboto", style: Regular, size: 16, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/Body M | Font(family: "Roboto", style: Regular, size: 14, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/Numbers M | Font(family: "Open Runde", style: Bold, size: 20, weight: 700, lineHeight: 100, letterSpacing: 0) |
| Background/Accent 2 | #428bf9 |
| Background/Neutral 1 | #00102408 |
| Screen Padding | 16 |
| Service/Skeleton | #00000008 |
| Text/Negative | #f52222 |
| Text/Primary | #333333 |
| Text/Secondary | #9299a2 |
| Text/Tertiary | #00102438 |
| iOS/Body L | Font(family: "SF Pro Text", style: Regular, size: 17, weight: 400, lineHeight: 100, letterSpacing: -0.4099999964237213) |
| iOS/Body M | Font(family: "SF Pro Text", style: Regular, size: 15, weight: 400, lineHeight: 100, letterSpacing: -0.23999999463558197) |
| iOS/Numbers M | Font(family: "SF Pro Rounded", style: Bold, size: 20, weight: 600, lineHeight: 100, letterSpacing: 0.3569999933242798) |

### Сохранённые материалы и результат проверки

Материалы извлечения спецификации ещё не привязаны к паспорту: UNVERIFIED.

Реализация: NOT_IMPLEMENTED. Приёмка: **catalogued**.

- variantMapping: **pending**. Единая повторная приёмка ещё не выполнена.
- specification: **pending**. Единая повторная приёмка ещё не выполнена.
- visual: **pending**. Единая повторная приёмка ещё не выполнена.
- interaction: **pending**. Единая повторная приёмка ещё не выполнена.
- accessibility: **not-applicable**. Explicit user scope exclusion for interactive prototypes: no VoiceOver, accessibility font enlargement or extra accessibility modes. This is a delivery scope waiver, not evidence that Figma has no accessibility requirements or that these modes were tested. Original check retained in previousAccessibilityCheck.
- motion: **pending**. Единая повторная приёмка ещё не выполнена.
- integration: **pending**. Единая повторная приёмка ещё не выполнена.

