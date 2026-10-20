# Navigation

Это индекс сохранённых источников и текущей приёмки. Он не добавляет новых требований Figma.

Публикация через MCP: UNVERIFIED. Полные ID вариантов и определения свойств: [inventory.json](../inventory.json).

## tui-app-bar · 25752:487144

Назначение из описания Figma: Навигационный блок для верхней части экрана  tui-appbar, navbar

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=25752-487144). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-appbar-specs) → [разрешённая ссылка Figma](https://www.figma.com/design/hiSQkVgQ7rBSdPuzjywApt/tui-appbar)

Варианты: 74 всего; 24 применимых iOS 26; 25 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| action-right#63750:64 | TEXT | "Action" | [] |
| left | VARIANT | "Back" | ["Back", "Close", "None"] |
| middle | VARIANT | "Title" | ["Title", "Progress", "None"] |
| right | VARIANT | "None" | ["Icon", "Text", "None"] |
| show-end-button#90258:107 | BOOLEAN | true | [] |
| show-start-button#90258:51 | BOOLEAN | true | [] |
| show-subtitle#47923:0 | BOOLEAN | false | [] |
| show-top-indent#90258:219 | BOOLEAN | false | [] |
| subtitle#90258:163 | TEXT | "Subtitle" | [] |
| system | VARIANT | "iOS 18" | ["Android", "iOS 18", "iOS 26"] |
| title#63750:0 | TEXT | "Title" | [] |

Свойства состояний из импортированной матрицы: UNVERIFIED: отдельные свойства состояний не импортированы.

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android System/Appbar | Font(family: "Roboto", style: Medium, size: 20, weight: 500, lineHeight: 100, letterSpacing: 0) |
| Android/Body L | Font(family: "Roboto", style: Regular, size: 16, weight: 400, lineHeight: 100, letterSpacing: 0) |
| App-bar button padding | 12 |
| Background/Accent 2 | #428bf9 |
| Background/Neutral 2 | #0010240f |
| Component/Progress Bar | #0010240f |
| Screen Padding | 16 |
| State/Background/Neutral 1 Pressed | #0010240f |
| Text/Action | #428bf9 |
| Text/Primary | #333333 |
| height | 44 |
| iOS/Body L | Font(family: "SF Pro Text", style: Regular, size: 17, weight: 400, lineHeight: 100, letterSpacing: -0.4099999964237213) |
| iOS/Heading S | Font(family: "SF Pro Text", style: Semibold, size: 17, weight: 600, lineHeight: 100, letterSpacing: -0.4099999964237213) |

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

## tui-header · 42565:304670

Назначение из описания Figma: Заголовок для группы контента или шторки

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=42565-304670). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-header-specs) → [разрешённая ссылка Figma](https://www.figma.com/design/Vt4htBIFAjKUg8c547G0Ez/tui-header?node-id=1-2&t=piPmlEpFuc3QqAOn-1)

Варианты: 30 всего; 15 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| Accessories | VARIANT | "off" | ["on", "off"] |
| Badge#41997:19 | BOOLEAN | true | [] |
| Description | VARIANT | "off" | ["off", "on"] |
| DescriptionText#42565:86 | TEXT | "Description" | [] |
| HeaderText#42565:68 | TEXT | "Header" | [] |
| Hint#41997:12 | BOOLEAN | true | [] |
| Size | VARIANT | "Medium" | ["Medium", "Small"] |
| Subheader#42565:95 | BOOLEAN | false | [] |
| SubheaderText#42565:77 | TEXT | "Subheader" | [] |
| System | VARIANT | "iOS" | ["iOS", "Android"] |
| TextAlign | VARIANT | "start" | ["start", "center"] |
| skeleton | VARIANT | "off" | ["off", "on"] |

Свойства состояний из импортированной матрицы: skeleton

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/Body L | Font(family: "Roboto", style: Regular, size: 16, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/Body M | Font(family: "Roboto", style: Regular, size: 14, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/Heading M | Font(family: "Roboto", style: Bold, size: 20, weight: 700, lineHeight: 100, letterSpacing: 0) |
| Android/Heading S | Font(family: "Roboto", style: Medium, size: 16, weight: 500, lineHeight: 100, letterSpacing: 0) |
| Background/Neutral 1 | #00102408 |
| Component/Badge Notification | #f52222 |
| Screen Padding | 16 |
| Service/Skeleton | #00000008 |
| Text/Primary | #333333 |
| Text/Primary On Dark | #ffffff |
| Text/Secondary | #9299a2 |
| iOS/Body L | Font(family: "SF Pro Text", style: Regular, size: 17, weight: 400, lineHeight: 100, letterSpacing: -0.4099999964237213) |
| iOS/Body M | Font(family: "SF Pro Text", style: Regular, size: 15, weight: 400, lineHeight: 100, letterSpacing: -0.23999999463558197) |
| iOS/Heading M | Font(family: "SF Pro Display", style: Bold, size: 20, weight: 600, lineHeight: 100, letterSpacing: 0.3799999952316284) |
| iOS/Heading S | Font(family: "SF Pro Text", style: Semibold, size: 17, weight: 600, lineHeight: 100, letterSpacing: -0.4099999964237213) |

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

## tui-header [action] · 41997:290341

Назначение из описания Figma: Заголовок для группы контента или шторки

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=41997-290341). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-header-specs) → [разрешённая ссылка Figma](https://www.figma.com/design/Vt4htBIFAjKUg8c547G0Ez/tui-header?node-id=1-2&t=piPmlEpFuc3QqAOn-1)

Варианты: 18 всего; 9 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| Accessories | VARIANT | "off" | ["on", "off"] |
| Badge#41997:19 | BOOLEAN | true | [] |
| Description | VARIANT | "off" | ["off", "on"] |
| DescriptionText#42565:86 | TEXT | "Description" | [] |
| HeaderText#42565:68 | TEXT | "Header" | [] |
| Hint#41997:12 | BOOLEAN | true | [] |
| Size | VARIANT | "Medium" | ["Medium", "Small"] |
| Subheader#42565:95 | BOOLEAN | false | [] |
| SubheaderText#42565:77 | TEXT | "Subheader" | [] |
| System | VARIANT | "iOS" | ["iOS", "Android"] |
| skeleton | VARIANT | "off" | ["off", "on"] |

Свойства состояний из импортированной матрицы: skeleton

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/Body L | Font(family: "Roboto", style: Regular, size: 16, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/Body M | Font(family: "Roboto", style: Regular, size: 14, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/Heading M | Font(family: "Roboto", style: Bold, size: 20, weight: 700, lineHeight: 100, letterSpacing: 0) |
| Android/Heading S | Font(family: "Roboto", style: Medium, size: 16, weight: 500, lineHeight: 100, letterSpacing: 0) |
| Android/UI M Bold | Font(family: "Roboto", style: Medium, size: 14, weight: 500, lineHeight: 100, letterSpacing: 0) |
| Background/Neutral 1 | #00102408 |
| Component/Badge Notification | #f52222 |
| Screen Padding | 16 |
| Service/Skeleton | #00000008 |
| Text/Action | #428bf9 |
| Text/Primary | #333333 |
| Text/Primary On Dark | #ffffff |
| Text/Secondary | #9299a2 |
| iOS/Body L | Font(family: "SF Pro Text", style: Regular, size: 17, weight: 400, lineHeight: 100, letterSpacing: -0.4099999964237213) |
| iOS/Body M | Font(family: "SF Pro Text", style: Regular, size: 15, weight: 400, lineHeight: 100, letterSpacing: -0.23999999463558197) |
| iOS/Heading M | Font(family: "SF Pro Display", style: Bold, size: 20, weight: 600, lineHeight: 100, letterSpacing: 0.3799999952316284) |
| iOS/Heading S | Font(family: "SF Pro Text", style: Semibold, size: 17, weight: 600, lineHeight: 100, letterSpacing: -0.4099999964237213) |

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

## tui-header [button] · 42565:304195

Назначение из описания Figma: Заголовок для группы контента или шторки

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=42565-304195). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-header-specs) → [разрешённая ссылка Figma](https://www.figma.com/design/Vt4htBIFAjKUg8c547G0Ez/tui-header?node-id=1-2&t=piPmlEpFuc3QqAOn-1)

Варианты: 18 всего; 9 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| Accessories | VARIANT | "off" | ["on", "off"] |
| Badge#41997:19 | BOOLEAN | true | [] |
| Description | VARIANT | "off" | ["off", "on"] |
| DescriptionText#42565:86 | TEXT | "Description" | [] |
| HeaderText#42565:68 | TEXT | "Header" | [] |
| Hint#41997:12 | BOOLEAN | true | [] |
| Size | VARIANT | "Medium" | ["Medium", "Small"] |
| Subheader#42565:95 | BOOLEAN | false | [] |
| SubheaderText#42565:77 | TEXT | "Subheader" | [] |
| System | VARIANT | "iOS" | ["iOS", "Android"] |
| skeleton | VARIANT | "off" | ["off", "on"] |

Свойства состояний из импортированной матрицы: skeleton

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/Body L | Font(family: "Roboto", style: Regular, size: 16, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/Body M | Font(family: "Roboto", style: Regular, size: 14, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/Heading M | Font(family: "Roboto", style: Bold, size: 20, weight: 700, lineHeight: 100, letterSpacing: 0) |
| Android/Heading S | Font(family: "Roboto", style: Medium, size: 16, weight: 500, lineHeight: 100, letterSpacing: 0) |
| Android/UI S Bold | Font(family: "Roboto", style: Medium, size: 13, weight: 500, lineHeight: 100, letterSpacing: 0) |
| Background/Accent 1 | #ffdd2d |
| Background/Neutral 1 | #00102408 |
| Component/Badge Notification | #f52222 |
| Screen Padding | 16 |
| Service/Skeleton | #00000008 |
| Text/Primary | #333333 |
| Text/Primary On Accent 1 | #333333 |
| Text/Primary On Dark | #ffffff |
| Text/Secondary | #9299a2 |
| iOS/Body L | Font(family: "SF Pro Text", style: Regular, size: 17, weight: 400, lineHeight: 100, letterSpacing: -0.4099999964237213) |
| iOS/Body M | Font(family: "SF Pro Text", style: Regular, size: 15, weight: 400, lineHeight: 100, letterSpacing: -0.23999999463558197) |
| iOS/Heading M | Font(family: "SF Pro Display", style: Bold, size: 20, weight: 600, lineHeight: 100, letterSpacing: 0.3799999952316284) |
| iOS/Heading S | Font(family: "SF Pro Text", style: Semibold, size: 17, weight: 600, lineHeight: 100, letterSpacing: -0.4099999964237213) |
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

## tui-header [card] · 44217:298609

Назначение из описания Figma: Заголовок для карточки

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=44217-298609). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-header-specs) → [разрешённая ссылка Figma](https://www.figma.com/design/Vt4htBIFAjKUg8c547G0Ez/tui-header?node-id=1-2&t=piPmlEpFuc3QqAOn-1)

Варианты: 18 всего; 9 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| Accessory | VARIANT | "Avatar" | ["Avatar", "Button", "Button Link", "Switch", "None"] |
| Badge#41997:19 | BOOLEAN | false | [] |
| Caption#59837:0 | BOOLEAN | true | [] |
| CaptionText#59837:15 | TEXT | "Caption" | [] |
| Description#56480:0 | BOOLEAN | false | [] |
| Extended | VARIANT | "Off" | ["Off", "On"] |
| HeaderText#42565:68 | TEXT | "Header" | [] |
| Hint#41997:12 | BOOLEAN | false | [] |
| Subheader#42565:95 | BOOLEAN | true | [] |
| SubheaderText#42565:77 | TEXT | "Subheader" | [] |
| System | VARIANT | "iOS" | ["Android", "iOS"] |
| skeleton | VARIANT | "off" | ["off", "on"] |

Свойства состояний из импортированной матрицы: skeleton

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/Body M | Font(family: "Roboto", style: Regular, size: 14, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/Heading M | Font(family: "Roboto", style: Bold, size: 20, weight: 700, lineHeight: 100, letterSpacing: 0) |
| Android/UI CAPS | Font(family: "Roboto", style: Medium, size: 13, weight: 500, lineHeight: 100, letterSpacing: 0) |
| Android/UI M Bold | Font(family: "Roboto", style: Medium, size: 14, weight: 500, lineHeight: 100, letterSpacing: 0) |
| Android/UI S Bold | Font(family: "Roboto", style: Medium, size: 13, weight: 500, lineHeight: 100, letterSpacing: 0) |
| Background/Accent 1 | #ffdd2d |
| Background/Accent 2 | #428bf9 |
| Background/Neutral 1 On Light | #00000008 |
| Background/Neutral 3 | #0010241f |
| Gradient/Text/Secondary Fade |  |
| Hide from publishing/Gradient/Text/Secondary Fade Point 1 | #9299a2 |
| Hide from publishing/Gradient/Text/Secondary Fade Point 2 | #9299a200 |
| Service/Skeleton | #00000008 |
| Text/Action | #428bf9 |
| Text/Primary | #333333 |
| Text/Primary On Accent 1 | #333333 |
| Text/Primary On Dark | #ffffff |
| Text/Secondary | #9299a2 |
| iOS/Body L | Font(family: "SF Pro Text", style: Regular, size: 17, weight: 400, lineHeight: 100, letterSpacing: -0.4099999964237213) |
| iOS/Body M | Font(family: "SF Pro Text", style: Regular, size: 15, weight: 400, lineHeight: 100, letterSpacing: -0.23999999463558197) |
| iOS/Heading M | Font(family: "SF Pro Display", style: Bold, size: 20, weight: 600, lineHeight: 100, letterSpacing: 0.3799999952316284) |
| iOS/UI CAPS | Font(family: "SF Pro Text", style: Medium, size: 13, weight: 500, lineHeight: 100, letterSpacing: 0) |
| iOS/UI S Bold | Font(family: "SF Pro Text", style: Semibold, size: 13, weight: 600, lineHeight: 100, letterSpacing: -0.07999999821186066) |
| padding | 20 |
| padding-compensated | 16 |
| padding-reduced | 12 |

Текущий публичный API: `TUIHeaderCard`, [реализация](../../Sources/TUIDesignSystem/Components/Header/TUIHeaderCard.swift).
Зависимости, наблюдаемые в Swift-коде (не подтверждённый граф Figma): TUIButton, TUIColor, TUIFigmaTextFont, TUIHeaderCardFontMetrics, TUIHeaderCardTextKind, TUIHeaderFontMetrics, TUIHeaderInlineLayout, TUIHeaderInlineRole, TUIHeaderLarge, TUIHeaderText, TUINotificationBadge, TUIOriginalSVGMask, TUISkeleton, TUISkeletonText, TUISpacing, TUISystemSwitch.

### Сохранённые материалы и результат проверки

- [Documentation/References/HeaderCard/implementation-review-2026-10-07.md](../../Documentation/References/HeaderCard/implementation-review-2026-10-07.md)
- [Documentation/References/HeaderCard/source-preparation-2026-10-07.json](../../Documentation/References/HeaderCard/source-preparation-2026-10-07.json)
- [Documentation/References/HeaderCard/source-preparation-2026-10-07.md](../../Documentation/References/HeaderCard/source-preparation-2026-10-07.md)

Реализация: IMPLEMENTED. Приёмка: **in-progress**.

- variantMapping: **passed**. All nine actual iOS IDs and exact four variant properties match the imported matrix and public enum. All eight instance content properties map to API; eight Caption/Subheader/Description combinations render with source container geometry. Required actions/Binding and all nine variants are exercised by compiled public examples and the independent consumer.
- specification: **pending**. Mobile sizes, Dynamic Type and VoiceOver read; public API implemented. Full audit and child specifications pending.
- visual: **pending**. Real SwiftUI renders and all source PNGs saved. No automatic acceptance: caption, small Button font, extended slots and iOS 26 native Switch differences remain documented. The Avatar title with hidden Subheader now centers inside 40 pt; all 16 default images are unchanged. Fresh Switch images come from the active native scene. System SF Pro chosen by user on 2026-10-20; bundled legacy font inputs retired to historicalInputHashes. Historical renders do not accept the new system face.
- interaction: **pending**. Catalog Button/Link/Switch and independent consumer actions, disabled Link/Switch and Hint additional action pass. Physical Hint target, custom slots, cancellation/loading and complete child-state specification remain pending.
- accessibility: **not-applicable**. Explicit user scope exclusion for interactive prototypes: no VoiceOver, accessibility font enlargement or extra accessibility modes. This is a delivery scope waiver, not evidence that Figma has no accessibility requirements or that these modes were tested. Original check retained in previousAccessibilityCheck.
- motion: **pending**. Единая повторная приёмка ещё не выполнена.
- integration: **pending**. Swift Package, standalone catalog and independent public-only consumer build. Previous 19 package tests and two native catalog UI tests are current; all 109 web examples compile. Nine variants, Button/Link handlers, writable Switch, disabled state, text-link actions and Hint sheet pass in the separate consumer. Five UI cases passed in the initial run; the failing probe was fixed, and its separate rerun passed. Full-system acceptance is not implied. After the source-centered-column fix, all six HeaderCard package tests and all six current UI scenarios pass together; 16 default Day/Night images are pixel-identical to the previous baseline. Current consumer build, original MCP results and logs are saved; the additional xcresult UI summary export was not executed. Current WebCatalogExamplesTests passes for 115 unique public SwiftUI examples, including six real Card Large header compositions; UIKit Switch remains verified in the active app.

Открытые вопросы:
- Caption uses the native Medium face; legacy face fidelity and font distribution decision remain open.
- Full specification, child states, accessibility actions and motion audit pending.
- Native iOS 26 Switch differs from the historical embedded Figma illustration.
- Extended consumer slots are omitted in default native previews; source editor placeholders are not application content.
- Small Button font advances differ from Figma; outer padding fixed, complete Button acceptance pending.
- Reverify native system SF Pro after explicit user decision 2026-10-20; legacy font binaries are no longer distributed. Historical visual evidence is not acceptance of the new face.

## tui-header [large] · 42565:305012

Назначение из описания Figma: Заголовок экрана

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=42565-305012). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-header-specs) → [разрешённая ссылка Figma](https://www.figma.com/design/Vt4htBIFAjKUg8c547G0Ez/tui-header?node-id=1-2&t=piPmlEpFuc3QqAOn-1)

Варианты: 20 всего; 10 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| descrption#42565:86 | TEXT | "Description" | [] |
| extended | VARIANT | "off" | ["off", "on"] |
| show-description | VARIANT | "off" | ["off", "on"] |
| show-icon#42579:0 | BOOLEAN | false | [] |
| show-subheader#42565:95 | BOOLEAN | true | [] |
| skeleton | VARIANT | "off" | ["off", "on"] |
| subheader#42565:77 | TEXT | "Subheader" | [] |
| system | VARIANT | "iOS" | ["iOS", "Android"] |
| text-align | VARIANT | "start" | ["start", "center"] |
| title#42565:68 | TEXT | "Header" | [] |

Свойства состояний из импортированной матрицы: skeleton

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/Body L | Font(family: "Roboto", style: Regular, size: 16, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/Body M | Font(family: "Roboto", style: Regular, size: 14, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/Heading L | Font(family: "Roboto", style: Bold, size: 28, weight: 700, lineHeight: 100, letterSpacing: 0) |
| Background/Neutral 1 On Light | #00000008 |
| Screen Padding | 16 |
| Service/Skeleton | #00000008 |
| Text/Primary | #333333 |
| Text/Secondary | #9299a2 |
| iOS/Body L | Font(family: "SF Pro Text", style: Regular, size: 17, weight: 400, lineHeight: 100, letterSpacing: -0.4099999964237213) |
| iOS/Body M | Font(family: "SF Pro Text", style: Regular, size: 15, weight: 400, lineHeight: 100, letterSpacing: -0.23999999463558197) |
| iOS/Heading L | Font(family: "SF Pro Display", style: Bold, size: 30, weight: 700, lineHeight: 100, letterSpacing: 0.36000001430511475) |

Текущий публичный API: `TUIHeaderLarge`, [реализация](../../Sources/TUIDesignSystem/Components/Header/TUIHeaderLarge.swift).
Зависимости, наблюдаемые в Swift-коде (не подтверждённый граф Figma): TUIColor, TUIFigmaTextFont, TUIHeaderFadeTextRenderer, TUIHeaderFirstLineCenter, TUIHeaderFontMetrics, TUIHeaderInlineItem, TUIHeaderInlineLayout, TUIHeaderInlineLinkAttribute, TUIHeaderInlineRole, TUIHeaderLinkHitMap, TUIHeaderLinkedTextAccessibility, TUIHeaderSingleLineIntrinsicLayout, TUIHeaderText, TUIHeaderTextLayout, TUIHeaderTextLink, TUISensitiveTextRenderer, TUISkeletonText, TUISpacing, TUITypographyRole.

### Сохранённые материалы и результат проверки

- [Documentation/References/HeaderLarge/continuous-fade-review-2026-10-06.md](../../Documentation/References/HeaderLarge/continuous-fade-review-2026-10-06.md)
- [Documentation/References/HeaderLarge/delivery-readiness-2026-10-06.md](../../Documentation/References/HeaderLarge/delivery-readiness-2026-10-06.md)
- [Documentation/References/HeaderLarge/final-acceptance-2026-10-06.md](../../Documentation/References/HeaderLarge/final-acceptance-2026-10-06.md)
- [Documentation/References/HeaderLarge/link-validation-stage-2026-10-06.md](../../Documentation/References/HeaderLarge/link-validation-stage-2026-10-06.md)
- [Documentation/References/HeaderLarge/spec-accessibility-2026-10-06.txt](../../Documentation/References/HeaderLarge/spec-accessibility-2026-10-06.txt)
- [Documentation/References/HeaderLarge/spec-accessory-content-0-2026-10-06.txt](../../Documentation/References/HeaderLarge/spec-accessory-content-0-2026-10-06.txt)
- [Documentation/References/HeaderLarge/spec-accessory-content-1-2026-10-06.txt](../../Documentation/References/HeaderLarge/spec-accessory-content-1-2026-10-06.txt)
- [Documentation/References/HeaderLarge/spec-accessory-content-2-2026-10-06.txt](../../Documentation/References/HeaderLarge/spec-accessory-content-2-2026-10-06.txt)
- [Documentation/References/HeaderLarge/spec-accessory-content-3-2026-10-06.txt](../../Documentation/References/HeaderLarge/spec-accessory-content-3-2026-10-06.txt)
- [Documentation/References/HeaderLarge/spec-accessory-content-4-2026-10-06.txt](../../Documentation/References/HeaderLarge/spec-accessory-content-4-2026-10-06.txt)
- [Documentation/References/HeaderLarge/spec-accessory-content-5-2026-10-06.txt](../../Documentation/References/HeaderLarge/spec-accessory-content-5-2026-10-06.txt)
- [Documentation/References/HeaderLarge/spec-accessory-content-6-2026-10-06.txt](../../Documentation/References/HeaderLarge/spec-accessory-content-6-2026-10-06.txt)
- [Documentation/References/HeaderLarge/spec-accessory-content-7-2026-10-06.txt](../../Documentation/References/HeaderLarge/spec-accessory-content-7-2026-10-06.txt)
- [Documentation/References/HeaderLarge/spec-accessory-content-8-2026-10-06.txt](../../Documentation/References/HeaderLarge/spec-accessory-content-8-2026-10-06.txt)
- [Documentation/References/HeaderLarge/spec-accessory-content-9-2026-10-06.txt](../../Documentation/References/HeaderLarge/spec-accessory-content-9-2026-10-06.txt)
- [Documentation/References/HeaderLarge/spec-api-2026-10-06.txt](../../Documentation/References/HeaderLarge/spec-api-2026-10-06.txt)
- [Documentation/References/HeaderLarge/spec-customization-0-2026-10-06.txt](../../Documentation/References/HeaderLarge/spec-customization-0-2026-10-06.txt)
- [Documentation/References/HeaderLarge/spec-customization-1-2026-10-06.txt](../../Documentation/References/HeaderLarge/spec-customization-1-2026-10-06.txt)
- [Documentation/References/HeaderLarge/spec-customization-2-2026-10-06.txt](../../Documentation/References/HeaderLarge/spec-customization-2-2026-10-06.txt)
- [Documentation/References/HeaderLarge/spec-customization-3-2026-10-06.txt](../../Documentation/References/HeaderLarge/spec-customization-3-2026-10-06.txt)
- [Documentation/References/HeaderLarge/spec-customization-4-2026-10-06.txt](../../Documentation/References/HeaderLarge/spec-customization-4-2026-10-06.txt)
- [Documentation/References/HeaderLarge/spec-customization-5-2026-10-06.txt](../../Documentation/References/HeaderLarge/spec-customization-5-2026-10-06.txt)
- [Documentation/References/HeaderLarge/spec-customization-6-2026-10-06.txt](../../Documentation/References/HeaderLarge/spec-customization-6-2026-10-06.txt)
- [Documentation/References/HeaderLarge/spec-customization-7-2026-10-06.txt](../../Documentation/References/HeaderLarge/spec-customization-7-2026-10-06.txt)
- [Documentation/References/HeaderLarge/spec-dynamic-type-2026-10-06.txt](../../Documentation/References/HeaderLarge/spec-dynamic-type-2026-10-06.txt)
- [Documentation/References/HeaderLarge/spec-fade-0-2026-10-06.txt](../../Documentation/References/HeaderLarge/spec-fade-0-2026-10-06.txt)
- [Documentation/References/HeaderLarge/spec-fade-1-2026-10-06.txt](../../Documentation/References/HeaderLarge/spec-fade-1-2026-10-06.txt)
- [Documentation/References/HeaderLarge/spec-fade-2-2026-10-06.txt](../../Documentation/References/HeaderLarge/spec-fade-2-2026-10-06.txt)
- [Documentation/References/HeaderLarge/spec-fade-3-2026-10-06.txt](../../Documentation/References/HeaderLarge/spec-fade-3-2026-10-06.txt)
- [Documentation/References/HeaderLarge/spec-fade-4-2026-10-06.txt](../../Documentation/References/HeaderLarge/spec-fade-4-2026-10-06.txt)
- [Documentation/References/HeaderLarge/spec-fade-5-2026-10-06.txt](../../Documentation/References/HeaderLarge/spec-fade-5-2026-10-06.txt)
- [Documentation/References/HeaderLarge/spec-large-sizes-2026-10-06.txt](../../Documentation/References/HeaderLarge/spec-large-sizes-2026-10-06.txt)
- [Documentation/References/HeaderLarge/spec-large-sizing-rules-2026-10-06.txt](../../Documentation/References/HeaderLarge/spec-large-sizing-rules-2026-10-06.txt)
- [Documentation/References/HeaderLarge/spec-links-live-2026-10-06.txt](../../Documentation/References/HeaderLarge/spec-links-live-2026-10-06.txt)
- [Documentation/References/HeaderLarge/spec-multiline-image-2026-10-06.png](../../Documentation/References/HeaderLarge/spec-multiline-image-2026-10-06.png)
- [Documentation/References/HeaderLarge/spec-multiline-image-2026-10-06.txt](../../Documentation/References/HeaderLarge/spec-multiline-image-2026-10-06.txt)
- [Documentation/References/HeaderLarge/spec-sizes-2026-10-06.txt](../../Documentation/References/HeaderLarge/spec-sizes-2026-10-06.txt)
- [Documentation/References/HeaderLarge/spec-voiceover-2026-10-06.txt](../../Documentation/References/HeaderLarge/spec-voiceover-2026-10-06.txt)
- [Documentation/Validation/2026-10-06/HeaderLargeContinuousDeliveryUI/manifest.json](../../Documentation/Validation/2026-10-06/HeaderLargeContinuousDeliveryUI/manifest.json)
- [Documentation/Validation/2026-10-06/HeaderLargeFullAcceptanceNative/manifest.json](../../Documentation/Validation/2026-10-06/HeaderLargeFullAcceptanceNative/manifest.json)
- [Documentation/Validation/2026-10-06/HeaderLargeFullAcceptanceUI/manifest.json](../../Documentation/Validation/2026-10-06/HeaderLargeFullAcceptanceUI/manifest.json)
- [Documentation/Validation/2026-10-06/HeaderLargeNaturalDeliveryUI/manifest.json](../../Documentation/Validation/2026-10-06/HeaderLargeNaturalDeliveryUI/manifest.json)
- [Documentation/Validation/2026-10-06/HeaderNativeLayoutProbe/manifest.json](../../Documentation/Validation/2026-10-06/HeaderNativeLayoutProbe/manifest.json)
- [Documentation/Validation/2026-10-06/header-large-continuous-delivery-ui-summary.json](../../Documentation/Validation/2026-10-06/header-large-continuous-delivery-ui-summary.json)
- [Documentation/Validation/2026-10-06/header-large-continuous-fade-package-summary.json](../../Documentation/Validation/2026-10-06/header-large-continuous-fade-package-summary.json)
- [Documentation/Validation/2026-10-06/header-large-full-acceptance-package-summary.json](../../Documentation/Validation/2026-10-06/header-large-full-acceptance-package-summary.json)
- [Documentation/Validation/2026-10-06/header-large-full-acceptance-ui-summary.json](../../Documentation/Validation/2026-10-06/header-large-full-acceptance-ui-summary.json)
- [Documentation/Validation/2026-10-06/header-large-link-focus-final-package-summary.json](../../Documentation/Validation/2026-10-06/header-large-link-focus-final-package-summary.json)
- [Documentation/Validation/2026-10-06/header-large-multiline-baseline-audit.json](../../Documentation/Validation/2026-10-06/header-large-multiline-baseline-audit.json)
- [Documentation/Validation/2026-10-06/header-large-multiline-natural-package-summary.json](../../Documentation/Validation/2026-10-06/header-large-multiline-natural-package-summary.json)
- [Documentation/Validation/2026-10-06/header-large-native-link-focus-ui-summary.json](../../Documentation/Validation/2026-10-06/header-large-native-link-focus-ui-summary.json)
- [Documentation/Validation/2026-10-06/header-large-native-range-contract-summary.json](../../Documentation/Validation/2026-10-06/header-large-native-range-contract-summary.json)
- [Documentation/Validation/2026-10-06/header-large-natural-delivery-ui-summary.json](../../Documentation/Validation/2026-10-06/header-large-natural-delivery-ui-summary.json)

Реализация: IMPLEMENTED. Приёмка: **in-progress**.

- variantMapping: **passed**. All ten applicable variants and five source properties mapped; missing source bindings are explicitly preserved. Current native matrix and default-property checks pass.
- specification: **passed**. All applicable source guidance reviewed requirement by requirement in final-acceptance-2026-10-06.md: typography, slots, customizations, overflow, native accessories, AX1/reflow and URL semantics. Explicit desktop exclusions and externally owned content are documented.
- visual: **pending**. Ten fresh Day/native image pairs reviewed against original Figma 3x; all twenty Day/Night native variants are decoded-pixel identical to the prior accepted matrix. Original metrics, fonts, tracking and Foundation colors retained; contour-rasterization limits explicitly documented. Current continuous multiline fade and inline-image checks pass. Header Card exposes existing renderer helpers internally only; 15 tests pass and all 42 common native PNGs are pixel-identical to the accepted baseline. System SF Pro chosen by user on 2026-10-20; bundled legacy font inputs retired to historicalInputHashes. Historical renders do not accept the new system face.
- interaction: **passed**. Full 11-case native UI run passes: ordinary title/subheader/description links, distinct additional-action URL targets, the visible continued fade fragment, independent Toggle 0-to-1-to-0, native Link accessory and live catalog interactions.
- accessibility: **not-applicable**. Explicit user scope exclusion for interactive prototypes: no VoiceOver, accessibility font enlargement or extra accessibility modes. This is a delivery scope waiver, not evidence that Figma has no accessibility requirements or that these modes were tested. Original check retained in previousAccessibilityCheck.
- motion: **passed**. Current complete UI run repeats real Settings Reduce Motion plus foreground, background/return and reappearance in live Header skeleton composition. Both text bars animate normally and remain still under Reduce Motion; system preference restored. No custom Header or sheet timing. Shared Skeleton dependency revalidated on 2026-10-15 after additive geometry API: all 13 default Text poses remain RGBA-identical; source-curve test and live core/Text route pass. Only Skeleton hash renewed; Header-specific UI remains historical and unrelated tracking issues remain open.
- integration: **pending**. Current independent application imports only the public Swift Package product with bundled resources. Full native UI run proves state ownership, URL handlers, rendering and native accessory actions. Package and standalone catalog compile and execute. После добавления отдельного пункта Card Medium повторно проверены Header state/links/AX1 reflow и baseline accessory; оба сценария Passed. Остальная полная приёмка 6 октября сохраняется на неизменённых исходниках, не объявляется новым полным прогоном. Header Card exposes existing renderer helpers internally only; 15 tests pass and all 42 common native PNGs are pixel-identical to the accepted baseline. After adding a separate Header Card consumer route, the unchanged Card Medium action/sheet test and two Header Large link-action cases pass; only the consumer entry-point dependency hash is renewed.

Открытые вопросы:
- Повторная приёмка после исправления общего tracking: 40 из 42 рендеров идентичны прежней приёмке, два примера с TUILink изменились; сверить их по Figma и обновить inputHashes только после проверки. См. Documentation/Validation/2026-10-08/Typography/header-large-regression.json.
- Reverify native system SF Pro after explicit user decision 2026-10-20; legacy font binaries are no longer distributed. Historical visual evidence is not acceptance of the new face.

## tui-header [switch] · 42565:303804

Назначение из описания Figma: Заголовок для группы контента или шторки

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=42565-303804). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-header-specs) → [разрешённая ссылка Figma](https://www.figma.com/design/Vt4htBIFAjKUg8c547G0Ez/tui-header?node-id=1-2&t=piPmlEpFuc3QqAOn-1)

Варианты: 18 всего; 9 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| Accessories | VARIANT | "off" | ["on", "off"] |
| Badge#41997:19 | BOOLEAN | true | [] |
| Description | VARIANT | "off" | ["off", "on"] |
| DescriptionText#42565:86 | TEXT | "Description" | [] |
| HeaderText#42565:68 | TEXT | "Header" | [] |
| Hint#41997:12 | BOOLEAN | true | [] |
| Size | VARIANT | "Medium" | ["Medium", "Small"] |
| Subheader#42565:95 | BOOLEAN | false | [] |
| SubheaderText#42565:77 | TEXT | "Subheader" | [] |
| System | VARIANT | "iOS" | ["iOS", "Android"] |
| skeleton | VARIANT | "off" | ["off", "on"] |

Свойства состояний из импортированной матрицы: skeleton

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/Body L | Font(family: "Roboto", style: Regular, size: 16, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/Body M | Font(family: "Roboto", style: Regular, size: 14, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Android/Heading M | Font(family: "Roboto", style: Bold, size: 20, weight: 700, lineHeight: 100, letterSpacing: 0) |
| Android/Heading S | Font(family: "Roboto", style: Medium, size: 16, weight: 500, lineHeight: 100, letterSpacing: 0) |
| Background/Neutral 1 | #00102408 |
| Background/Neutral 3 | #0010241f |
| Component/Badge Notification | #f52222 |
| Screen Padding | 16 |
| Service/Skeleton | #00000008 |
| Text/Primary | #333333 |
| Text/Primary On Dark | #ffffff |
| Text/Secondary | #9299a2 |
| iOS/Body L | Font(family: "SF Pro Text", style: Regular, size: 17, weight: 400, lineHeight: 100, letterSpacing: -0.4099999964237213) |
| iOS/Body M | Font(family: "SF Pro Text", style: Regular, size: 15, weight: 400, lineHeight: 100, letterSpacing: -0.23999999463558197) |
| iOS/Heading M | Font(family: "SF Pro Display", style: Bold, size: 20, weight: 600, lineHeight: 100, letterSpacing: 0.3799999952316284) |
| iOS/Heading S | Font(family: "SF Pro Text", style: Semibold, size: 17, weight: 600, lineHeight: 100, letterSpacing: -0.4099999964237213) |

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

## tui-search-bar · 25762:537956

Назначение из описания Figma: Панель поиска с полем и кнопкой "Отменить" в фокусе.  В айосе используется нативный UISearchBar

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=25762-537956). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-searchbar-specs) → [разрешённая ссылка Figma](https://www.figma.com/design/n7VJkgfOx2GsecqNG6h177/tui-search-bar?node-id=0-1&t=f0tWKNPJ6cLzmg6R-1)

Варианты: 16 всего; 4 применимых iOS 26; 6 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| filled | VARIANT | "off" | ["off", "on"] |
| state | VARIANT | "normal" | ["normal", "pressed", "active"] |
| system | VARIANT | "iOS 18" | ["iOS 18", "Android", "iOS 26"] |

Свойства состояний из импортированной матрицы: state

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/Body M | Font(family: "Roboto", style: Regular, size: 14, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Background/Accent 2 | #428bf9 |
| Background/Neutral 2 | #0010240f |
| Screen Padding | 16 |
| Service/Android/Ripple | #0000000a |
| State/Background/Neutral 1 Pressed | #0010240f |
| State/Background/Neutral 2 Pressed | #0010241f |
| Status/Info | #428bf9 |
| Text/Primary | #333333 |
| Text/Secondary | #9299a2 |
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

## tui-tab-bar · 23068:2266

Назначение из описания Figma: Это мастер-компонент. Нажмите shift+enter чтобы подняться на уровень выше

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=23068-2266). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
Ссылка не импортирована; это не доказательство отсутствия спецификации в Figma.

Варианты: 5 всего; 1 применимых iOS 26; 1 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| Home Indicator#63101:0 | BOOLEAN | true | [] |
| System | VARIANT | "iOS 18" | ["iOS 18", "Android", "PWA (standalone)", "PWA (browser)", "iOS 26"] |

Свойства состояний из импортированной матрицы: UNVERIFIED: отдельные свойства состояний не импортированы.

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/UI XS | Font(family: "Roboto", style: Regular, size: 12, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Background/Accent 2 | #428bf9 |
| Background/Accent Opposite | #000000 |
| Background/Base | #ffffff |
| Border/Normal | #0010241f |
| Component/Tab Bar/Background | #f6f7f8cc |
| Gradient/Mask/Fade Bottom |  |
| Tab Bar Content Color | #9299a2 |
| Text/Primary | #333333 |
| Text/Secondary | #9299a2 |
| bg blur | Effect(type: BACKGROUND_BLUR, radius: 10) |
| blur-tabbar | Effect(type: BACKGROUND_BLUR, radius: 50) |

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

5 импортированных variant ID не наблюдаются в свежем page metadata. Это не доказательство удаления; требуется get_design_context конкретного набора.

## tui-tab-bar / Bookkeeping · 23142:458939

Назначение из описания Figma: Нативная навигационная панель

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=23142-458939). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-tabbar) → [разрешённая ссылка Figma](https://www.figma.com/design/uTil8F35FDsTVLJv4em1wX/tui-tabbar?node-id=1-14305&t=wg8gDYbCuL8B4enh-1)

Варианты: 6 всего; 3 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| Active Tab | VARIANT | "Главная" | ["Главная", "Чат", "Еще"] |
| System | VARIANT | "iOS" | ["iOS", "Android"] |

Свойства состояний из импортированной матрицы: UNVERIFIED: отдельные свойства состояний не импортированы.

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/UI XS | Font(family: "Roboto", style: Regular, size: 12, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Background/Accent Opposite | #000000 |
| Background/Base | #ffffff |
| Border/Normal | #0010241f |
| Component/Tab Bar/Background | #f6f7f8cc |
| Tab Bar Content Color | #9299a2 |
| Text/Action | #428bf9 |
| Text/Secondary | #9299a2 |
| blur-tabbar | Effect(type: BACKGROUND_BLUR, radius: 50) |

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

## tui-tab-bar / Invest · 23142:453257

Назначение из описания Figma: Нативная навигационная панель

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=23142-453257). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-tabbar) → [разрешённая ссылка Figma](https://www.figma.com/design/uTil8F35FDsTVLJv4em1wX/tui-tabbar?node-id=1-14305&t=wg8gDYbCuL8B4enh-1)

Варианты: 10 всего; 5 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| Active Tab | VARIANT | "Главная" | ["Главная", "Что купить", "Лента", "Чат", "Еще"] |
| System | VARIANT | "iOS" | ["iOS", "Android"] |

Свойства состояний из импортированной матрицы: UNVERIFIED: отдельные свойства состояний не импортированы.

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/UI XS | Font(family: "Roboto", style: Regular, size: 12, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Background/Accent Opposite | #000000 |
| Background/Base | #ffffff |
| Border/Normal | #0010241f |
| Caption 2, 10 Medium | Font(family: "SF Pro Text", style: Medium, size: 10, weight: 500, lineHeight: 100, letterSpacing: -0.23999999463558197) |
| Component/Tab Bar/Background | #f6f7f8cc |
| Tab Bar Content Color | #9299a2 |
| Text/Primary | #333333 |
| Text/Secondary | #9299a2 |
| blur-tabbar | Effect(type: BACKGROUND_BLUR, radius: 50) |

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

## tui-tab-bar / Junior · 112725:32337

Назначение из описания Figma: Нативная навигационная панель

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=112725-32337). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-tabbar) → [разрешённая ссылка Figma](https://www.figma.com/design/uTil8F35FDsTVLJv4em1wX/tui-tabbar?node-id=1-14305&t=wg8gDYbCuL8B4enh-1)

Варианты: 10 всего; 5 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| Active Tab | VARIANT | "Главная" | ["Главная", "Платежи", "Чат", "Джуниор", "Город"] |
| System | VARIANT | "iOS" | ["iOS", "Android"] |

Свойства состояний из импортированной матрицы: UNVERIFIED: отдельные свойства состояний не импортированы.

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/UI XS | Font(family: "Roboto", style: Regular, size: 12, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Background/Accent Opposite | #000000 |
| Background/Base | #ffffff |
| Border/Normal | #0010241f |
| Component/Tab Bar/Background | #f6f7f8cc |
| Tab Bar Content Color | #9299a2 |
| Text/Action | #428bf9 |
| Text/Secondary | #9299a2 |
| blur-tabbar | Effect(type: BACKGROUND_BLUR, radius: 50) |

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

## tui-tab-bar / MB · 23142:450541

Назначение из описания Figma: Нативная навигационная панель

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=23142-450541). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-tabbar) → [разрешённая ссылка Figma](https://www.figma.com/design/uTil8F35FDsTVLJv4em1wX/tui-tabbar?node-id=1-14305&t=wg8gDYbCuL8B4enh-1)

Варианты: 16 всего; 7 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| Active Tab | VARIANT | "Главная" | ["Главная", "Платежи", "Город", "Чат", "Еще", "Войти"] |
| System | VARIANT | "iOS" | ["iOS", "Android", "PWA (Browser)", "PWA (standalone)"] |
| User | VARIANT | "Authorized" | ["Authorized", "Origination"] |

Свойства состояний из импортированной матрицы: UNVERIFIED: отдельные свойства состояний не импортированы.

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/UI XS | Font(family: "Roboto", style: Regular, size: 12, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Background/Accent Opposite | #000000 |
| Background/Base | #ffffff |
| Border/Normal | #0010241f |
| Component/Tab Bar/Background | #f6f7f8cc |
| Tab Bar Content Color | #9299a2 |
| Text/Action | #428bf9 |
| Text/Primary | #333333 |
| Text/Secondary | #9299a2 |
| bg blur | Effect(type: BACKGROUND_BLUR, radius: 10) |
| blur-tabbar | Effect(type: BACKGROUND_BLUR, radius: 50) |

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

## tui-tab-bar / Mobile · 23142:455406

Назначение из описания Figma: Нативная навигационная панель

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=23142-455406). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-tabbar) → [разрешённая ссылка Figma](https://www.figma.com/design/uTil8F35FDsTVLJv4em1wX/tui-tabbar?node-id=1-14305&t=wg8gDYbCuL8B4enh-1)

Варианты: 10 всего; 5 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| Active Tab | VARIANT | "Главная" | ["Главная", "Роуминг", "Услуги", "Чат", "Еще"] |
| System | VARIANT | "iOS" | ["iOS", "Android"] |

Свойства состояний из импортированной матрицы: UNVERIFIED: отдельные свойства состояний не импортированы.

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/UI XS | Font(family: "Roboto", style: Regular, size: 12, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Background/Accent Opposite | #000000 |
| Background/Base | #ffffff |
| Border/Normal | #0010241f |
| Caption 2, 10 Medium | Font(family: "SF Pro Text", style: Medium, size: 10, weight: 500, lineHeight: 100, letterSpacing: -0.23999999463558197) |
| Component/Tab Bar/Background | #f6f7f8cc |
| Tab Bar Content Color | #9299a2 |
| Text/Secondary | #9299a2 |
| blur-tabbar | Effect(type: BACKGROUND_BLUR, radius: 50) |

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

## tui-tab-bar / Signature · 58367:296400

Назначение из описания Figma: Нативная навигационная панель

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=58367-296400). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-tabbar) → [разрешённая ссылка Figma](https://www.figma.com/design/uTil8F35FDsTVLJv4em1wX/tui-tabbar?node-id=1-14305&t=wg8gDYbCuL8B4enh-1)

Варианты: 16 всего; 8 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| Active Tab | VARIANT | "Документы" | ["Выпуск подписи", "Документы", "Чат", "Еще"] |
| System | VARIANT | "iOS" | ["iOS", "Android"] |
| User | VARIANT | "Default" | ["Default", "Origination", "Origination + Chat"] |

Свойства состояний из импортированной матрицы: UNVERIFIED: отдельные свойства состояний не импортированы.

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/UI XS | Font(family: "Roboto", style: Regular, size: 12, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Background/Accent Opposite | #000000 |
| Background/Base | #ffffff |
| Border/Normal | #0010241f |
| Component/Tab Bar/Background | #f6f7f8cc |
| Tab Bar Content Color | #9299a2 |
| Text/Action | #428bf9 |
| Text/Secondary | #9299a2 |
| blur-tabbar | Effect(type: BACKGROUND_BLUR, radius: 50) |

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

## tui-tab-bar / SME · 23068:2615

Назначение из описания Figma: Нативная навигационная панель

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=23068-2615). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
- [Исходная ссылка](https://go.tcsbank.ru/tui-tabbar) → [разрешённая ссылка Figma](https://www.figma.com/design/uTil8F35FDsTVLJv4em1wX/tui-tabbar?node-id=1-14305&t=wg8gDYbCuL8B4enh-1)

Варианты: 22 всего; 10 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| Active Tab | VARIANT | "Главная" | ["Главная", "Платежи", "Сервисы", "Чат", "Еще", "Заявка"] |
| System | VARIANT | "iOS" | ["iOS", "Android", "PWA (standalone)", "PWA (browser)"] |
| User | VARIANT | "Default" | ["Default", "Origination", "Origination + Chat"] |

Свойства состояний из импортированной матрицы: UNVERIFIED: отдельные свойства состояний не импортированы.

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Android/UI XS | Font(family: "Roboto", style: Regular, size: 12, weight: 400, lineHeight: 100, letterSpacing: 0) |
| Background/Accent Opposite | #000000 |
| Background/Base | #ffffff |
| Border/Normal | #0010241f |
| Component/Tab Bar/Background | #f6f7f8cc |
| Tab Bar Content Color | #9299a2 |
| Text/Action | #428bf9 |
| Text/Primary | #333333 |
| Text/Secondary | #9299a2 |
| bg blur | Effect(type: BACKGROUND_BLUR, radius: 10) |
| blur-tabbar | Effect(type: BACKGROUND_BLUR, radius: 50) |

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

