# Cells

Это индекс сохранённых источников и текущей приёмки. Он не добавляет новых требований Figma.

Публикация через MCP: UNVERIFIED. Полные ID вариантов и определения свойств: [inventory.json](../inventory.json).

## tui-cell · 41569:290555

Назначение из описания Figma: Ячейка с текстом

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=41569-290555). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-cell-specs) → [разрешённая ссылка Figma](https://www.figma.com/design/E5smFo7uxLRjWx7Ov2e3zt/tui-cell?node-id=17-2105&t=WeXeeUrSMWJYXvo3-1)

Варианты: 42 всего; 21 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| caption#41541:65 | TEXT | "Caption" | [] |
| description#41541:55 | TEXT | "Description" | [] |
| fixed-height | VARIANT | "on" | ["off", "on"] |
| right-side | VARIANT | "None" | ["None", "Text", "Accessory"] |
| show-avatar#41541:38 | BOOLEAN | true | [] |
| show-badge#42565:34 | BOOLEAN | true | [] |
| show-caption#41541:0 | BOOLEAN | false | [] |
| show-description#41541:10 | BOOLEAN | true | [] |
| show-hint#42565:51 | BOOLEAN | true | [] |
| skeleton | VARIANT | "off" | ["off", "on"] |
| system | VARIANT | "iOS" | ["iOS", "Android"] |
| title#41541:45 | TEXT | "Title" | [] |
| type | VARIANT | "Default" | ["Compact", "Default", "Extended"] |
| value#42565:0 | TEXT | "Value" | [] |
| value-description#42565:17 | TEXT | "Description" | [] |

Свойства состояний из импортированной матрицы: skeleton

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
| Background/Neutral 1 On Light | #00000008 |
| Component/Badge Notification | #f52222 |
| Gradient/Text/Primary Fade |  |
| Hide from publishing/Gradient/Text/Primary Fade Point 1 | #333333 |
| Hide from publishing/Gradient/Text/Primary Fade Point 2 | #33333300 |
| Service/Skeleton | #00000008 |
| Text/Primary | #333333 |
| Text/Primary On Dark | #ffffff |
| Text/Secondary | #9299a2 |
| accessory-min-height | 40 |
| accessory-padding | 8 |
| iOS/Body L | Font(family: "SF Pro Text", style: Regular, size: 17, weight: 400, lineHeight: 100, letterSpacing: -0.4099999964237213) |
| iOS/Body M | Font(family: "SF Pro Text", style: Regular, size: 15, weight: 400, lineHeight: 100, letterSpacing: -0.23999999463558197) |
| iOS/UI S | Font(family: "SF Pro Text", style: Regular, size: 13, weight: 400, lineHeight: 100, letterSpacing: -0.07999999821186066) |
| min-height | 56 |
| padding | 16 |
| text-padding | 8 |

Вложенные instances одного варианта `41569:290556`: [источник](../../Documentation/Inventory/2026-10-08/cell-variant-metadata-mcp.json). Их main Component ID и полный граф остаются UNVERIFIED.
- `41569:290558` · tui-avatar · скрыт в наблюдаемом варианте: False

Текущий публичный API: `TUICell`, [реализация](../../Sources/TUIDesignSystem/Components/Cell/TUICell.swift).
Зависимости, наблюдаемые в Swift-коде (не подтверждённый граф Figma): TUICellTextItem, TUICellTextLayout, TUICellTextSlot, TUIColor, TUIControlSize, TUIFigmaTextFont, TUIHeaderFontMetrics, TUIHeaderInlineLayout, TUIHeaderInlineRole, TUIHeaderLarge, TUIHeaderText, TUIMotionCurve, TUINotificationBadge, TUIOriginalSVGMask, TUISkeleton, TUISkeletonText, TUISpacing, TUITypographyRole.

### Сохранённые материалы и результат проверки

- [Documentation/References/Cell/implementation-review-2026-10-07.md](../../Documentation/References/Cell/implementation-review-2026-10-07.md)
- [Documentation/References/Cell/spec-138-66966-2026-10-08.txt](../../Documentation/References/Cell/spec-138-66966-2026-10-08.txt)
- [Documentation/References/Cell/spec-26-64448-2026-10-08.txt](../../Documentation/References/Cell/spec-26-64448-2026-10-08.txt)
- [Documentation/References/Cell/spec-26-64464-2026-10-08.txt](../../Documentation/References/Cell/spec-26-64464-2026-10-08.txt)
- [Documentation/References/Cell/spec-26-64565-2026-10-08.txt](../../Documentation/References/Cell/spec-26-64565-2026-10-08.txt)
- [Documentation/References/Cell/spec-26705-16023-2026-10-08.txt](../../Documentation/References/Cell/spec-26705-16023-2026-10-08.txt)
- [Documentation/References/Cell/spec-41-13497-2026-10-08.txt](../../Documentation/References/Cell/spec-41-13497-2026-10-08.txt)
- [Documentation/References/Cell/spec-70-90403-2026-10-07.txt](../../Documentation/References/Cell/spec-70-90403-2026-10-07.txt)
- [Documentation/References/Cell/spec-730-12025-2026-10-08.txt](../../Documentation/References/Cell/spec-730-12025-2026-10-08.txt)
- [Documentation/References/Cell/spec-730-12154-2026-10-08.txt](../../Documentation/References/Cell/spec-730-12154-2026-10-08.txt)
- [Documentation/References/Cell/spec-730-17716-2026-10-07.txt](../../Documentation/References/Cell/spec-730-17716-2026-10-07.txt)
- [Documentation/References/Cell/spec-730-20379-2026-10-08.txt](../../Documentation/References/Cell/spec-730-20379-2026-10-08.txt)
- [Documentation/References/Cell/spec-731-21319-2026-10-08.txt](../../Documentation/References/Cell/spec-731-21319-2026-10-08.txt)
- [Documentation/References/Cell/spec-731-23518-2026-10-07.txt](../../Documentation/References/Cell/spec-731-23518-2026-10-07.txt)
- [Documentation/References/Cell/spec-731-24168-2026-10-08.txt](../../Documentation/References/Cell/spec-731-24168-2026-10-08.txt)
- [Documentation/References/Cell/spec-734-25300-2026-10-07.txt](../../Documentation/References/Cell/spec-734-25300-2026-10-07.txt)
- [Documentation/References/Cell/spec-8876-21436-2026-10-08.txt](../../Documentation/References/Cell/spec-8876-21436-2026-10-08.txt)
- [Documentation/References/Cell/spec-95-26686-2026-10-08.txt](../../Documentation/References/Cell/spec-95-26686-2026-10-08.txt)
- [Documentation/References/Cell/spec-metadata-2026-10-07.txt](../../Documentation/References/Cell/spec-metadata-2026-10-07.txt)
- [Documentation/References/Cell/spec-text-index-2026-10-08.json](../../Documentation/References/Cell/spec-text-index-2026-10-08.json)
- [Documentation/References/Cell/spec-text-sections-2026-10-08.txt](../../Documentation/References/Cell/spec-text-sections-2026-10-08.txt)
- [Documentation/References/Cell/specification-progress-2026-10-08.md](../../Documentation/References/Cell/specification-progress-2026-10-08.md)
- [Documentation/Validation/2026-10-08/CellWidth/mcp-result.json](../../Documentation/Validation/2026-10-08/CellWidth/mcp-result.json)
- [Documentation/Validation/2026-10-08/CellWidth/test.log](../../Documentation/Validation/2026-10-08/CellWidth/test.log)

Реализация: IMPLEMENTED. Приёмка: **in-progress**.

- variantMapping: **pending**. Все 21 исходных iOS-варианта сопоставлены с явным Variant и сверены тестом свойств. Полная спецификация и дополнительные instance-состояния ещё не приняты.
- specification: **pending**. Дополнительно прочитаны кастомизация, размеры, ресайз, корнер-кейсы и правила AX1. 73/88 текстовых подузлов получены; 15 остановлены лимитом Figma MCP, включая основную озвучку и мобильные подпункты отступов. Полная приёмка pending.
- visual: **pending**. Все 21 исходных варианта повторно отрисованы Day/Night; 42 стандартных PNG попиксельно совпали с предыдущим прогоном. Шесть Day-пар и восемь дополнительных состояний сохранены. Полная матрица, Night-сверка и дополнительные состояния по спецификации ещё pending. System SF Pro chosen by user on 2026-10-20; bundled legacy font inputs retired to historicalInputHashes. Historical renders do not accept the new system face.
- interaction: **pending**. После исправления Form-строк два CellUITests Passed: действия подсказки, выбор Compact, включение inline-бейджа в Default. Нажатие всей ячейки, pressed/cancellation и полный lifecycle tooltip ещё pending.
- accessibility: **not-applicable**. Explicit user scope exclusion for interactive prototypes: no VoiceOver, accessibility font enlargement or extra accessibility modes. This is a delivery scope waiver, not evidence that Figma has no accessibility requirements or that these modes were tested. Original check retained in previousAccessibilityCheck.
- motion: **pending**. Единая повторная приёмка ещё не выполнена.
- integration: **pending**. Текущий прогон: 14 пакетных тестов Passed (7 Cell, 6 CardLarge, 138 скомпилированных веб-примеров); 2 Cell и 2 CardLarge UI-теста Passed в своих актуальных standalone-прогонах. Независимый потребитель и все состояния спецификации ещё pending.

Открытые вопросы:
- Полная спецификация и VoiceOver: 15 текстовых подузлов ещё не прочитаны. 8 октября после согласованного добавления папки и перезапуска Figma доступ Desktop MCP к экспорту восстановлен; прежний лимит remote MCP не мешает продолжить чтение через Desktop.
- Не приняты все дополнительные состояния: высоты/отступы по контекстам, применение ограничений ширины к Accessory, выравнивание и контентные исключения, notification/comments/sensitive-mode, disabled.
- Нажатие всей ячейки, pressed-color алгоритм, отмена/scroll и полный жизненный цикл подсказки ещё требуют реализации и проверки.
- Все source/native пары, Night-сходство, реальный VoiceOver, измеренные motion/Reduce Motion и независимый потребитель ещё pending.
- Reverify native system SF Pro after explicit user decision 2026-10-20; legacy font binaries are no longer distributed. Historical visual evidence is not acceptance of the new face.

## tui-cell [account] · 2793:73350

Назначение из описания Figma: UNVERIFIED: описание в импорте отсутствует.

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=2793-73350). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-cell-specs) → [разрешённая ссылка Figma](https://www.figma.com/design/E5smFo7uxLRjWx7Ov2e3zt/tui-cell?node-id=17-2105&t=WeXeeUrSMWJYXvo3-1)

Варианты: 14 всего; 7 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| account-type | VARIANT | "—" | ["—", "Debit", "Deposit", "Credit", "Saving", "Invest"] |
| badges#7:13 | BOOLEAN | true | [] |
| bonus#3:19 | BOOLEAN | true | [] |
| caption#41541:65 | TEXT | "Caption" | [] |
| cashback#3:5 | BOOLEAN | true | [] |
| family-access#3:0 | BOOLEAN | true | [] |
| income#3:10 | BOOLEAN | true | [] |
| loss#7:0 | BOOLEAN | false | [] |
| right-side | VARIANT | "Text" | ["Text"] |
| show-avatar#41541:38 | BOOLEAN | true | [] |
| show-caption#41541:0 | BOOLEAN | false | [] |
| show-description#41541:10 | BOOLEAN | true | [] |
| skeleton | VARIANT | "off" | ["off", "on"] |
| system | VARIANT | "iOS" | ["iOS", "Android"] |
| title#41541:45 | TEXT | "100 000 ₽" | [] |

Свойства состояний из импортированной матрицы: skeleton

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/Body M | Font(family: "Roboto", style: Regular, size: 14, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/Heading S Bold | Font(family: "Roboto", style: Bold, size: 16, weight: 700, lineHeight: 100, letterSpacing: 0) |
| Android/UI XXS Bold | Font(family: "Roboto", style: Bold, size: 11, weight: 700, lineHeight: 100, letterSpacing: 0) |
| Background/Accent 2 | #428bf9 |
| Background/Neutral 2 | #0010240f |
| Background/Neutral 4 | #00102438 |
| Gradient/Text/Primary Fade |  |
| Hide from publishing/Gradient/Text/Primary Fade Point 1 | #333333 |
| Hide from publishing/Gradient/Text/Primary Fade Point 2 | #33333300 |
| Service/Skeleton | #00000008 |
| Status/Info | #428bf9 |
| Status/Positive Pale | #00b92d29 |
| Text/Positive | #00b92d |
| Text/Primary On Dark | #ffffff |
| bg blur | Effect(type: BACKGROUND_BLUR, radius: 10) |
| iOS/Body M | Font(family: "SF Pro Text", style: Regular, size: 15, weight: 400, lineHeight: 100, letterSpacing: -0.23999999463558197) |
| iOS/Heading S Bold | Font(family: "SF Pro Text", style: Bold, size: 17, weight: 600, lineHeight: 100, letterSpacing: -0.4099999964237213) |
| iOS/UI XXS Bold | Font(family: "SF Pro Text", style: Bold, size: 11, weight: 700, lineHeight: 100, letterSpacing: -0.10000000149011612) |
| min-height | 56 |
| padding | 16 |
| text-padding | 8 |

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

## tui-cell [action] · 41637:306482

Назначение из описания Figma: Ячейка с действием

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=41637-306482). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-cell-specs) → [разрешённая ссылка Figma](https://www.figma.com/design/E5smFo7uxLRjWx7Ov2e3zt/tui-cell?node-id=17-2105&t=WeXeeUrSMWJYXvo3-1)

Варианты: 10 всего; 5 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| accessories | VARIANT | "off" | ["off", "on"] |
| action-text#41637:27 | TEXT | "Action" | [] |
| caption#41541:65 | TEXT | "Caption" | [] |
| description#41541:55 | TEXT | "Description" | [] |
| fixed-height | VARIANT | "on" | ["on", "off"] |
| show-avatar#41541:38 | BOOLEAN | true | [] |
| show-badge#55902:146 | BOOLEAN | true | [] |
| show-caption#41541:0 | BOOLEAN | false | [] |
| show-description#41541:10 | BOOLEAN | true | [] |
| show-hint#55902:147 | BOOLEAN | true | [] |
| skeleton | VARIANT | "off" | ["off", "on"] |
| system | VARIANT | "iOS" | ["iOS", "Android"] |
| title#41541:45 | TEXT | "Title" | [] |

Свойства состояний из импортированной матрицы: skeleton

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
| Component/Badge Notification | #f52222 |
| Gradient/Text/Primary Fade |  |
| Gradient/Text/Secondary Fade |  |
| Hide from publishing/Gradient/Text/Primary Fade Point 1 | #333333 |
| Hide from publishing/Gradient/Text/Primary Fade Point 2 | #33333300 |
| Hide from publishing/Gradient/Text/Secondary Fade Point 1 | #9299a2 |
| Hide from publishing/Gradient/Text/Secondary Fade Point 2 | #9299a200 |
| Service/Skeleton | #00000008 |
| Text/Action | #428bf9 |
| Text/Primary | #333333 |
| Text/Primary On Dark | #ffffff |
| Text/Secondary | #9299a2 |
| accessory-min-height | 40 |
| iOS/Body L | Font(family: "SF Pro Text", style: Regular, size: 17, weight: 400, lineHeight: 100, letterSpacing: -0.4099999964237213) |
| iOS/Body M | Font(family: "SF Pro Text", style: Regular, size: 15, weight: 400, lineHeight: 100, letterSpacing: -0.23999999463558197) |
| iOS/UI S | Font(family: "SF Pro Text", style: Regular, size: 13, weight: 400, lineHeight: 100, letterSpacing: -0.07999999821186066) |
| min-height | 56 |
| padding | 16 |
| text-padding | 8 |

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

## tui-cell [button] · 41637:306089

Назначение из описания Figma: Ячейка с кнопкой

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=41637-306089). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-cell-specs) → [разрешённая ссылка Figma](https://www.figma.com/design/E5smFo7uxLRjWx7Ov2e3zt/tui-cell?node-id=17-2105&t=WeXeeUrSMWJYXvo3-1)

Варианты: 10 всего; 5 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| accessories | VARIANT | "off" | ["off", "on"] |
| caption#41541:65 | TEXT | "Caption" | [] |
| description#41541:55 | TEXT | "Description" | [] |
| fixed-height | VARIANT | "on" | ["on", "off"] |
| show-avatar#41541:38 | BOOLEAN | true | [] |
| show-badge#55902:92 | BOOLEAN | true | [] |
| show-caption#41541:0 | BOOLEAN | false | [] |
| show-description#41541:10 | BOOLEAN | true | [] |
| show-hint#55902:101 | BOOLEAN | true | [] |
| skeleton | VARIANT | "off" | ["off", "on"] |
| system | VARIANT | "iOS" | ["iOS", "Android"] |
| title#41541:45 | TEXT | "Title" | [] |

Свойства состояний из импортированной матрицы: skeleton

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/Body L | Font(family: "Roboto", style: Regular, size: 16, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/Body M | Font(family: "Roboto", style: Regular, size: 14, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/UI S | Font(family: "Roboto", style: Regular, size: 13, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/UI S Bold | Font(family: "Roboto", style: Medium, size: 13, weight: 500, lineHeight: 100, letterSpacing: 0) |
| Background/Accent 1 | #ffdd2d |
| Background/Accent 2 | #428bf9 |
| Background/Neutral 1 | #00102408 |
| Component/Badge Notification | #f52222 |
| Gradient/Text/Primary Fade |  |
| Gradient/Text/Secondary Fade |  |
| Hide from publishing/Gradient/Text/Primary Fade Point 1 | #333333 |
| Hide from publishing/Gradient/Text/Primary Fade Point 2 | #33333300 |
| Hide from publishing/Gradient/Text/Secondary Fade Point 1 | #9299a2 |
| Hide from publishing/Gradient/Text/Secondary Fade Point 2 | #9299a200 |
| Service/Skeleton | #00000008 |
| Text/Primary | #333333 |
| Text/Primary On Accent 1 | #333333 |
| Text/Primary On Dark | #ffffff |
| Text/Secondary | #9299a2 |
| accessory-min-height | 40 |
| accessory-padding | 8 |
| iOS/Body L | Font(family: "SF Pro Text", style: Regular, size: 17, weight: 400, lineHeight: 100, letterSpacing: -0.4099999964237213) |
| iOS/Body M | Font(family: "SF Pro Text", style: Regular, size: 15, weight: 400, lineHeight: 100, letterSpacing: -0.23999999463558197) |
| iOS/UI S | Font(family: "SF Pro Text", style: Regular, size: 13, weight: 400, lineHeight: 100, letterSpacing: -0.07999999821186066) |
| iOS/UI S Bold | Font(family: "SF Pro Text", style: Semibold, size: 13, weight: 600, lineHeight: 100, letterSpacing: -0.07999999821186066) |
| min-height | 56 |
| padding | 16 |
| text-padding | 8 |

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

## tui-cell [checkbox] · 41637:307793

Назначение из описания Figma: Ячейка с чекбоксом

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=41637-307793). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-cell-specs) → [разрешённая ссылка Figma](https://www.figma.com/design/E5smFo7uxLRjWx7Ov2e3zt/tui-cell?node-id=17-2105&t=WeXeeUrSMWJYXvo3-1)

Варианты: 18 всего; 9 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| accessories | VARIANT | "off" | ["off", "on"] |
| caption#41541:65 | TEXT | "Caption" | [] |
| description#41541:55 | TEXT | "Description" | [] |
| fixed-height | VARIANT | "on" | ["off", "on"] |
| selected | VARIANT | "off" | ["off", "on"] |
| show-avatar#41541:38 | BOOLEAN | true | [] |
| show-badge#41569:0 | BOOLEAN | true | [] |
| show-caption#41541:0 | BOOLEAN | false | [] |
| show-description#41541:10 | BOOLEAN | true | [] |
| show-hint#41569:9 | BOOLEAN | true | [] |
| skeleton | VARIANT | "off" | ["on", "off"] |
| system | VARIANT | "iOS" | ["iOS", "Android"] |
| title#41541:45 | TEXT | "Title" | [] |

Свойства состояний из импортированной матрицы: selected, skeleton

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
| Background/Neutral 4 | #00102438 |
| Component/Badge Notification | #f52222 |
| Gradient/Text/Primary Fade |  |
| Gradient/Text/Secondary Fade |  |
| Hide from publishing/Gradient/Text/Primary Fade Point 1 | #333333 |
| Hide from publishing/Gradient/Text/Primary Fade Point 2 | #33333300 |
| Hide from publishing/Gradient/Text/Secondary Fade Point 1 | #9299a2 |
| Hide from publishing/Gradient/Text/Secondary Fade Point 2 | #9299a200 |
| Service/Skeleton | #00000008 |
| Text/Primary | #333333 |
| Text/Primary On Dark | #ffffff |
| Text/Primary On Opposite | #ffffff |
| Text/Secondary | #9299a2 |
| accessory-min-height | 40 |
| accessory-padding | 8 |
| iOS/Body L | Font(family: "SF Pro Text", style: Regular, size: 17, weight: 400, lineHeight: 100, letterSpacing: -0.4099999964237213) |
| iOS/Body M | Font(family: "SF Pro Text", style: Regular, size: 15, weight: 400, lineHeight: 100, letterSpacing: -0.23999999463558197) |
| iOS/UI S | Font(family: "SF Pro Text", style: Regular, size: 13, weight: 400, lineHeight: 100, letterSpacing: -0.07999999821186066) |
| min-height | 56 |
| padding | 16 |
| text-padding | 8 |

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

## tui-cell [checkicon] · 41637:306903

Назначение из описания Figma: Ячейка с иконкой выбора

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=41637-306903). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-cell-specs) → [разрешённая ссылка Figma](https://www.figma.com/design/E5smFo7uxLRjWx7Ov2e3zt/tui-cell?node-id=17-2105&t=WeXeeUrSMWJYXvo3-1)

Варианты: 6 всего; 3 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| caption#41541:65 | TEXT | "Caption" | [] |
| description#41541:55 | TEXT | "Description" | [] |
| fixed-height | VARIANT | "on" | ["off", "on"] |
| show-avatar#41541:38 | BOOLEAN | true | [] |
| show-caption#41541:0 | BOOLEAN | false | [] |
| show-description#41541:10 | BOOLEAN | true | [] |
| show-selected#49089:0 | BOOLEAN | true | [] |
| skeleton | VARIANT | "off" | ["on", "off"] |
| system | VARIANT | "iOS" | ["iOS", "Android"] |
| title#41541:45 | TEXT | "Title" | [] |

Свойства состояний из импортированной матрицы: show-selected#49089:0, skeleton

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/Body L | Font(family: "Roboto", style: Regular, size: 16, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/UI S | Font(family: "Roboto", style: Regular, size: 13, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Background/Accent 2 | #428bf9 |
| Gradient/Text/Primary Fade |  |
| Gradient/Text/Secondary Fade |  |
| Hide from publishing/Gradient/Text/Primary Fade Point 1 | #333333 |
| Hide from publishing/Gradient/Text/Primary Fade Point 2 | #33333300 |
| Hide from publishing/Gradient/Text/Secondary Fade Point 1 | #9299a2 |
| Hide from publishing/Gradient/Text/Secondary Fade Point 2 | #9299a200 |
| Service/Skeleton | #00000008 |
| Text/Action | #428bf9 |
| Text/Primary | #333333 |
| Text/Primary On Dark | #ffffff |
| Text/Secondary | #9299a2 |
| accessory-min-height | 40 |
| accessory-padding | 8 |
| iOS/Body L | Font(family: "SF Pro Text", style: Regular, size: 17, weight: 400, lineHeight: 100, letterSpacing: -0.4099999964237213) |
| iOS/UI S | Font(family: "SF Pro Text", style: Regular, size: 13, weight: 400, lineHeight: 100, letterSpacing: -0.07999999821186066) |
| min-height | 56 |
| padding | 16 |
| text-padding | 8 |

Текущий публичный API: `TUICellCheckicon`, [реализация](../../Sources/TUIDesignSystem/Components/Cell/TUICellCheckicon.swift).
Зависимости, наблюдаемые в Swift-коде (не подтверждённый граф Figma): TUICellCheckiconButtonStyle, TUICellCheckiconClippedText, TUICellCheckiconFadeLabel, TUICellCheckiconLayout, TUICellCheckiconReduceMotionPreviewKey, TUICellCheckiconSlot, TUICellCheckiconText, TUIColor, TUIControlSize, TUIFigmaTextFont, TUIMotionCurve, TUISkeletonText, TUISpacing, TUITypographyRole.

### Сохранённые материалы и результат проверки

- [Documentation/References/CellCheckicon/revalidation-2026-10-05.md](../../Documentation/References/CellCheckicon/revalidation-2026-10-05.md)
- [Documentation/References/CellCheckicon/source-inspection-2026-10-05.json](../../Documentation/References/CellCheckicon/source-inspection-2026-10-05.json)

Реализация: IMPLEMENTED. Приёмка: **in-progress**.

- variantMapping: **passed**. Все три применимых iOS-варианта и свойства экземпляра сопоставлены публичному API по импорту и текущей панели Properties приложения Figma. Полная визуальная приёмка отдельно не завершена.
- specification: **pending**. Свежие выдержки о тексте, AX1, аксессуаре, VoiceOver и движении сохранены; повторная проверка всех примеров спецификации остаётся открытой.
- visual: **pending**. Базовые три пары Figma/симулятор обновлены после исправления высоты. Дополнительные случаи спецификации и анимации ещё не приняты. Общий Skeleton изменён; его прежний статический снимок не подтверждает актуальный код. System SF Pro chosen by user on 2026-10-20; bundled legacy font inputs retired to historicalInputHashes. Historical renders do not accept the new system face.
- interaction: **pending**. Единая повторная приёмка ещё не выполнена.
- accessibility: **not-applicable**. Explicit user scope exclusion for interactive prototypes: no VoiceOver, accessibility font enlargement or extra accessibility modes. This is a delivery scope waiver, not evidence that Figma has no accessibility requirements or that these modes were tested. Original check retained in previousAccessibilityCheck.
- motion: **pending**. Единая повторная приёмка ещё не выполнена.
- integration: **pending**. Актуальные компоненты компилируются в Swift Package и отдельном каталоге; полный набор 47 тестов пройден, каталог установлен и запущен. Приёмка внешнего вида и поведения выполняется отдельно.

Открытые вопросы:
- Повторить после исправления высоты дополнительные примеры компоновки, AX1/AX5, reflow и нестандартный аксессуар; измерить переходы и системный Reduce Motion; проверить озвучку VoiceOver.
- После изменения общего Skeleton повторить статический эталон skeleton и принять унаследованный цикл; прежний снимок до изменения углов/анимации архивный.
- Reverify native system SF Pro after explicit user decision 2026-10-20; legacy font binaries are no longer distributed. Historical visual evidence is not acceptance of the new face.

## tui-cell [connected] · 53219:295268

Назначение из описания Figma: Ячейка с соединительными линиями

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=53219-295268). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-cell-connected-specs) → [разрешённая ссылка Figma](https://www.figma.com/design/E5smFo7uxLRjWx7Ov2e3zt/tui-cell)

Варианты: 6 всего; 3 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| caption text#41541:65 | TEXT | "Caption" | [] |
| caption#41541:0 | BOOLEAN | false | [] |
| description text#41541:55 | TEXT | "Description" | [] |
| description#41541:10 | BOOLEAN | true | [] |
| fixed-height | VARIANT | "on" | ["off", "on"] |
| show bottom connect#53219:0 | BOOLEAN | true | [] |
| show top connect#53219:5 | BOOLEAN | true | [] |
| show-accessories#62256:0 | BOOLEAN | false | [] |
| skeleton | VARIANT | "off" | ["off", "on"] |
| system | VARIANT | "ios" | ["ios", "android"] |
| title#41541:45 | TEXT | "Title" | [] |
| version | VARIANT | "actual" | ["actual"] |

Свойства состояний из импортированной матрицы: skeleton

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/Body L | Font(family: "Roboto", style: Regular, size: 16, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/UI S | Font(family: "Roboto", style: Regular, size: 13, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Background/Accent 2 | #428bf9 |
| Background/Neutral 3 | #0010241f |
| Gradient/Text/Primary Fade |  |
| Gradient/Text/Secondary Fade |  |
| Hide from publishing/Gradient/Text/Primary Fade Point 1 | #333333 |
| Hide from publishing/Gradient/Text/Primary Fade Point 2 | #33333300 |
| Hide from publishing/Gradient/Text/Secondary Fade Point 1 | #9299a2 |
| Hide from publishing/Gradient/Text/Secondary Fade Point 2 | #9299a200 |
| Service/Skeleton | #00000008 |
| Text/Primary | #333333 |
| Text/Primary On Dark | #ffffff |
| Text/Secondary | #9299a2 |
| iOS/Body L | Font(family: "SF Pro Text", style: Regular, size: 17, weight: 400, lineHeight: 100, letterSpacing: -0.4099999964237213) |
| iOS/UI S | Font(family: "SF Pro Text", style: Regular, size: 13, weight: 400, lineHeight: 100, letterSpacing: -0.07999999821186066) |
| min-height | 56 |
| padding | 16 |
| text-padding | 8 |

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

## tui-cell [disclosure] · 41637:305628

Назначение из описания Figma: Ячейка с индикатором раскрытия

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=41637-305628). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-cell-specs) → [разрешённая ссылка Figma](https://www.figma.com/design/E5smFo7uxLRjWx7Ov2e3zt/tui-cell?node-id=17-2105&t=WeXeeUrSMWJYXvo3-1)

Варианты: 20 всего; 10 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| accessories | VARIANT | "off" | ["off", "on"] |
| caption#41541:65 | TEXT | "Caption" | [] |
| compact | VARIANT | "off" | ["off", "on"] |
| description#41541:55 | TEXT | "Description" | [] |
| disclosure-text#41637:18 | TEXT | "Text" | [] |
| fixed-height | VARIANT | "on" | ["off", "on"] |
| show-avatar#41541:38 | BOOLEAN | true | [] |
| show-badge#41637:36 | BOOLEAN | true | [] |
| show-caption#41541:0 | BOOLEAN | false | [] |
| show-description#41541:10 | BOOLEAN | true | [] |
| show-disclosure-text#41637:0 | BOOLEAN | true | [] |
| show-hint#41637:45 | BOOLEAN | true | [] |
| skeleton | VARIANT | "off" | ["on", "off"] |
| system | VARIANT | "iOS" | ["iOS", "Android"] |
| title#41541:45 | TEXT | "Title" | [] |

Свойства состояний из импортированной матрицы: skeleton

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
| Component/Badge Notification | #f52222 |
| Gradient/Text/Primary Fade |  |
| Gradient/Text/Secondary Fade |  |
| Hide from publishing/Gradient/Text/Primary Fade Point 1 | #333333 |
| Hide from publishing/Gradient/Text/Primary Fade Point 2 | #33333300 |
| Hide from publishing/Gradient/Text/Secondary Fade Point 1 | #9299a2 |
| Hide from publishing/Gradient/Text/Secondary Fade Point 2 | #9299a200 |
| Service/Skeleton | #00000008 |
| Text/Primary | #333333 |
| Text/Primary On Dark | #ffffff |
| Text/Secondary | #9299a2 |
| Text/Tertiary | #00102438 |
| accessory-min-height | 40 |
| accessory-padding | 8 |
| iOS/Body L | Font(family: "SF Pro Text", style: Regular, size: 17, weight: 400, lineHeight: 100, letterSpacing: -0.4099999964237213) |
| iOS/Body M | Font(family: "SF Pro Text", style: Regular, size: 15, weight: 400, lineHeight: 100, letterSpacing: -0.23999999463558197) |
| iOS/UI S | Font(family: "SF Pro Text", style: Regular, size: 13, weight: 400, lineHeight: 100, letterSpacing: -0.07999999821186066) |
| min-height | 56 |
| padding | 16 |
| text-padding | 8 |

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

## tui-cell [invest] · 44305:304744

Назначение из описания Figma: Шаблон ячейки для инвестиций на основе tui-cell-operation

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=44305-304744). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-cell-specs) → [разрешённая ссылка Figma](https://www.figma.com/design/E5smFo7uxLRjWx7Ov2e3zt/tui-cell?node-id=17-2105&t=WeXeeUrSMWJYXvo3-1)

Варианты: 14 всего; 7 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| caption#41541:65 | TEXT | "Caption" | [] |
| description#41541:55 | TEXT | "Description" | [] |
| fixed-height | VARIANT | "off" | ["off", "on"] |
| negative-value#44305:29 | TEXT | "−99,99 ₽" | [] |
| positive-value#44305:20 | TEXT | "+99,99 ₽" | [] |
| show-avatar#41541:38 | BOOLEAN | true | [] |
| show-blue-badge#44305:5 | BOOLEAN | true | [] |
| show-caption#41541:0 | BOOLEAN | false | [] |
| show-checkbox#44290:30 | BOOLEAN | false | [] |
| show-description#41541:10 | BOOLEAN | true | [] |
| show-green-badge#44305:15 | BOOLEAN | true | [] |
| show-lock-badge#44305:0 | BOOLEAN | true | [] |
| show-notification#44290:0 | BOOLEAN | false | [] |
| show-red-badge#44305:10 | BOOLEAN | true | [] |
| skeleton | VARIANT | "off" | ["off", "on"] |
| system | VARIANT | "iOS" | ["iOS", "Android"] |
| title#41541:45 | TEXT | "Title" | [] |
| value#42565:0 | TEXT | "Value" | [] |
| value-description#42565:17 | TEXT | "Description" | [] |
| value-description-style | VARIANT | "Text" | ["Text", "Positive", "Negative"] |

Свойства состояний из импортированной матрицы: skeleton

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/Body L | Font(family: "Roboto", style: Regular, size: 16, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/Body M | Font(family: "Roboto", style: Regular, size: 14, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/UI S | Font(family: "Roboto", style: Regular, size: 13, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/UI XXS Bold | Font(family: "Roboto", style: Bold, size: 11, weight: 700, lineHeight: 100, letterSpacing: 0) |
| Background/Accent 2 | #428bf9 |
| Background/Neutral 4 | #00102438 |
| Service/Skeleton | #00000008 |
| Status/Negative | #f52222 |
| Status/Positive | #00b92d |
| Text/Negative | #f52222 |
| Text/Positive | #00b92d |
| Text/Primary | #333333 |
| Text/Primary On Dark | #ffffff |
| Text/Secondary | #9299a2 |
| bg blur | Effect(type: BACKGROUND_BLUR, radius: 10) |
| iOS/Body L | Font(family: "SF Pro Text", style: Regular, size: 17, weight: 400, lineHeight: 100, letterSpacing: -0.4099999964237213) |
| iOS/UI S | Font(family: "SF Pro Text", style: Regular, size: 13, weight: 400, lineHeight: 100, letterSpacing: -0.07999999821186066) |
| iOS/UI XXS Bold | Font(family: "SF Pro Text", style: Bold, size: 11, weight: 700, lineHeight: 100, letterSpacing: -0.10000000149011612) |
| min-height | 80 |
| text-padding | 20 |

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

## tui-cell [mobile] · 63132:295599

Назначение из описания Figma: Шаблон ячейки для Мобайла

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=63132-295599). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-cell-specs) → [разрешённая ссылка Figma](https://www.figma.com/design/E5smFo7uxLRjWx7Ov2e3zt/tui-cell?node-id=17-2105&t=WeXeeUrSMWJYXvo3-1)

Варианты: 8 всего; 4 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| Aon ⚠️#63327:5 | BOOLEAN | false | [] |
| Aon ✅#63304:0 | BOOLEAN | false | [] |
| Aon ❌#63327:0 | BOOLEAN | false | [] |
| Crimea#63327:20 | BOOLEAN | false | [] |
| Protect#63341:55 | BOOLEAN | false | [] |
| Record#63341:50 | BOOLEAN | false | [] |
| Roaming#63327:25 | BOOLEAN | false | [] |
| Secretary#63341:45 | BOOLEAN | false | [] |
| Virtual#63341:60 | BOOLEAN | false | [] |
| description#41541:55 | TEXT | "Description" | [] |
| show-avatar#41541:38 | BOOLEAN | true | [] |
| show-description#41541:10 | BOOLEAN | true | [] |
| show-notification#44290:0 | BOOLEAN | false | [] |
| skeleton | VARIANT | "off" | ["on", "off"] |
| status | VARIANT | "Income" | ["Income", "Missed", "Outcome"] |
| system | VARIANT | "iOS" | ["iOS", "Android"] |
| title#41541:45 | TEXT | "Title" | [] |
| value#42565:0 | TEXT | "Value" | [] |
| value-description#42565:17 | TEXT | "Description" | [] |

Свойства состояний из импортированной матрицы: skeleton

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/Body L | Font(family: "Roboto", style: Regular, size: 16, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/Body M | Font(family: "Roboto", style: Regular, size: 14, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/UI S | Font(family: "Roboto", style: Regular, size: 13, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Background/Base | #ffffff |
| Background/Elevation 1 | #ffffff |
| Feed/Category Neutral | #90adbf |
| Feed/Category Neutral Pale | #e5ecf4 |
| Service/Skeleton | #00000008 |
| Text/Negative | #f52222 |
| Text/Primary | #333333 |
| Text/Secondary | #9299a2 |
| bg blur | Effect(type: BACKGROUND_BLUR, radius: 10) |
| iOS/Body L | Font(family: "SF Pro Text", style: Regular, size: 17, weight: 400, lineHeight: 100, letterSpacing: -0.4099999964237213) |
| iOS/UI S | Font(family: "SF Pro Text", style: Regular, size: 13, weight: 400, lineHeight: 100, letterSpacing: -0.07999999821186066) |
| min-height | 80 |
| text-padding | 20 |

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

## tui-cell [operation] · 44290:314128

Назначение из описания Figma: Ячейка операции.

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=44290-314128). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-cell-operation-specs) → [разрешённая ссылка Figma](https://www.figma.com/file/N6hjLbUDTjT7XSNuyaKf64/TUI-Mobile.-Demo-%26-Guides?type=design&node-id=12613-255589&mode=design&t=uYZhF22PtSqdLjH6-0)

Варианты: 10 всего; 5 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| caption#41541:65 | TEXT | "Caption" | [] |
| description#41541:55 | TEXT | "Description" | [] |
| extended | VARIANT | "off" | ["off", "on"] |
| fixed-height | VARIANT | "off" | ["off", "on"] |
| incoming-message#44290:10 | BOOLEAN | true | [] |
| outgoing-message#44290:5 | BOOLEAN | true | [] |
| show-avatar#41541:38 | BOOLEAN | true | [] |
| show-badge#44290:20 | BOOLEAN | true | [] |
| show-caption#41541:0 | BOOLEAN | false | [] |
| show-checkbox#44290:30 | BOOLEAN | false | [] |
| show-comment#44290:15 | BOOLEAN | true | [] |
| show-description#41541:10 | BOOLEAN | true | [] |
| show-notification#44290:0 | BOOLEAN | false | [] |
| skeleton | VARIANT | "off" | ["off", "on"] |
| system | VARIANT | "iOS" | ["iOS", "Android"] |
| title#41541:45 | TEXT | "Title" | [] |
| value#42565:0 | TEXT | "Value" | [] |
| value-description#42565:17 | TEXT | "Description" | [] |

Свойства состояний из импортированной матрицы: skeleton

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/Body L | Font(family: "Roboto", style: Regular, size: 16, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/UI S | Font(family: "Roboto", style: Regular, size: 13, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/UI S Bold | Font(family: "Roboto", style: Medium, size: 13, weight: 500, lineHeight: 100, letterSpacing: 0) |
| Background/Accent 1 | #ffdd2d |
| Background/Accent 2 | #428bf9 |
| Background/Neutral 1 | #00102408 |
| Gradient/Text/Primary Fade |  |
| Gradient/Text/Secondary Fade |  |
| Hide from publishing/Gradient/Text/Primary Fade Point 1 | #333333 |
| Hide from publishing/Gradient/Text/Primary Fade Point 2 | #33333300 |
| Hide from publishing/Gradient/Text/Secondary Fade Point 1 | #9299a2 |
| Hide from publishing/Gradient/Text/Secondary Fade Point 2 | #9299a200 |
| Screen Padding | 16 |
| Service/Skeleton | #00000008 |
| Text/Primary | #333333 |
| Text/Primary On Dark | #ffffff |
| Text/Secondary | #9299a2 |
| iOS/Body L | Font(family: "SF Pro Text", style: Regular, size: 17, weight: 400, lineHeight: 100, letterSpacing: -0.4099999964237213) |
| iOS/UI S | Font(family: "SF Pro Text", style: Regular, size: 13, weight: 400, lineHeight: 100, letterSpacing: -0.07999999821186066) |
| iOS/UI S Bold | Font(family: "SF Pro Text", style: Semibold, size: 13, weight: 600, lineHeight: 100, letterSpacing: -0.07999999821186066) |
| min-height | 80 |
| text-padding | 20 |

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

## tui-cell [switch] · 41569:291397

Назначение из описания Figma: Ячейка с тогглом

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=41569-291397). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-cell-specs) → [разрешённая ссылка Figma](https://www.figma.com/design/E5smFo7uxLRjWx7Ov2e3zt/tui-cell?node-id=17-2105&t=WeXeeUrSMWJYXvo3-1)

Варианты: 18 всего; 9 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| accessories | VARIANT | "off" | ["off", "on"] |
| caption#41541:65 | TEXT | "Caption" | [] |
| description#41541:55 | TEXT | "Description" | [] |
| fixed-height | VARIANT | "on" | ["off", "on"] |
| selected | VARIANT | "off" | ["off", "on"] |
| show-avatar#41541:38 | BOOLEAN | true | [] |
| show-badge#41569:0 | BOOLEAN | true | [] |
| show-caption#41541:0 | BOOLEAN | false | [] |
| show-description#41541:10 | BOOLEAN | true | [] |
| show-hint#41569:9 | BOOLEAN | true | [] |
| skeleton | VARIANT | "off" | ["on", "off"] |
| system | VARIANT | "iOS" | ["iOS", "Android"] |
| title#41541:45 | TEXT | "Title" | [] |

Свойства состояний из импортированной матрицы: selected, skeleton

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
| Background/Neutral 3 | #0010241f |
| Component/Badge Notification | #f52222 |
| Gradient/Text/Primary Fade |  |
| Gradient/Text/Secondary Fade |  |
| Hide from publishing/Gradient/Text/Primary Fade Point 1 | #333333 |
| Hide from publishing/Gradient/Text/Primary Fade Point 2 | #33333300 |
| Hide from publishing/Gradient/Text/Secondary Fade Point 1 | #9299a2 |
| Hide from publishing/Gradient/Text/Secondary Fade Point 2 | #9299a200 |
| Service/Skeleton | #00000008 |
| Text/Primary | #333333 |
| Text/Primary On Dark | #ffffff |
| Text/Secondary | #9299a2 |
| accessory-min-height | 40 |
| iOS/Body L | Font(family: "SF Pro Text", style: Regular, size: 17, weight: 400, lineHeight: 100, letterSpacing: -0.4099999964237213) |
| iOS/Body M | Font(family: "SF Pro Text", style: Regular, size: 15, weight: 400, lineHeight: 100, letterSpacing: -0.23999999463558197) |
| iOS/UI S | Font(family: "SF Pro Text", style: Regular, size: 13, weight: 400, lineHeight: 100, letterSpacing: -0.07999999821186066) |
| min-height | 56 |
| padding | 16 |
| text-padding | 8 |

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

