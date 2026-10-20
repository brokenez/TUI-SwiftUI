# Foundations

Это индекс сохранённых источников и текущей приёмки. Он не добавляет новых требований Figma.

Публикация через MCP: UNVERIFIED. Полные ID вариантов и определения свойств: [inventory.json](../inventory.json).

## Токены

Источник: [TUI Foundations](https://www.figma.com/design/gGt4PaQxQhX7ozPVImsgL5/TUI-Foundations?node-id=1-75).
Ассеты: [TUI Assets](https://www.figma.com/design/R1oI4T6X9CHxl2x55MDypT/TUI-Assets?node-id=67-0).

| Коллекция | Variables в сохранённом импорте | Modes |
| --- | --- | --- |
| Primitive | 334 | Mode 1 |
| Theme | 300 | Day, Night |
| Platform | 305 | iOS, Android, Desktop |
| State | 18 | Normal, Hover (Desktop), Pressed, Loading, Disabled, Focus (Desktop) |

Публичные типы уже существуют: TUIColor, TUITypographyRole, TUISpacing, TUIRadius, TUIControlSize, TUIMotionDuration, TUIMotionCurve.
Тема Day/Night, платформа iOS 26. Desktop Hover/Focus и Android не считаются исполненными на iOS.
Первичная проверка импорта и runtime: [аудит Foundations](../../Documentation/References/Foundations/token-audit-2026-10-08.md). Она не заменяет визуальную приёмку и актуализацию источника.
Прочитана спецификация Typography и особенности iOS: [источники, 31 роль, Dynamic Type и ограничения](../../Documentation/References/Foundations/typography-specification-2026-10-08.md). Правило line box остаётся PARTIAL; отметка полного совпадения не присваивается.
Потребители Foundation-ролей исправлены и проверены: [45 тестов, Caps и сопоставление снимков](../../Documentation/References/Foundations/typography-consumers-2026-10-08.md). Legacy-стили остаются отдельным вопросом.
Прочитаны Color, Size, Shadow и Animation: [правила, исходные ссылки и ограничения](../../Documentation/References/Foundations/color-size-shadow-motion-2026-10-08.md). Medium-тень добавлена в публичный API; составные стили и renderer ещё требуют проверки.
Решение пользователя от 20 октября 2026: системный SF Pro iOS 26; файлы старых шрифтов исключены из пакета. [Решение и повторная приёмка](../../Documentation/typography-decision-2026-10-20.md), [текущая проверка Foundations](../../Documentation/References/Foundations/release-2026-10-20.md). Неподтверждённые составные стили и line box не объявляются принятыми.

## tui-spacing · 28406:482266

Назначение из описания Figma: UNVERIFIED: описание в импорте отсутствует.

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=28406-482266). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
Ссылка не импортирована; это не доказательство отсутствия спецификации в Figma.

Варианты: 21 всего; 21 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| Size | VARIANT | "10 - 48px" | ["0", "01 - 2px", "02 - 4px", "03 - 8px", "04 - 12px", "05 - 16px", "06 - 20px", "07 - 24px", "08 - 32px", "09 - 40px", "10 - 48px"] |
| Visible | VARIANT | "on" | ["on", "off"] |

Свойства состояний из импортированной матрицы: UNVERIFIED: отдельные свойства состояний не импортированы.

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Status/Negative Pale | #f5222224 |
| Text/Negative | #f52222 |

Текущий публичный API: `TUISpacingIndicator`, [реализация](../../Sources/TUIDesignSystem/Components/Spacing/TUISpacingIndicator.swift).
Зависимости, наблюдаемые в Swift-коде (не подтверждённый граф Figma): TUIColor, TUISpacing.

### Сохранённые материалы и результат проверки

Материалы извлечения спецификации ещё не привязаны к паспорту: UNVERIFIED.

Реализация: IMPLEMENTED. Приёмка: **in-progress**.

- variantMapping: **passed**. Все применимые строки сохранённого импорта однозначно сопоставлены enum и параметрам публичного API; это не свежая визуальная приёмка Figma.
- specification: **pending**. Единая повторная приёмка ещё не выполнена.
- visual: **pending**. Единая повторная приёмка ещё не выполнена.
- interaction: **pending**. Единая повторная приёмка ещё не выполнена.
- accessibility: **not-applicable**. Explicit user scope exclusion for interactive prototypes: no VoiceOver, accessibility font enlargement or extra accessibility modes. This is a delivery scope waiver, not evidence that Figma has no accessibility requirements or that these modes were tested. Original check retained in previousAccessibilityCheck.
- motion: **pending**. Единая повторная приёмка ещё не выполнена.
- integration: **pending**. Единая повторная приёмка ещё не выполнена.

Открытые вопросы:
- Повторно подтвердить всю матрицу, спецификацию, взаимодействия, темы, AX и motion; оформить доказательства.

## underline · 55278:70654

Назначение из описания Figma: UNVERIFIED: описание в импорте отсутствует.

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=55278-70654). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
Ссылка не импортирована; это не доказательство отсутствия спецификации в Figma.

Варианты: 2 всего; 2 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| pseudo | VARIANT | "No" | ["No", "Yes"] |

Свойства состояний из импортированной матрицы: UNVERIFIED: отдельные свойства состояний не импортированы.

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Service/Underline Grayscale | #9299a2 |

Текущий публичный API: `TUIUnderline`, [реализация](../../Sources/TUIDesignSystem/Components/Underline/TUIUnderline.swift).
Зависимости, наблюдаемые в Swift-коде (не подтверждённый граф Figma): .

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

## underline · 55278:70659

Назначение из описания Figma: UNVERIFIED: описание в импорте отсутствует.

Исходный Component Set: [Figma](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=55278-70659). Публикация: UNVERIFIED; набор наблюдается на Components: True.

Спецификация: **UNVERIFIED**.
Ссылка не импортирована; это не доказательство отсутствия спецификации в Figma.

Варианты: 2 всего; 2 применимых iOS 26; 0 исторических iOS 18.

### Свойства и состояния

| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |
| --- | --- | --- | --- |
| pseudo | VARIANT | "No" | ["No", "Yes"] |

Свойства состояний из импортированной матрицы: UNVERIFIED: отдельные свойства состояний не импортированы.

### Правила и ограничения

Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.

Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI.

Определения из свежего MCP для всего набора: [источник](../../Documentation/Inventory/2026-10-08/component-variable-definitions-mcp.json). Это не полная таблица bindings и режимов тем.

| Имя из MCP | Наблюдаемое определение |
| --- | --- |
| Service/Underline | #97bffc |

Текущий публичный API: `TUIUnderline`, [реализация](../../Sources/TUIDesignSystem/Components/Underline/TUIUnderline.swift).
Зависимости, наблюдаемые в Swift-коде (не подтверждённый граф Figma): .

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

