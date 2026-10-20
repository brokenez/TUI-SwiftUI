# Типографика в составных компонентах — 8 октября 2026

Источник: [Foundations UI, 8705:3304](https://www.figma.com/design/gGt4PaQxQhX7ozPVImsgL5/TUI-Foundations?node-id=8705-3304) и [сопоставление iOS, 12472:11173](https://www.figma.com/design/gGt4PaQxQhX7ozPVImsgL5/TUI-Foundations?node-id=12472-11173). Letter Spacing* предназначен для Figma: iOS подставляет интервал автоматически.

Исправлены потребители явно заданных системных ролей: Header Large, Header Card, Card Medium, Cell и Cell Checkicon. Они сохраняют вес и Rounded-семейство из роли, используют соответствующий роли стиль Dynamic Type и не добавляют старый tracking по месту размещения текста. Явный пользовательский tracking продолжает работать. Notification Badge использует роль и её стиль масштабирования без повторного tracking. Block Status использует общий модификатор типографики, включая масштабирование и line spacing.

Caps преобразует текст в верхний регистр в пяти потребителях. Card Medium измеряет уже преобразованную строку, чтобы расчёт количества строк совпадал с отображением. Составные accessibility labels сохраняют исходное содержимое.

Legacy-стили по умолчанию сохранены отдельно от явно выбранных Foundation-ролей. Это не решение об их распространении и не подтверждение соответствия старого SF Pro системному шрифту iOS 26. Вопрос выбора версии шрифта остаётся открытым.

## Проверка

- [45 тестов, 0 ошибок](../../Validation/2026-10-08/TypographyConsumers/package-test-summary.json), iPhone 17 Pro, iOS 26.4.1. Проверены 31 роль × 3 размера Dynamic Type × 9 слотов метрик; Caps — 4 роли × 2 размера × 5 компонентов. Дополнительно выполнены существующие тесты матриц, переносов, размеров, AX1 cap, ресурсов и Day/Night.
- [Каталог собран](../../Validation/2026-10-08/TypographyConsumers/catalog-build.log).
- [218 нативных вложений](../../Validation/2026-10-08/TypographyConsumers/Native/manifest.json), включая PNG, PDF и измерения базовых линий.
- [Сравнение с предыдущим запуском](../../Validation/2026-10-08/TypographyConsumers/header-large-regression.json): 46 совпадающих PNG идентичны по RGBA без масштабирования и нормализации. В их числе все 20 стандартных вариантов Header Large в двух темах. Это проверка отсутствия регрессии, не новая полная визуальная приёмка по Figma.
- [Хеши проверенных исходников](../../Validation/2026-10-08/TypographyConsumers/input-hashes.json).

Статусы complete не повышены. Общая приёмка Foundations, два ранее изменившихся примера Header Large с TUILink, полное поведение line box и решение по версии SF Pro остаются незавершёнными. Для Block Status выполнена сборка; его полная матрица и visual/accessibility acceptance в эту проверку не входят.
