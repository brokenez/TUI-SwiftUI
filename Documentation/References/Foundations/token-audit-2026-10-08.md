# Foundations: первичный аудит токенов

Этот отчёт фиксирует состояние до чтения подробной спецификации. Последующее изменение API и новые проверки: [31 роль Typography и правила iOS](typography-specification-2026-10-08.md), [Color, Size, Shadow и Animation](color-size-shadow-motion-2026-10-08.md). Исходные числа 23/10 ниже относятся к первичному снимку, а не к текущему enum.

Источник — [TUI Foundations, 1:75](https://www.figma.com/design/gGt4PaQxQhX7ozPVImsgL5/TUI-Foundations?node-id=1-75), сохранённый импорт [figma-foundations.json](../../../Sources/TUIDesignSystem/Resources/Metadata/figma-foundations.json). SHA-256: `bc3140e4761494f35fdbc7f00174c8b55e05e55a4d2547878c73052b6c52b11a`.

Это аудит существующего импорта и SwiftUI-реализации. Актуальность всех значений относительно текущего файла Figma — **UNVERIFIED**. Исходные Figma-файлы и производственные токены не изменены.

## Подтверждено по импорту и коду

- 957 переменных: Primitive 334, Theme 300, Platform 305, State 18.
- 1 957 сочетаний переменной и режима; независимый обход JSON не обнаружил потерянных целей alias, циклов и пустых значений. Режимы Android/Desktop проверяются как данные, не как исполнение этих платформ.
- 23 публичные роли TUITypographyRole имеют исходные значения family, size, weight, lineHeight и letterSpacing. В импорте Body/L iOS: SF Pro, Regular 400, 17 pt, lineHeight 24, tracking −0.43. Для текста в контролах существует отдельный UI/L с lineHeight 20: эти роли нельзя смешивать.
- Всего в Platform 39 ролей, из них 6 с явной пометкой Heading Desktop. Из остальных 33 публичный enum покрывает 23. Отсутствуют Caps/S, Caps/S Bold, Caps/2XS, Caps/2XS Bold, Code/M, Code/S, UI/2XS, UI/2XS Bold, UI/3XS, UI/3XS Bold.
- Публичные duration читаются из Primitive: 0.075, 0.15, 0.3, 0.5, 0.7 секунды. Существуют шесть cubic Bézier curves.

## Runtime-проверка

[FoundationTokenTests.swift](../../../Tests/TUIDesignSystemTests/FoundationTokenTests.swift) проверяет реальные ресурсы пакета: типы всех 1 957 значений, отсутствие непрочитанных alias, каждое поле 23 публичных ролей, Day/Night цветов с alpha и пять длительностей/шесть нативных UnitCurve. Проверка кривых включает overshoot expressive-entrance.

Пакет собран; четыре теста прошли, ошибок и пропусков нет. Устройство: iPhone 17 Pro, iOS Simulator 26.4.1 (23E254a). Подтверждение: [test-summary.json](../../Validation/2026-10-08/Foundations/test-summary.json), [журнал](../../Validation/2026-10-08/Foundations/native-tests.log). Runtime-проверка указанного объёма — passed; полная приёмка Foundations остаётся открытой.

## Что мешает полной приёмке Foundations

- Добавление десяти отсутствующих ролей требует проверки назначения и шрифтов. Code использует JetBrains Mono; подмена стандартным monospaced не подтверждена источником.
- TUITypographyMetrics.font выбирает системный SF; одинаковые числовые метрики не доказывают совпадение начертания, line box и Dynamic Type. Решение по legacy SF и распространению остаётся открытым в [плане](../../distribution-and-catalog-plan.md).
- TUISpacing, TUIRadius и TUIControlSize содержат фиксированные значения. Полная привязка к первоисточникам и применимость ко всем компонентам ещё требуют проверки. Найденный в Primitive Spacing/Soon не является доказательством полной spacing-шкалы.
- TUIColor.separator использует системный UIColor.separator. Его соответствие нужному токену и месту использования нужно проверить по спецификациям компонентов.
- Resolver выбирает первый режим, когда имя режима не найдено. Текущие проверки используют существующие режимы; согласование режимов между коллекциями и правила недоступного режима отдельно не приняты.
- Fallbacks в публичных цветах/метриках способны скрыть отсутствующий токен. Тесты выявляют эту проблему для проверенного импорта; отдельный контракт ошибок API не извлечён из Figma.
- Анимации компонентов, Reduce Motion, accessibility и визуальное сравнение проходят отдельную приёмку. Чтение motion-токенов не доказывает поведение компонента.

Ни один статус complete этим аудитом не назначается. После Foundations первая реализационная группа — Buttons; зависимости проверяются до их использования.
