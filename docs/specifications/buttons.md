# Buttons

Это индекс сохранённых источников и текущей приёмки. Он не добавляет новых требований Figma.

Публикация через MCP: UNVERIFIED. Полные ID вариантов и определения свойств: [inventory.json](../inventory.json).

## tui-button · 41658:296906

Назначение из описания Figma: Обычные кнопки в разных стилях

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=41658-296906). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-button-specs) → [разрешённая ссылка Figma](https://www.figma.com/design/HErJrp1BcNRUFCyg3QccuG/tui-button?node-id=1-3&t=MC3cfB58GDhCp9tW-1)

Варианты: 294 всего; 147 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| Icon (16)#41658:7 | INSTANCE_SWAP | "106794:35086" | [] |
| Icon#41658:0 | INSTANCE_SWAP | "41881:45334" | [] |
| Text#41658:28 | TEXT | "Label" | [] |
| appearance | VARIANT | "primary" | ["primary", "accent", "primary-destructive", "primary-grayscale", "secondary", "secondary-destructive", "secondary-grayscale", "flat", "flat-destructive", "flat-grayscale", "glass", "floating"] |
| show-Icon#41658:14 | BOOLEAN | false | [] |
| show-label#41658:21 | BOOLEAN | true | [] |
| size | VARIANT | "large" | ["large", "medium", "small"] |
| skeleton | VARIANT | "off" | ["off", "on"] |
| state | VARIANT | "normal" | ["normal", "pressed", "loading", "disabled"] |
| system | VARIANT | "ios" | ["ios", "android"] |

Свойства состояний из импортированной матрицы: state, skeleton

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/Body L | Font(family: "Roboto", style: Regular, size: 16, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/Body M | Font(family: "Roboto", style: Regular, size: 14, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/UI S Bold | Font(family: "Roboto", style: Medium, size: 13, weight: 500, lineHeight: 100, letterSpacing: 0) |
| Background/Accent 1 | #ffdd2d |
| Background/Accent 2 | #428bf9 |
| Background/Accent Opposite | #000000 |
| Background/Elevation 1 | #ffffff |
| Background/Neutral 1 | #00102408 |
| Background/Neutral 1 Opaque | #f6f7f8 |
| Background/Overlay Glass | #00000066 |
| Hide from publishing/Shadow/Small/Blur | 20 |
| Hide from publishing/Shadow/Small/Color | #0000001a |
| Hide from publishing/Shadow/Small/Y-axis | 5 |
| Service/Android/Ripple | #0000000a |
| Service/Android/Ripple On Dark | #ffffff21 |
| Service/Android/Ripple On Opposite | #ffffff21 |
| Service/Android/Ripple On T-Bank | #fab61966 |
| Service/Skeleton | #00000008 |
| Shadow/Small | Effect(type: DROP_SHADOW, color: Hide from publishing/Shadow/Small/Color, offset: (0, Hide from publishing/Shadow/Small/Y-axis), radius: Hide from publishing/Shadow/Small/Blur, spread: 0) |
| State/Background/Accent 1 Pressed | #ffcd33 |
| State/Background/Accent 2 Pressed | #126df7 |
| State/Background/Accent Opposite Pressed | #2c2c2e |
| State/Background/Neutral 1 Pressed | #0010240f |
| State/Background/Overlay Glass Pressed | #00000099 |
| State/Status/Negative Pressed | #9c0707 |
| Status/Negative | #f52222 |
| Text/Action | #428bf9 |
| Text/Negative | #f52222 |
| Text/Primary | #333333 |
| Text/Primary On Accent 1 | #333333 |
| Text/Primary On Dark | #ffffff |
| Text/Primary On Opposite | #ffffff |
| Text/Tertiary | #00102438 |
| Text/Tertiary On Dark | #ffffff4d |
| iOS/Body L | Font(family: "SF Pro Text", style: Regular, size: 17, weight: 400, lineHeight: 100, letterSpacing: -0.4099999964237213) |
| iOS/Body M | Font(family: "SF Pro Text", style: Regular, size: 15, weight: 400, lineHeight: 100, letterSpacing: -0.23999999463558197) |
| iOS/UI S Bold | Font(family: "SF Pro Text", style: Semibold, size: 13, weight: 600, lineHeight: 100, letterSpacing: -0.07999999821186066) |
| tui-button/radius-large | 16 |
| tui-button/radius-medium | 12 |

Вложенные instances одного варианта `21516:56078`: [источник](../../Documentation/Inventory/2026-10-08/button-variant-metadata-mcp.json). Их main Component ID и полный граф остаются UNVERIFIED.
- `21516:56080` · tui-ic-medium / star · скрыт в наблюдаемом варианте: True

Текущий публичный API: `TUIButton`, [реализация](../../Sources/TUIDesignSystem/Components/Button/TUIButton.swift).
Зависимости, наблюдаемые в Swift-коде (не подтверждённый граф Figma): TUIButtonAppearance, TUIButtonEffect, TUIButtonFigmaStyle, TUIButtonLoadingGlyph, TUIButtonOffset, TUIButtonPaint, TUIButtonRGBA, TUIButtonSize, TUIButtonState, TUIButtonStyleCatalog, TUIButtonStylePayload, TUIButtonStyleReference, TUIButtonText, TUIColor, TUIFigmaTextFont, TUIHeaderFontMetrics, TUIHeaderText, TUISensitiveText, TUIShadow, TUISkeleton, TUITypographyRole.

### Сохранённые материалы и результат проверки

- [Documentation/Inventory/2026-10-08/button-customization-fresh-mcp.json](../../Documentation/Inventory/2026-10-08/button-customization-fresh-mcp.json)
- [Documentation/Inventory/2026-10-08/specification-reading-manifest.json](../../Documentation/Inventory/2026-10-08/specification-reading-manifest.json)
- [Documentation/References/Button/2026-10-13/skeleton-inheritance-reading.md](../../Documentation/References/Button/2026-10-13/skeleton-inheritance-reading.md)
- [Documentation/References/Button/additional-features-review-2026-10-08.md](../../Documentation/References/Button/additional-features-review-2026-10-08.md)
- [Documentation/References/Button/construction-accessibility-review-2026-10-08.md](../../Documentation/References/Button/construction-accessibility-review-2026-10-08.md)
- [Documentation/References/Button/customization-api-review-2026-10-08.md](../../Documentation/References/Button/customization-api-review-2026-10-08.md)
- [Documentation/References/Button/full-specification-reading-2026-10-08.md](../../Documentation/References/Button/full-specification-reading-2026-10-08.md)
- [Documentation/References/Button/source-review-followup-2026-10-08.md](../../Documentation/References/Button/source-review-followup-2026-10-08.md)
- [Documentation/References/Button/source-review-followup-manifest-2026-10-08.json](../../Documentation/References/Button/source-review-followup-manifest-2026-10-08.json)
- [Documentation/References/Button/specification-review-2026-10-08.md](../../Documentation/References/Button/specification-review-2026-10-08.md)
- [Documentation/References/SensitiveMode/specification-reading-2026-10-08.md](../../Documentation/References/SensitiveMode/specification-reading-2026-10-08.md)
- [Documentation/Validation/2026-10-13/ButtonFade/verification-report.md](../../Documentation/Validation/2026-10-13/ButtonFade/verification-report.md)
- [Documentation/Validation/2026-10-13/ButtonFloatingShadow/comparison.json](../../Documentation/Validation/2026-10-13/ButtonFloatingShadow/comparison.json)
- [Documentation/Validation/2026-10-13/ButtonFloatingShadow/matrix-package-summary.json](../../Documentation/Validation/2026-10-13/ButtonFloatingShadow/matrix-package-summary.json)
- [Documentation/Validation/2026-10-13/ButtonFloatingShadow/source-versions.json](../../Documentation/Validation/2026-10-13/ButtonFloatingShadow/source-versions.json)
- [Documentation/Validation/2026-10-13/ButtonFloatingShadow/verification-report.md](../../Documentation/Validation/2026-10-13/ButtonFloatingShadow/verification-report.md)
- [Documentation/Validation/2026-10-13/ButtonSkeleton/verification-report.md](../../Documentation/Validation/2026-10-13/ButtonSkeleton/verification-report.md)
- [Documentation/Validation/2026-10-13/SensitiveMode/source-versions.json](../../Documentation/Validation/2026-10-13/SensitiveMode/source-versions.json)
- [Documentation/Validation/2026-10-13/SensitiveMode/verification-report.md](../../Documentation/Validation/2026-10-13/SensitiveMode/verification-report.md)

Реализация: IMPLEMENTED. Приёмка: **in-progress**.

- variantMapping: **passed**. All 147 applicable iOS base variants resolve to exact public figmaNodeID without fallback; raw property values are preserved. All ten set/instance properties mapped, including independent Large/Medium and Small swaps. Source demo frame widths recorded explicitly; consumer instance geometry must be read separately. The 147 copyable examples compile and render in the 285-example QA test. This accepts API mapping only.
- specification: **pending**. Available functional Button guide text and all 26 Styles rows read; applicable construction/content/radius/masking/editorial diagrams reviewed, clipped 11096:17944 explicitly excluded. Fresh 147 iOS IDs/properties/frames unchanged. Linked pixel Sensitive full construction read; new particle Sensitive reference remains partial. Pixel masking implemented and tested through the shared Sensitive runtime on 2026-10-13. Acceptance remains pending for exact legacy nested Loader/Skeleton motion and full visual/typography verification. Corner-case and Foundations Shadow contexts reread; source stops/Blur/Y-axis and Night removal recorded before the targeted checks and shadow change. Button Skeleton instance-to-main inheritance and both source reactions read and confirmed; the shared pulse is now reused. Old nested Loader timing remains UNVERIFIED.
- visual: **pending**. 270 native @3x renders cover 135 non-glass variants in Day/Night, frame sizes verified; eight default runtime boards remain RGBA-identical. Token bindings and independent customization checked. These are runtime/regression evidence only: full Figma PNG pairs for all 147, glass backdrop, shadow, fade and typography acceptance remain pending. On 2026-10-13 the three skeleton radius contours were corrected to source values 16/12/100. Six Day/Night @3x renders were recaptured at exact source widths/heights and a focused iOS Simulator pixel test plus catalog build passed; this is a local regression fix, not complete Figma visual acceptance. On 2026-10-13 native overflow alpha matches the 85.065% source fade profile in 18 cases; literal guide illustration remains visually unresolved because its shortened text fits the native font. Floating blur conversion corrected; three normal Day full-effect source pairs improve by 77–78%, three Night renders pixel-identical. All 12 Floating variants regenerated in both themes; remaining states are runtime evidence, not full source visual acceptance. Twelve fresh Primary Day source pairs measured; MAE 0.208–3.899/255, typography still pending. Skeleton now has three fresh Day pairs with MAE 0.005629–0.040936/255 and six native size/theme renders. Edge rasterization differs from former fill and is reported explicitly; Night source pairing and full matrix remain pending.
- interaction: **pending**. Existing seven Button UI checks plus final separate consumer test remain historical evidence. New actual catalog UI test passed: Medium Fill/Hug selection, real action, loading retains intrinsic width and Fill restoration. Additional custom pressed/disabled behavior and all specification content combinations remain pending; this test is not VoiceOver verification. 2026-10-13: masked/unmasked label and preserved Button/link/whole-control actions verified in live catalog and independent consumer; this does not accept all147 Button combinations. Live Skeleton action suppression and stable frame verified for all three sizes in Day/Night after inherited pulse was connected.
- accessibility: **not-applicable**. Explicit user scope exclusion for interactive prototypes: no VoiceOver, accessibility font enlargement or extra accessibility modes. This is a delivery scope waiver, not evidence that Figma has no accessibility requirements or that these modes were tested. Original check retained in previousAccessibilityCheck.
- motion: **pending**. Button Skeleton inherited source reactions established: 1↔0.5, delay 1 ms, 500 ms each direction, cubic (0.2,0,0.4,0.9). Shared runtime reused; 396 exact-curve samples and 48 live Button crops pass for three sizes and both themes. Old nested Loader duration/easing/repeat and full Button motion acceptance remain pending.
- integration: **pending**. Prior package/catalog/independent-consumer checks retained. Current package build and two Medium layout tests passed (32 Hug and 24 Fill combinations); catalog build and one live component UI test passed. Public API unchanged. Full final acceptance still awaits specification, visual and motion; extra accessibility is waived by explicit user decision. Focused Skeleton package suite 3/3, separate exact-curve test 1/1 and native UI suite 2/2 pass; independent consumer build succeeds with additive cornerRadius API. Complete Button integration acceptance still depends on remaining specification/visual/motion work. Final standalone Xcode catalog build and ordinary catalog route verified on 2026-10-15: normal tap increments the count, Skeleton selects source 55915:350412 and disables action; 23 acceptance-registry tests pass. See native-catalog-review-2026-10-15.md.

Открытые вопросы:
- Full paired Figma visual verification for all 147 applicable variants remains pending. Twelve Primary Day pairs and three Skeleton Day pairs measured; Night source pairs, typography and remaining appearances still unaccepted.
- System versus legacy SF fonts and resource distribution decision pending; typography is not accepted.
- Glass/material backdrop and full Floating state/source shadow verification remain pending. Numeric overflow fade profile and fitting-label opacity verified on 2026-10-13; literal source illustration remains unresolved. Floating Blur conversion corrected against three normal Day pairs; 24 updated native Floating renders. Pixel masking native actions and geometry verified previously; full Sensitive visual/motion acceptance remains pending.
- Public icon/smallIcon, independent colors, radius and actual width customization implemented and tested; custom pressed/disabled behavior and all allowed combinations not fully accepted.
- Two labels is separate set 51388:47169 and needs its own API and acceptance.
- Exact legacy nested Loader duration/easing/repeat remains UNVERIFIED; available modern Loader guide does not prove this nested glyph motion. Button Skeleton source inheritance is resolved and shared pulse verified; this does not accept the full motion category. Advanced accessibility modes excluded by user scope.

## tui-button [add-card] · 7319:38983

Назначение из описания Figma: Дополнительный стиль tui-button

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=7319-38983). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-button-add-card) → [разрешённая ссылка Figma](https://www.figma.com/design/HErJrp1BcNRUFCyg3QccuG/tui-button?node-id=134-284588&t=Es87PtoJvQXFMiU2-1)

Варианты: 12 всего; 6 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| size | VARIANT | "large 54x36" | ["large 54x36", "medium 48x32", "small 40x26"] |
| state | VARIANT | "normal" | ["normal", "pressed"] |
| system | VARIANT | "iOS" | ["iOS", "Android"] |

Свойства состояний из импортированной матрицы: state

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Background/Neutral 1 On Dark | #ffffff1a |
| Text/Primary On Dark | #ffffff |

Текущий публичный API: `TUIButtonAddCard`, [реализация](../../Sources/TUIDesignSystem/Components/ButtonAddCard/TUIButtonAddCard.swift).
Зависимости, наблюдаемые в Swift-коде (не подтверждённый граф Figma): TUIButtonAddCardStyle, TUIColor, TUISpacing.

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
- Повторно подтвердить всю матрицу, спецификацию, взаимодействия, темы, AX и motion; оформить доказательства.

## tui-button [cell] · 53169:295889

Назначение из описания Figma: Кнопка-ссылка, растянутая на всю ширину. Вставляется в список с ячейками

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=53169-295889). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-button-cell) → [разрешённая ссылка Figma](https://www.figma.com/design/HErJrp1BcNRUFCyg3QccuG/tui-button?node-id=1-7&t=nSV2bpjYOJNu5ove-1)

Варианты: 32 всего; 16 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| appearance | VARIANT | "primary" | ["primary", "destructicve"] |
| icon#14280:33 | INSTANCE_SWAP | "12716:39618" | [{"type": "COMPONENT_SET", "key": "06cfffd0f9ecff20353e70ef5916cf79b066d875"}] |
| is-compact | VARIANT | "off" | ["on", "off"] |
| show-icon#14280:0 | BOOLEAN | false | [] |
| state | VARIANT | "normal" | ["normal", "disabled", "loading", "pressed"] |
| system | VARIANT | "iOS" | ["iOS", "Android"] |
| title#41541:45 | TEXT | "Label" | [] |

Свойства состояний из импортированной матрицы: state

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/Body L | Font(family: "Roboto", style: Regular, size: 16, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Background/Neutral 1 | #00102408 |
| Screen Padding | 16 |
| Service/Android/Ripple | #0000000a |
| Text/Action | #428bf9 |
| Text/Negative | #f52222 |
| iOS/Body L | Font(family: "SF Pro Text", style: Regular, size: 17, weight: 400, lineHeight: 100, letterSpacing: -0.4099999964237213) |

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

## tui-button [close] · 30258:432933

Назначение из описания Figma: Дополнительный стиль tui-button

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=30258-432933). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-button-close) → [разрешённая ссылка Figma](https://www.figma.com/design/HErJrp1BcNRUFCyg3QccuG/tui-button?node-id=1-5&t=zjDUZgIBMJO5Rtc5-1)

Варианты: 16 всего; 8 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| Theme | VARIANT | "light" | ["light", "dark", "—"] |
| environment | VARIANT | "on-base" | ["on-base", "on-light", "on-dark"] |
| size | VARIANT | "small" | ["small", "x-small"] |
| state | VARIANT | "normal" | ["normal"] |
| system | VARIANT | "ios" | ["android", "ios"] |

Свойства состояний из импортированной матрицы: state

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Background/Neutral 1 Opaque | #f6f7f8 |
| Background/Overlay Glass On Dark | #ffffff4d |
| Background/Overlay Glass On Light | #00000066 |
| Text/Action | #428bf9 |
| Text/Primary On Dark | #ffffff |
| Text/Primary On Light | #333333 |
| Text/Secondary | #9299a2 |

Текущий публичный API: `TUIButtonClose`, [реализация](../../Sources/TUIDesignSystem/Components/ButtonClose/TUIButtonClose.swift).
Зависимости, наблюдаемые в Swift-коде (не подтверждённый граф Figma): TUIButtonCloseStyle, TUIColor, TUISpacing, TUITheme.

### Сохранённые материалы и результат проверки

- [Documentation/References/ButtonClose/revalidation-2026-10-05.md](../../Documentation/References/ButtonClose/revalidation-2026-10-05.md)

Реализация: IMPLEMENTED. Приёмка: **in-progress**.

- variantMapping: **passed**. Все восемь применимых iOS-узлов сопоставлены API; сверены свойства и размеры тестом с импортированной матрицей и свежим контекстом Figma. Визуальная приёмка отдельно не завершена.
- specification: **pending**. Сверены размеры и увеличение AX1, озвучка и пример pressed; полный аудит спецификации ещё не завершён.
- visual: **pending**. Свежие экспорты всех восьми узлов сохранены. On-dark даёт RGB около 98 вместо рассчитанных из Figma около 77 на чёрном фоне; экспорт узла скомпонован на белом, нужен исходный пример с совпадающим фоном. Полная визуальная приёмка не завершена.
- interaction: **pending**. Единая повторная приёмка ещё не выполнена.
- accessibility: **not-applicable**. Explicit user scope exclusion for interactive prototypes: no VoiceOver, accessibility font enlargement or extra accessibility modes. This is a delivery scope waiver, not evidence that Figma has no accessibility requirements or that these modes were tested. Original check retained in previousAccessibilityCheck.
- motion: **pending**. Единая повторная приёмка ещё не выполнена.
- integration: **passed**. Актуальные компоненты компилируются в Swift Package и отдельном каталоге; полный набор 47 тестов пройден, каталог установлен и запущен. Приёмка внешнего вида и поведения выполняется отдельно.

Открытые вопросы:
- Устранить известное расхождение материала on-dark; сравнить все восемь вариантов.
- Визуально проверить новый pressed-фон, отпускание и отмену жеста; проверить VoiceOver и поведение.

## tui-button [like] · 44290:299166

Назначение из описания Figma: Стиль компонента Button

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=44290-299166). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-button-like) → [разрешённая ссылка Figma](https://www.figma.com/design/HErJrp1BcNRUFCyg3QccuG/tui-button?node-id=1-6&t=fsm2q4uGMv5RCEEO-1)

Варианты: 24 всего; 12 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| appearance | VARIANT | "secondary" | ["secondary", "glass-on-light", "glass-on-dark"] |
| is-selected | VARIANT | "off" | ["off", "on"] |
| state | VARIANT | "normal" | ["normal", "pressed"] |
| system | VARIANT | "ios" | ["ios", "android"] |

Свойства состояний из импортированной матрицы: is-selected, state

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Background/Neutral 1 | #00102408 |
| Background/Overlay Glass On Dark | #ffffff4d |
| Background/Overlay Glass On Light | #00000066 |
| Service/Android/Ripple | #0000000a |
| Service/Android/Ripple On Dark | #ffffff21 |
| State/Background/Neutral 1 Pressed | #0010240f |
| State/Background/Overlay Glass On Dark Pressed | #ffffff80 |
| State/Background/Overlay Glass On Light Pressed | #00000099 |
| Text/Action | #428bf9 |
| Text/Negative | #f52222 |
| Text/Primary On Dark | #ffffff |

Текущий публичный API: `TUIButtonLike`, [реализация](../../Sources/TUIDesignSystem/Components/ButtonLike/TUIButtonLike.swift).
Зависимости, наблюдаемые в Swift-коде (не подтверждённый граф Figma): TUIColor, TUIMotionCurve, TUISocialButtonAppearance, TUISocialButtonMetrics, TUISocialButtonState, TUISocialIconButtonStyle.

### Сохранённые материалы и результат проверки

- [Documentation/References/ButtonLike/specification-texts-2026-10-05.json](../../Documentation/References/ButtonLike/specification-texts-2026-10-05.json)

Реализация: IMPLEMENTED. Приёмка: **in-progress**.

- variantMapping: **passed**. Вся применимая iOS-матрица сопоставлена API и проверена тестом по импортированным node ID/свойствам. isSelected — Binding состояния Like.
- specification: **pending**. Найдены и прочитаны реальные страницы спецификаций в исходном файле Button; перенос AX1, labels, selected-семантики и motion выполняется. Короткие ссылки HTTP500 не являются текущим блокером.
- visual: **pending**. PDF-иконки видимы в нативном исполнении; сохранены 36 рендеров всех 18 вариантов Day/Night. Сравнение выявило дополнительное изменение оттенка стеклянным material. Получены четыре рендера Like на точном пёстром фоне спецификации. Полная визуальная приёмка не пройдена; стеклянный эффект требует исправления.
- interaction: **passed**. Нативный Button выполняет действие; Like изменяет Binding и снимает selected trait при повторном выборе. Drag за пределы кнопки отменяет действие и выбор; последующее нажатие работает. Проверено в настоящем приложении на iOS 26.4.1.
- accessibility: **not-applicable**. Explicit user scope exclusion for interactive prototypes: no VoiceOver, accessibility font enlargement or extra accessibility modes. This is a delivery scope waiver, not evidence that Figma has no accessibility requirements or that these modes were tested. Original check retained in previousAccessibilityCheck.
- motion: **pending**. Единая повторная приёмка ещё не выполнена.
- integration: **pending**. Единая повторная приёмка ещё не выполнена.

Открытые вопросы:
- Исправить/сверить стеклянные состояния с исходным blur на одинаковом пёстром фоне.
- Завершить полную проверку доступности и системного Reduce Motion.

## tui-button [link] · 42565:304987

Назначение из описания Figma: Стиль компонента Button

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=42565-304987). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-button-link) → [разрешённая ссылка Figma](https://www.figma.com/design/HErJrp1BcNRUFCyg3QccuG/tui-button?node-id=5-20137&t=61QLAz6M9714Q0Df-1)

Варианты: 16 всего; 8 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| Content | VARIANT | "Text" | ["Icon", "Text"] |
| State | VARIANT | "Normal" | ["Loading", "Normal", "Pressed", "Disabled"] |
| System | VARIANT | "iOS" | ["iOS", "Android"] |
| Text#53244:0 | TEXT | "Label" | [] |

Свойства состояний из импортированной матрицы: State

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/UI M Bold | Font(family: "Roboto", style: Medium, size: 14, weight: 500, lineHeight: 100, letterSpacing: 0) |
| Service/Android/Ripple | #0000000a |
| State/Text/Action Pressed | #156ed4 |
| Status/Info | #428bf9 |
| Text/Action | #428bf9 |
| Text/Tertiary | #00102438 |
| iOS/Body L | Font(family: "SF Pro Text", style: Regular, size: 17, weight: 400, lineHeight: 100, letterSpacing: -0.4099999964237213) |

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

## tui-button [on-light-on-dark] · 59194:53406

Назначение из описания Figma: Кнопки, внешний вид которых не меняется при переключении тем. Используются на контрастных фонах, цвет которых не зависит от темы

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=59194-53406). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-button-specs) → [разрешённая ссылка Figma](https://www.figma.com/design/HErJrp1BcNRUFCyg3QccuG/tui-button?node-id=1-3&t=MC3cfB58GDhCp9tW-1)

Варианты: 198 всего; 99 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| Icon (16)#59194:1 | INSTANCE_SWAP | "106794:35086" | [] |
| Icon#59194:0 | INSTANCE_SWAP | "41881:45334" | [] |
| Text#59194:2 | TEXT | "Label" | [] |
| appearance | VARIANT | "primary-grayscale-on-dark" | ["primary-grayscale-on-dark", "primary-grayscale-on-light", "secondary-grayscale-on-dark", "secondary-grayscale-on-light", "flat-grayscale-on-dark", "flat-grayscale-on-light", "glass-on-dark", "glass-on-light"] |
| show-Icon#59194:3 | BOOLEAN | false | [] |
| show-label#59194:4 | BOOLEAN | true | [] |
| size | VARIANT | "large" | ["large", "medium", "small"] |
| skeleton | VARIANT | "off" | ["off", "on"] |
| state | VARIANT | "normal" | ["normal", "pressed", "loading", "disabled"] |
| system | VARIANT | "ios" | ["android", "ios"] |

Свойства состояний из импортированной матрицы: state, skeleton

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/Body L | Font(family: "Roboto", style: Regular, size: 16, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/Body M | Font(family: "Roboto", style: Regular, size: 14, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/UI S Bold | Font(family: "Roboto", style: Medium, size: 13, weight: 500, lineHeight: 100, letterSpacing: 0) |
| Background/Accent On Dark | #ffffff |
| Background/Accent On Light | #000000 |
| Background/Neutral 1 On Dark | #ffffff1a |
| Background/Neutral 1 On Light | #00000008 |
| Background/Overlay Glass On Dark | #ffffff4d |
| Background/Overlay Glass On Light | #00000066 |
| Service/Android/Ripple On Dark | #ffffff21 |
| Service/Android/Ripple On Light | #0000000a |
| Service/Skeleton | #00000008 |
| State/Background/Accent On Dark Pressed | #f6f7f8 |
| State/Background/Accent On Light Pressed | #292929 |
| State/Background/Neutral 1 On Dark Pressed | #ffffff26 |
| State/Background/Neutral 1 On Light Pressed | #0000000f |
| State/Background/Overlay Glass On Dark Pressed | #ffffff80 |
| State/Background/Overlay Glass On Light Pressed | #00000099 |
| Text/Primary On Accent 1 | #333333 |
| Text/Primary On Dark | #ffffff |
| Text/Primary On Light | #333333 |
| Text/Tertiary On Dark | #ffffff4d |
| Text/Tertiary On Light | #00102438 |
| iOS/Body L | Font(family: "SF Pro Text", style: Regular, size: 17, weight: 400, lineHeight: 100, letterSpacing: -0.4099999964237213) |
| iOS/Body M | Font(family: "SF Pro Text", style: Regular, size: 15, weight: 400, lineHeight: 100, letterSpacing: -0.23999999463558197) |
| iOS/UI S Bold | Font(family: "SF Pro Text", style: Semibold, size: 13, weight: 600, lineHeight: 100, letterSpacing: -0.07999999821186066) |
| tui-button/radius-large | 16 |
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

## tui-button [share] · 44290:299199

Назначение из описания Figma: Стиль компонента Button

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=44290-299199). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-button-share) → [разрешённая ссылка Figma](https://www.figma.com/design/HErJrp1BcNRUFCyg3QccuG/tui-button?node-id=8573-7202&t=OM1oF2ATxVLUof9O-1)

Варианты: 12 всего; 6 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| appearance | VARIANT | "secondary" | ["glass-on-light", "secondary", "glass-on-dark"] |
| state | VARIANT | "normal" | ["normal", "pressed"] |
| system | VARIANT | "ios" | ["ios", "android"] |

Свойства состояний из импортированной матрицы: state

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Background/Neutral 1 | #00102408 |
| Background/Overlay Glass On Dark | #ffffff4d |
| Background/Overlay Glass On Light | #00000066 |
| Service/Android/Ripple | #0000000a |
| Service/Android/Ripple On Dark | #ffffff21 |
| State/Background/Neutral 1 Pressed | #0010240f |
| State/Background/Overlay Glass On Dark Pressed | #ffffff80 |
| State/Background/Overlay Glass On Light Pressed | #00000099 |
| Text/Action | #428bf9 |
| Text/Primary On Dark | #ffffff |

Текущий публичный API: `TUIButtonShare`, [реализация](../../Sources/TUIDesignSystem/Components/ButtonShare/TUIButtonShare.swift).
Зависимости, наблюдаемые в Swift-коде (не подтверждённый граф Figma): TUISocialButtonAppearance, TUISocialButtonMetrics, TUISocialButtonState, TUISocialIconButtonStyle.

### Сохранённые материалы и результат проверки

- [Documentation/References/ButtonShare/specification-texts-2026-10-05.json](../../Documentation/References/ButtonShare/specification-texts-2026-10-05.json)

Реализация: IMPLEMENTED. Приёмка: **in-progress**.

- variantMapping: **passed**. Вся применимая iOS-матрица сопоставлена API и проверена тестом по импортированным node ID/свойствам. isSelected — Binding состояния Like.
- specification: **pending**. Найдены и прочитаны реальные страницы спецификаций в исходном файле Button; перенос AX1, labels, selected-семантики и motion выполняется. Короткие ссылки HTTP500 не являются текущим блокером.
- visual: **pending**. PDF-иконки видимы в нативном исполнении; сохранены 36 рендеров всех 18 вариантов Day/Night. Сравнение выявило дополнительное изменение оттенка стеклянным material. Получены четыре рендера Like на точном пёстром фоне спецификации. Полная визуальная приёмка не пройдена; стеклянный эффект требует исправления.
- interaction: **passed**. Нативный Button выполняет действие; Like изменяет Binding и снимает selected trait при повторном выборе. Drag за пределы кнопки отменяет действие и выбор; последующее нажатие работает. Проверено в настоящем приложении на iOS 26.4.1.
- accessibility: **not-applicable**. Explicit user scope exclusion for interactive prototypes: no VoiceOver, accessibility font enlargement or extra accessibility modes. This is a delivery scope waiver, not evidence that Figma has no accessibility requirements or that these modes were tested. Original check retained in previousAccessibilityCheck.
- motion: **pending**. Единая повторная приёмка ещё не выполнена.
- integration: **pending**. Единая повторная приёмка ещё не выполнена.

Открытые вопросы:
- Исправить/сверить стеклянные состояния с исходным blur на одинаковом пёстром фоне.
- Завершить полную проверку доступности и системного Reduce Motion.

## tui-button [subscription] · 44236:302826

Назначение из описания Figma: Стиль tui-button с иконками подписок

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=44236-302826). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-button-subscription) → [разрешённая ссылка Figma](https://www.figma.com/design/HErJrp1BcNRUFCyg3QccuG/tui-button?node-id=6-41778&t=VeWHsGt8ja0tHe9O-1)

Варианты: 50 всего; 26 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| appearance | VARIANT | "premium" | ["premium", "pro", "private"] |
| size | VARIANT | "large" | ["large", "medium"] |
| skeleton | VARIANT | "off" | ["off", "on"] |
| state | VARIANT | "Default" | ["Default", "Disabled", "Loading", "Pressed"] |
| system | VARIANT | "iOS" | ["iOS", "Android"] |

Свойства состояний из импортированной матрицы: state, skeleton

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/Body L | Font(family: "Roboto", style: Regular, size: 16, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/Body M | Font(family: "Roboto", style: Regular, size: 14, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Background/Accent Opposite | #000000 |
| Background/Neutral 1 | #00102408 |
| Gradient/Brand/TS-Premium |  |
| Service/Android/Ripple On Light | #0000000a |
| Service/Android/Ripple On Opposite | #ffffff21 |
| Service/Skeleton | #00000008 |
| State/Background/Accent Opposite Pressed | #2c2c2e |
| Text/Primary | #333333 |
| Text/Primary On Dark | #ffffff |
| Text/Primary On Light | #333333 |
| Text/Primary On Opposite | #ffffff |
| Text/Tertiary On Light | #00102438 |
| iOS/Body L | Font(family: "SF Pro Text", style: Regular, size: 17, weight: 400, lineHeight: 100, letterSpacing: -0.4099999964237213) |
| iOS/Body M | Font(family: "SF Pro Text", style: Regular, size: 15, weight: 400, lineHeight: 100, letterSpacing: -0.23999999463558197) |
| tui-button/radius-large | 16 |
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

## tui-button [two labels] · 51388:47169

Назначение из описания Figma: Вариант обычной кнопки с 2 лейблами

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=51388-47169). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-button-specs) → [разрешённая ссылка Figma](https://www.figma.com/design/HErJrp1BcNRUFCyg3QccuG/tui-button?node-id=1-3&t=MC3cfB58GDhCp9tW-1)

Варианты: 20 всего; 10 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| platform | VARIANT | "iOS" | ["iOS", "Android"] |
| size | VARIANT | "large" | ["large", "medium"] |
| skeleton | VARIANT | "off" | ["off", "on"] |
| state | VARIANT | "normal" | ["normal", "pressed", "loading", "disabled"] |

Свойства состояний из импортированной матрицы: state, skeleton

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/Body L | Font(family: "Roboto", style: Regular, size: 16, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/Body M | Font(family: "Roboto", style: Regular, size: 14, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Background/Accent 1 | #ffdd2d |
| Background/Neutral 1 | #00102408 |
| Service/Android/Ripple On T-Bank | #fab61966 |
| Service/Skeleton | #00000008 |
| State/Background/Accent 1 Pressed | #ffcd33 |
| Text/Primary On Accent 1 | #333333 |
| Text/Tertiary | #00102438 |
| iOS/Body L | Font(family: "SF Pro Text", style: Regular, size: 17, weight: 400, lineHeight: 100, letterSpacing: -0.4099999964237213) |
| iOS/Body M | Font(family: "SF Pro Text", style: Regular, size: 15, weight: 400, lineHeight: 100, letterSpacing: -0.23999999463558197) |
| tui-button/radius-large | 16 |
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

## tui-button [vertical] · 41691:305320

Назначение из описания Figma: Вертикальный стиль кнопки tui-button

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=41691-305320). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-button-vertical) → [разрешённая ссылка Figma](https://www.figma.com/design/HErJrp1BcNRUFCyg3QccuG/tui-button?node-id=1-4&t=pDIlZNqVI2iz4c7Y-1)

Варианты: 8 всего; 4 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| Icon#42807:0 | INSTANCE_SWAP | "106794:35086" | [] |
| Skeleton | VARIANT | "off" | ["off", "on"] |
| State | VARIANT | "Normal" | ["Normal", "Pressed", "Disabled"] |
| System | VARIANT | "iOS" | ["iOS", "Android"] |

Свойства состояний из импортированной матрицы: State, Skeleton

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/UI XS | Font(family: "Roboto", style: Regular, size: 12, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Background/Neutral 1 | #00102408 |
| Component/Button Vertical | #428bf914 |
| Service/Android/Ripple | #0000000a |
| Service/Skeleton | #00000008 |
| State/Component/Button Vertical Pressed | #428bf929 |
| Text/Action | #428bf9 |
| Text/Tertiary | #00102438 |
| iOS/UI XS | Font(family: "SF Pro Text", style: Regular, size: 12, weight: 400, lineHeight: 100, letterSpacing: 0) |

Текущий публичный API: `TUIButtonVertical`, [реализация](../../Sources/TUIDesignSystem/Components/ButtonVertical/TUIButtonVertical.swift).
Зависимости, наблюдаемые в Swift-коде (не подтверждённый граф Figma): TUIButtonVerticalState, TUIColor.

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
- Повторно подтвердить всю матрицу, спецификацию, взаимодействия, темы, AX и motion; оформить доказательства.

## tui-button [wallet] · 54757:286088

Назначение из описания Figma: Нативные кнопки добавления в кошелек

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=54757-286088). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-button-wallet) → [разрешённая ссылка Figma](https://www.figma.com/design/HErJrp1BcNRUFCyg3QccuG/tui-button?node-id=6-41777&t=cCMnEiZRbgoviLIa-1)

Варианты: 34 всего; 2 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| Appearance | VARIANT | "Tinkoff Pay" | ["Apple Wallet", "Tinkoff Pay", "Google Pay", "Samsung Pay", "Mir Pay"] |
| Label#54470:0 | TEXT | "Добавить в " | [] |
| Size | VARIANT | "L - 56" | ["L - 56", "M - 44"] |
| State | VARIANT | "Normal" | ["Normal", "Pressed", "Loading", "Disabled"] |
| System | VARIANT | "Android" | ["iOS", "Android"] |

Свойства состояний из импортированной матрицы: State

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/Body L | Font(family: "Roboto", style: Regular, size: 16, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/Body M | Font(family: "Roboto", style: Regular, size: 14, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Background/Accent 1 | #ffdd2d |
| Background/Accent On Light | #000000 |
| Border/Darkmode Only | #00000000 |
| Brand/Mir Pay | #006848 |
| Service/Android/Ripple On Dark | #ffffff21 |
| Service/Android/Ripple On T-Bank | #fab61966 |
| Text/Primary On Accent 1 | #333333 |
| Text/Primary On Dark | #ffffff |
| iOS/Body L | Font(family: "SF Pro Text", style: Regular, size: 17, weight: 400, lineHeight: 100, letterSpacing: -0.4099999964237213) |
| tui-button/radius-large | 16 |
| tui-button/radius-medium | 12 |

Текущий публичный API: `TUIButtonWallet`, [реализация](../../Sources/TUIDesignSystem/Components/ButtonWallet/TUIButtonWallet.swift).
Зависимости, наблюдаемые в Swift-коде (не подтверждённый граф Figma): TUIFigmaTextFont, TUIRadius, TUISpacing, TUITypographyRole.

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
- Повторно подтвердить всю матрицу, спецификацию, взаимодействия, темы, AX и motion; оформить доказательства.

## tui-button tooltip · 25748:771367

Назначение из описания Figma: Стиль компонента Button

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=25748-771367). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-button-tooltip) → [разрешённая ссылка Figma](https://www.figma.com/design/HErJrp1BcNRUFCyg3QccuG/tui-button?node-id=1-8&t=jNJeGbaRipKRw5Pl-1)

Варианты: 16 всего; 8 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| icon | VARIANT | "hint" | ["hint", "info"] |
| is-pressed | VARIANT | "off" | ["off", "on"] |
| is-selected | VARIANT | "off" | ["off", "on"] |
| system | VARIANT | "ios" | ["ios", "android"] |

Свойства состояний из импортированной матрицы: is-selected, is-pressed

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Background/Accent 2 | #428bf9 |
| Background/Neutral 1 | #00102408 |
| Service/Android/Ripple | #0000000a |
| State/Background/Accent 2 Pressed | #126df7 |
| State/Background/Neutral 1 Pressed | #0010240f |
| Text/Primary On Dark | #ffffff |
| Text/Secondary | #9299a2 |

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

## tui-button-group-card · 36326:422777

Назначение из описания Figma: Компактный блок с быстрыми действиями. Может быть от 1 до 3 кнопок

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=36326-422777). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-button-group-card-specs) → [разрешённая ссылка Figma](https://www.figma.com/design/mIHvcOgh7vWNwIMDpHwXMe/tui-button-group-card)

Варианты: 22 всего; 11 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| appearance | VARIANT | "elevated" | ["dark-bg", "elevated", "flat"] |
| btn-1 badge icon#42988:19 | INSTANCE_SWAP | "79982:45522" | [] |
| btn-1 badge#42988:0 | BOOLEAN | false | [] |
| btn-1 icon#43374:152 | INSTANCE_SWAP | "62300:60215" | [] |
| btn-1 label#42988:57 | TEXT | "Button" | [] |
| btn-2 badge icon#43374:57 | INSTANCE_SWAP | "79982:45522" | [] |
| btn-2 badge#43374:38 | BOOLEAN | false | [] |
| btn-2 icon#43374:0 | INSTANCE_SWAP | "62300:60215" | [] |
| btn-2 label#43374:19 | TEXT | "Button" | [] |
| btn-3 badge icon#43374:133 | INSTANCE_SWAP | "79982:45522" | [] |
| btn-3 badge#43374:114 | BOOLEAN | false | [] |
| btn-3 icon#43374:76 | INSTANCE_SWAP | "62300:60215" | [] |
| btn-3 label#43374:95 | TEXT | "Button" | [] |
| buttons | VARIANT | "3" | ["3", "2", "1"] |
| skeleton | VARIANT | "off" | ["off", "on"] |
| system | VARIANT | "iOS" | ["iOS", "Android"] |

Свойства состояний из импортированной матрицы: skeleton

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/Body L | Font(family: "Roboto", style: Regular, size: 16, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/UI S Bold | Font(family: "Roboto", style: Medium, size: 13, weight: 500, lineHeight: 100, letterSpacing: 0) |
| Background/Elevation 1 | #ffffff |
| Background/Neutral 1 | #00102408 |
| Hide from publishing/Shadow/Medium/Blur | 34 |
| Hide from publishing/Shadow/Medium/Color | #0000001f |
| Hide from publishing/Shadow/Medium/Y-axis | 6 |
| Screen Padding | 16 |
| Service/Skeleton | #00000008 |
| Shadow/Medium | Effect(type: DROP_SHADOW, color: Hide from publishing/Shadow/Medium/Color, offset: (0, Hide from publishing/Shadow/Medium/Y-axis), radius: Hide from publishing/Shadow/Medium/Blur, spread: 0) |
| Text/Action | #428bf9 |
| Text/Primary On Dark | #ffffff |
| iOS/Body L | Font(family: "SF Pro Text", style: Regular, size: 17, weight: 400, lineHeight: 100, letterSpacing: -0.4099999964237213) |
| iOS/UI S Bold | Font(family: "SF Pro Text", style: Semibold, size: 13, weight: 600, lineHeight: 100, letterSpacing: -0.07999999821186066) |

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

## tui-link · 55278:70443

Назначение из описания Figma: UNVERIFIED: описание в импорте отсутствует.

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=55278-70443). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-link-specs) → [разрешённая ссылка Figma](https://www.figma.com/design/sLNvPatnUTkEeabuLCXk9O/tui-link?node-id=1-8839&t=EE7VbjhjIumxenCC-4)

Варианты: 30 всего; 15 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| icon-left#29801:31 | INSTANCE_SWAP | "55278:70419" | [] |
| label#29801:89 | TEXT | "Link" | [] |
| mode | VARIANT | "default" | ["default", "text-primary", "text-secondary", "text-primary-on-dark", "text-primary-on-light"] |
| platform | VARIANT | "iOS" | ["iOS", "Android"] |
| show-icon-left#29801:46 | BOOLEAN | true | [] |
| show-icon-right#29801:51 | BOOLEAN | true | [] |
| size | VARIANT | "large" | ["large", "medium", "small"] |

Свойства состояний из импортированной матрицы: UNVERIFIED: отдельные свойства состояний не импортированы.

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/UI L | Font(family: "Roboto", style: Regular, size: 16, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/UI M | Font(family: "Roboto", style: Regular, size: 14, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/UI S | Font(family: "Roboto", style: Regular, size: 13, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Service/Underline Grayscale | #9299a2 |
| Service/Underline Grayscale On Dark | #ffffff80 |
| Service/Underline Grayscale On Light | #00000052 |
| Text/Action | #428bf9 |
| Text/Primary | #333333 |
| Text/Primary On Dark | #ffffff |
| Text/Primary On Light | #333333 |
| Text/Secondary | #9299a2 |
| iOS/UI L | Font(family: "SF Pro Text", style: Regular, size: 17, weight: 400, lineHeight: 100, letterSpacing: -0.4099999964237213) |
| iOS/UI M | Font(family: "SF Pro Text", style: Regular, size: 15, weight: 400, lineHeight: 100, letterSpacing: -0.23999999463558197) |
| iOS/UI S | Font(family: "SF Pro Text", style: Regular, size: 13, weight: 400, lineHeight: 100, letterSpacing: -0.07999999821186066) |

Текущий публичный API: `TUILink`, [реализация](../../Sources/TUIDesignSystem/Components/Link/TUILink.swift).
Зависимости, наблюдаемые в Swift-коде (не подтверждённый граф Figma): TUIColor, TUILinkMode, TUILinkSize, TUITypographyRole.

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
- Повторно подтвердить всю матрицу, спецификацию, взаимодействия, темы, AX и motion; оформить доказательства.

