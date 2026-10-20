# Controls

Это индекс сохранённых источников и текущей приёмки. Он не добавляет новых требований Figma.

Публикация через MCP: UNVERIFIED. Полные ID вариантов и определения свойств: [inventory.json](../inventory.json).

## tui-chip · 42638:295990

Назначение из описания Figma: Отдельный чипс. Используется как элемент выбора, элемент фильтра или как элемент вывода информации   Keywords: chip, chips, tag, чип, тэг, чипсы

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=42638-295990). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-chips-specs) → [разрешённая ссылка Figma](https://www.figma.com/file/Dn9obiJAxL4juOqCYj6tEb/tui-chips?type=design&node-id=1-2800&mode=design&t=09IFjBUvwnptAm4P-0)

Варианты: 118 всего; 60 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| appearance | VARIANT | "neutral" | ["accent", "floating", "neutral"] |
| is-disable | VARIANT | "off" | ["off", "on"] |
| left content | VARIANT | "none" | ["icon", "image", "none"] |
| right content | VARIANT | "none" | ["close", "dropdown", "none"] |
| show badge#20703:119 | BOOLEAN | false | [] |
| size | VARIANT | "small" | ["medium", "small"] |
| skeleton | VARIANT | "off" | ["off", "on"] |
| system | VARIANT | "ios" | ["ios", "android"] |

Свойства состояний из импортированной матрицы: skeleton, is-disable

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/UI S Bold | Font(family: "Roboto", style: Medium, size: 13, weight: 500, lineHeight: 100, letterSpacing: 0) |
| Background/Accent 2 | #428bf9 |
| Background/Elevation 1 | #ffffff |
| Background/Neutral 1 | #00102408 |
| Hide from publishing/Shadow/Small/Blur | 20 |
| Hide from publishing/Shadow/Small/Color | #0000001a |
| Hide from publishing/Shadow/Small/Y-axis | 5 |
| Service/Skeleton | #00000008 |
| Shadow/Small | Effect(type: DROP_SHADOW, color: Hide from publishing/Shadow/Small/Color, offset: (0, Hide from publishing/Shadow/Small/Y-axis), radius: Hide from publishing/Shadow/Small/Blur, spread: 0) |
| Text/Primary | #333333 |
| Text/Primary On Dark | #ffffff |
| Text/Tertiary | #00102438 |
| iOS/UI S Bold | Font(family: "SF Pro Text", style: Semibold, size: 13, weight: 600, lineHeight: 100, letterSpacing: -0.07999999821186066) |

Текущий публичный API: `TUIChip`, [реализация](../../Sources/TUIDesignSystem/Components/Chip/TUIChip.swift).
Зависимости, наблюдаемые в Swift-коде (не подтверждённый граф Figma): TUIChipAppearance, TUIChipLeadingContent, TUIChipSize, TUIChipTrailingContent, TUIColor, TUIShadow, TUITheme.

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
- Полная матрица 60 вариантов; спецификация поведения, темы, состояния и типографика.

## tui-chip-group · 115603:32334

Назначение из описания Figma: Вывод чипсов списком. Кликабельные и некликабельные

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=115603-32334). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-chip-group-specs) → [разрешённая ссылка Figma](https://www.figma.com/design/nlKukod1Agx5JuLMWM8aej/tui-chip-group?node-id=0-1&t=TJjpSDHiO3wRpbvZ-1)

Варианты: 8 всего; 4 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| Scrollable | VARIANT | "on" | ["on", "off"] |
| Size | VARIANT | "S" | ["S", "M"] |
| System | VARIANT | "iOS" | ["iOS", "Android"] |
| slot#115603:0 | SLOT | null | [{"type": "COMPONENT_SET", "key": "6bcfbfa4a317f66d3eabb45597bfd55fc5638e34"}] |

Свойства состояний из импортированной матрицы: UNVERIFIED: отдельные свойства состояний не импортированы.

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/UI S Bold | Font(family: "Roboto", style: Medium, size: 13, weight: 500, lineHeight: 100, letterSpacing: 0) |
| Background/Neutral 1 | #00102408 |
| Screen Padding | 16 |
| Text/Primary | #333333 |
| iOS/UI S Bold | Font(family: "SF Pro Text", style: Semibold, size: 13, weight: 600, lineHeight: 100, letterSpacing: -0.07999999821186066) |

Текущий публичный API: `TUIChipGroup`, [реализация](../../Sources/TUIDesignSystem/Components/Chip/TUIChipGroup.swift).
Зависимости, наблюдаемые в Swift-коде (не подтверждённый граф Figma): TUIChipFlowLayout, TUIChipGroupAlignment, TUIChipSize, TUISpacing.

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
- Четыре варианта при точной ширине 375; перенос, прокрутка, темы.

## tui-chip-group [choice] · 44286:300575

Назначение из описания Figma: Единичный выбор чипсов

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=44286-300575). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-chip-group-specs) → [разрешённая ссылка Figma](https://www.figma.com/design/nlKukod1Agx5JuLMWM8aej/tui-chip-group?node-id=0-1&t=TJjpSDHiO3wRpbvZ-1)

Варианты: 12 всего; 6 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| Alignment | VARIANT | "Start" | ["Start", "Center"] |
| Scrollable | VARIANT | "on" | ["on", "off"] |
| Size | VARIANT | "S" | ["S", "M"] |
| System | VARIANT | "iOS" | ["iOS", "Android"] |

Свойства состояний из импортированной матрицы: UNVERIFIED: отдельные свойства состояний не импортированы.

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/UI S Bold | Font(family: "Roboto", style: Medium, size: 13, weight: 500, lineHeight: 100, letterSpacing: 0) |
| Background/Accent 2 | #428bf9 |
| Background/Neutral 1 | #00102408 |
| Screen Padding | 16 |
| Text/Primary | #333333 |
| Text/Primary On Dark | #ffffff |
| iOS/UI S Bold | Font(family: "SF Pro Text", style: Semibold, size: 13, weight: 600, lineHeight: 100, letterSpacing: -0.07999999821186066) |

Текущий публичный API: `TUIChipGroup`, [реализация](../../Sources/TUIDesignSystem/Components/Chip/TUIChipGroup.swift).
Зависимости, наблюдаемые в Swift-коде (не подтверждённый граф Figma): TUIChipFlowLayout, TUIChipGroupAlignment, TUIChipSize, TUISpacing.

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
- Шесть вариантов choice; выбор, раскладка, темы и доступность.

## tui-chip-group [filter] · 44286:300668

Назначение из описания Figma: Фильтр с удаляемыми чипсами

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=44286-300668). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-chips-specs) → [разрешённая ссылка Figma](https://www.figma.com/file/Dn9obiJAxL4juOqCYj6tEb/tui-chips?type=design&node-id=1-2800&mode=design&t=09IFjBUvwnptAm4P-0)

Варианты: 12 всего; 6 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| Alignment | VARIANT | "Start" | ["Start", "Center"] |
| Scrollable | VARIANT | "on" | ["on", "off"] |
| Size | VARIANT | "S" | ["S", "M"] |
| System | VARIANT | "iOS" | ["iOS", "Android"] |

Свойства состояний из импортированной матрицы: UNVERIFIED: отдельные свойства состояний не импортированы.

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/UI S Bold | Font(family: "Roboto", style: Medium, size: 13, weight: 500, lineHeight: 100, letterSpacing: 0) |
| Background/Accent 2 | #428bf9 |
| Screen Padding | 16 |
| Text/Primary On Dark | #ffffff |
| iOS/UI S Bold | Font(family: "SF Pro Text", style: Semibold, size: 13, weight: 600, lineHeight: 100, letterSpacing: -0.07999999821186066) |

Текущий публичный API: `TUIChipGroup`, [реализация](../../Sources/TUIDesignSystem/Components/Chip/TUIChipGroup.swift).
Зависимости, наблюдаемые в Swift-коде (не подтверждённый граф Figma): TUIChipFlowLayout, TUIChipGroupAlignment, TUIChipSize, TUISpacing.

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
- Шесть вариантов filter; снятие фильтра, раскладка, темы и доступность.

## tui-chip-group [list] · 44286:300482

Назначение из описания Figma: Вывод чипсов списком. Кликабельные и некликабельные

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=44286-300482). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-chip-group-specs) → [разрешённая ссылка Figma](https://www.figma.com/design/nlKukod1Agx5JuLMWM8aej/tui-chip-group?node-id=0-1&t=TJjpSDHiO3wRpbvZ-1)

Варианты: 12 всего; 6 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| Alignment | VARIANT | "Start" | ["Start", "Center"] |
| Scrollable | VARIANT | "on" | ["on", "off"] |
| Size | VARIANT | "S" | ["S", "M"] |
| System | VARIANT | "iOS" | ["iOS", "Android"] |

Свойства состояний из импортированной матрицы: UNVERIFIED: отдельные свойства состояний не импортированы.

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/UI S Bold | Font(family: "Roboto", style: Medium, size: 13, weight: 500, lineHeight: 100, letterSpacing: 0) |
| Background/Neutral 1 | #00102408 |
| Screen Padding | 16 |
| Text/Primary | #333333 |
| iOS/UI S Bold | Font(family: "SF Pro Text", style: Semibold, size: 13, weight: 600, lineHeight: 100, letterSpacing: -0.07999999821186066) |

Текущий публичный API: `TUIChipGroup`, [реализация](../../Sources/TUIDesignSystem/Components/Chip/TUIChipGroup.swift).
Зависимости, наблюдаемые в Swift-коде (не подтверждённый граф Figma): TUIChipFlowLayout, TUIChipGroupAlignment, TUIChipSize, TUISpacing.

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
- Шесть вариантов list; действия, раскладка, темы и доступность.

## tui-counter · 16661:51922

Назначение из описания Figma: UNVERIFIED: описание в импорте отсутствует.

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=16661-51922). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-counter-specs) → [разрешённая ссылка Figma](https://www.figma.com/design/eoVbiSMrWULegIcqUA12OE/tui-counter)

Варианты: 18 всего; 9 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| Preset | VARIANT | "Primary" | ["Primary", "Secondary", "Secondary Separated"] |
| Size | VARIANT | "large" | ["large", "medium", "small"] |
| System | VARIANT | "iOS" | ["iOS", "Android"] |

Свойства состояний из импортированной матрицы: UNVERIFIED: отдельные свойства состояний не импортированы.

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/Heading M | Font(family: "Roboto", style: Bold, size: 20, weight: 700, lineHeight: 100, letterSpacing: 0) |
| Android/Heading S | Font(family: "Roboto", style: Medium, size: 16, weight: 500, lineHeight: 100, letterSpacing: 0) |
| Android/UI S Bold | Font(family: "Roboto", style: Medium, size: 13, weight: 500, lineHeight: 100, letterSpacing: 0) |
| Background/Accent 1 | #ffdd2d |
| Background/Neutral 1 | #00102408 |
| Text/Action | #428bf9 |
| Text/Primary | #333333 |
| Text/Primary On T-Bank | #333333 |
| iOS/Heading M | Font(family: "SF Pro Display", style: Bold, size: 20, weight: 600, lineHeight: 100, letterSpacing: 0.3799999952316284) |
| iOS/Heading S | Font(family: "SF Pro Text", style: Semibold, size: 17, weight: 600, lineHeight: 100, letterSpacing: -0.4099999964237213) |
| iOS/UI S Bold | Font(family: "SF Pro Text", style: Semibold, size: 13, weight: 600, lineHeight: 100, letterSpacing: -0.07999999821186066) |

Текущий публичный API: `TUICounter`, [реализация](../../Sources/TUIDesignSystem/Components/Counter/TUICounter.swift).
Зависимости, наблюдаемые в Swift-коде (не подтверждённый граф Figma): TUIColor, TUIRadius, TUITypographyRole.

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

## tui-pager · 34357:426019

Назначение из описания Figma: Индикатор постраничной навигации

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=34357-426019). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-pager-specs) → [разрешённая ссылка Figma](https://www.figma.com/design/Gkt5uTUWBk0spEoU7EAT5j/tui-pager?node-id=124-1455&t=N2wbU5DZRWhbFAip-11)

Варианты: 20 всего; 10 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| pages | VARIANT | "2" | ["2", "3", "4", "5", "6+"] |
| size | VARIANT | "small" | ["small", "medium"] |
| system | VARIANT | "iOS" | ["iOS", "Android"] |

Свойства состояний из импортированной матрицы: UNVERIFIED: отдельные свойства состояний не импортированы.

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Background/Neutral 3 | #0010241f |
| Text/Action | #428bf9 |

Текущий публичный API: `TUIPager`, [реализация](../../Sources/TUIDesignSystem/Components/Pager/TUIPager.swift).
Зависимости, наблюдаемые в Swift-коде (не подтверждённый граф Figma): TUIColor, TUIPagerWindow, TUISpacing.

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
- Спецификация дополнительных схем и анимации, реальный swipe, AX; базовая матрица сохранена.

## tui-rating · 10467:91596

Назначение из описания Figma: Универсальный компонент для оценки

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=10467-91596). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-rating) → [разрешённая ссылка Figma](https://www.figma.com/design/GML4f7dIhrCjPoxf7gzF7e/tui-rating?node-id=1-2461&t=MYCTlduhaqyrgIyu-1)

Варианты: 6 всего; 6 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| Instance#32:0 | INSTANCE_SWAP | "41881:45334" | [] |
| quantity | VARIANT | "0" | ["0", "1", "2", "3", "4", "5"] |

Свойства состояний из импортированной матрицы: UNVERIFIED: отдельные свойства состояний не импортированы.

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Background/Neutral 4 | #00102438 |
| Brand/T-Bank | #ffdd2d |

Текущий публичный API: `TUIRating`, [реализация](../../Sources/TUIDesignSystem/Components/Rating/TUIRating.swift).
Зависимости, наблюдаемые в Swift-коде (не подтверждённый граф Figma): TUIColor, TUIMotionCurve, TUIMotionDuration.

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

## tui-segmented · 16874:41486

Назначение из описания Figma: UNVERIFIED: описание в импорте отсутствует.

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=16874-41486). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-segmented) → [разрешённая ссылка Figma](https://www.figma.com/design/mkmOd2iW7CUFixpEX3Yju7/tui-segmented?node-id=56-3148&t=5IUlgqS5RBsgs78n-1)

Варианты: 24 всего; 12 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| auto-fit | VARIANT | "True" | ["True", "False"] |
| shape | VARIANT | "square" | ["square", "rounded"] |
| size | VARIANT | "small" | ["small", "medium", "large"] |
| system | VARIANT | "ios" | ["ios", "android"] |

Свойства состояний из импортированной матрицы: UNVERIFIED: отдельные свойства состояний не импортированы.

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/Body L | Font(family: "Roboto", style: Regular, size: 16, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/Body M | Font(family: "Roboto", style: Regular, size: 14, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/Body S | Font(family: "Roboto", style: Regular, size: 13, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Background/Elevation 3 | #ffffff |
| Background/Neutral 1 | #00102408 |
| Hide from publishing/Shadow/Small/Blur | 20 |
| Hide from publishing/Shadow/Small/Color | #0000001a |
| Hide from publishing/Shadow/Small/Y-axis | 5 |
| Shadow/Small | Effect(type: DROP_SHADOW, color: Hide from publishing/Shadow/Small/Color, offset: (0, Hide from publishing/Shadow/Small/Y-axis), radius: Hide from publishing/Shadow/Small/Blur, spread: 0) |
| Text/Primary | #333333 |
| iOS/Body L | Font(family: "SF Pro Text", style: Regular, size: 17, weight: 400, lineHeight: 100, letterSpacing: -0.4099999964237213) |
| iOS/Body M | Font(family: "SF Pro Text", style: Regular, size: 15, weight: 400, lineHeight: 100, letterSpacing: -0.23999999463558197) |
| iOS/Body S | Font(family: "SF Pro Text", style: Regular, size: 13, weight: 400, lineHeight: 100, letterSpacing: -0.07999999821186066) |

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

## tui-swipe-actions · 53204:296101

Назначение из описания Figma: Компонент-обертка для добавления доп.действий при свайпе. Подходит для карточек и ячеек

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=53204-296101). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-swipe-actions) → [разрешённая ссылка Figma](https://www.figma.com/design/W1VUOFHYFbutZXVL3tdl0V/tui-swipe-actions?node-id=8015-8374&t=LIAVFlPreoOnAhtx-1)

Варианты: 4 всего; 2 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| Action #1#53204:0 | BOOLEAN | true | [] |
| Action #2#53204:2 | BOOLEAN | true | [] |
| Action #3#53204:4 | BOOLEAN | false | [] |
| Contents | VARIANT | "Cell" | ["Cell", "Card"] |
| Expanded#53204:6 | BOOLEAN | true | [] |
| System | VARIANT | "iOS" | ["iOS", "Android"] |

Свойства состояний из импортированной матрицы: UNVERIFIED: отдельные свойства состояний не импортированы.

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/Body L | Font(family: "Roboto", style: Regular, size: 16, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/Body M | Font(family: "Roboto", style: Regular, size: 14, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/Heading S Bold | Font(family: "Roboto", style: Bold, size: 16, weight: 700, lineHeight: 100, letterSpacing: 0) |
| Android/UI S | Font(family: "Roboto", style: Regular, size: 13, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/UI XXS Bold | Font(family: "Roboto", style: Bold, size: 11, weight: 700, lineHeight: 100, letterSpacing: 0) |
| Background/Accent 2 | #428bf9 |
| Background/Elevation 1 | #ffffff |
| Background/Neutral 4 | #00102438 |
| Gradient/Text/Primary Fade |  |
| Hide from publishing/Gradient/Text/Primary Fade Point 1 | #333333 |
| Hide from publishing/Gradient/Text/Primary Fade Point 2 | #33333300 |
| Hide from publishing/Shadow/Medium/Blur | 34 |
| Hide from publishing/Shadow/Medium/Color | #0000001f |
| Hide from publishing/Shadow/Medium/Y-axis | 6 |
| Screen Padding | 16 |
| Shadow/Medium | Effect(type: DROP_SHADOW, color: Hide from publishing/Shadow/Medium/Color, offset: (0, Hide from publishing/Shadow/Medium/Y-axis), radius: Hide from publishing/Shadow/Medium/Blur, spread: 0) |
| Text/Primary | #333333 |
| Text/Primary On Dark | #ffffff |
| Text/Secondary | #9299a2 |
| accessory-padding | 8 |
| bg blur | Effect(type: BACKGROUND_BLUR, radius: 10) |
| iOS/Body L | Font(family: "SF Pro Text", style: Regular, size: 17, weight: 400, lineHeight: 100, letterSpacing: -0.4099999964237213) |
| iOS/Body M | Font(family: "SF Pro Text", style: Regular, size: 15, weight: 400, lineHeight: 100, letterSpacing: -0.23999999463558197) |
| iOS/Heading S Bold | Font(family: "SF Pro Text", style: Bold, size: 17, weight: 600, lineHeight: 100, letterSpacing: -0.4099999964237213) |
| iOS/UI S | Font(family: "SF Pro Text", style: Regular, size: 13, weight: 400, lineHeight: 100, letterSpacing: -0.07999999821186066) |
| iOS/UI XXS Bold | Font(family: "SF Pro Text", style: Bold, size: 11, weight: 700, lineHeight: 100, letterSpacing: -0.10000000149011612) |
| min-height | 56 |
| padding | 16 |
| radius | 24 |
| text-padding | 8 |

Текущий публичный API: `TUISwipeActions`, [реализация](../../Sources/TUIDesignSystem/Components/SwipeActions/TUISwipeActions.swift).
Зависимости, наблюдаемые в Swift-коде (не подтверждённый граф Figma): TUIColor, TUISwipeAction, TUISwipeContents.

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
- Оба варианта Cell/Card, реальный жест, действия и геометрия на симуляторе.

