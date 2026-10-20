# Typography: спецификация iOS и исправления

Дата извлечения: 8 октября 2026. Источник — Figma Desktop MCP; оригинальный файл не изменён.

## Первоисточники

- [Страница Typography, 7933:16869](https://www.figma.com/design/gGt4PaQxQhX7ozPVImsgL5/TUI-Foundations?node-id=7933-16869).
- [Особенности iOS, 12472:11173](https://www.figma.com/design/gGt4PaQxQhX7ozPVImsgL5/TUI-Foundations?node-id=12472-11173): Dynamic Type, таблица 31 роли и пример respectsFontLineHeight.
- [Структура, 8705:3478](https://www.figma.com/design/gGt4PaQxQhX7ozPVImsgL5/TUI-Foundations?node-id=8705-3478): назначение групп.
- [Представление в коде, 8705:3465](https://www.figma.com/design/gGt4PaQxQhX7ozPVImsgL5/TUI-Foundations?node-id=8705-3465): платформенные iosValue/androidValue/desktopValue и параметры.
- [Heading, 8705:3250](https://www.figma.com/design/gGt4PaQxQhX7ozPVImsgL5/TUI-Foundations?node-id=8705-3250), [Body, 8705:3272](https://www.figma.com/design/gGt4PaQxQhX7ozPVImsgL5/TUI-Foundations?node-id=8705-3272), [UI, 8705:3304](https://www.figma.com/design/gGt4PaQxQhX7ozPVImsgL5/TUI-Foundations?node-id=8705-3304), [Caps, 8705:3348](https://www.figma.com/design/gGt4PaQxQhX7ozPVImsgL5/TUI-Foundations?node-id=8705-3348), [Numbers, 8705:3368](https://www.figma.com/design/gGt4PaQxQhX7ozPVImsgL5/TUI-Foundations?node-id=8705-3368): таблицы разных платформ и примечание об автоматическом tracking iOS.

Полный текст MCP сохранён в Documentation/Inventory/2026-10-08: ios-context-mcp.json и файлы по маске typography-*-context.json. Растровые снимки исходных фреймов — файлы по маске typography-*-source-2026-10-08.png рядом с этим документом. [Машиночитаемая таблица iOS](ios-typography-specification-2026-10-08.json) содержит точные строки источника. Предыдущие ответы с ошибкой доступа сохранены отдельно как история; спецификация больше не считается недоступной из-за разрешений MCP.

## Назначение и правила

Heading Mobile — заголовки мобильных блоков, карточек и экранов. Body — многострочные подзаголовки и описания. UI — однострочные подписи, кнопки и бейджи. Caps — текст заглавными буквами. Numbers — суммы и балансы. Модификатор Bold обозначает более жирную семантическую роль; он не означает обязательный Font.Weight.bold. Например, UI/2XS Bold на iOS — 600, UI/3XS Bold — 700, Caps/S Bold — 500.

Спецификация всех пяти групп прямо указывает: Letter Spacing* нужен для Figma, на iOS интервал устанавливается автоматически. Параметр letterSpacing в разделе представления токена в коде отмечен как применимый к Web. Поэтому общий модификатор tuiTypography использует системный шрифт без дополнительного tracking. Поле metrics.letterSpacing сохраняется как исходное справочное значение; его наличие не требует прибавлять его к системному шрифту.

Размер из токена и системный стиль Dynamic Type — разные параметры. Например, Heading Mobile/L имеет базу 30 pt и масштабируется относительно Large Title, Number/2XL — базу 48 pt с тем же стилем, UI/3XS — базу 9 pt относительно Caption 2. Нельзя заменять роль стандартным Font.largeTitle или Font.caption2 и терять базовый размер.

Caps задаёт Uppercase. Общий модификатор применяет textCase(.uppercase), сохраняя выбор веса, базовый размер и системное масштабирование. Он не ограничивает категорию Dynamic Type; ограничение отдельного компонента проверяется по его собственной спецификации.

## Таблица iOS из источника

| Роль в Figma | База, pt | textStyle | Примерный системный размер, pt |
| --- | --- | --- | --- |
| Heading Mobile / L | 30 | Large Title | 34 |
| Heading Mobile / M | 20 | Title 3 | 20 |
| Heading Mobile / S Bold | 17 | Headline | 17 |
| Heading Mobile / S | 17 | Headline | 17 |
| Body / L Bold | 17 | Body | 17 |
| Body / L | 17 | Body | 17 |
| Body / M Bold | 15 | Subheadline | 15 |
| Body / M | 15 | Subheadline | 15 |
| Body / S Bold | 13 | Footnote | 13 |
| Body / S | 13 | Footnote | 13 |
| Body / XS Bold | 12 | Caption 1 | 12 |
| Body / XS | 12 | Caption 1 | 12 |
| UI / L Bold | 17 | Body | 17 |
| UI / L | 17 | Body | 17 |
| UI / M Bold | 15 | Subheadline | 15 |
| UI / M | 15 | Subheadline | 15 |
| UI / S Bold | 13 | Footnote | 13 |
| UI / S | 13 | Footnote | 13 |
| UI / XS Bold | 12 | Caption 1 | 12 |
| UI / XS | 12 | Caption 1 | 12 |
| UI / 2XS Bold | 11 | Caption 2 | 11 |
| UI / 2XS | 11 | Caption 2 | 11 |
| UI / 3XS Bold | 9 | Caption 2 | 11 |
| UI / 3XS | 9 | Caption 2 | 11 |
| Caps / S Bold | 13 | Footnote | 13 |
| Caps / S | 13 | Footnote | 13 |
| Caps / 2XS Bold | 11 | Caption 2 | 11 |
| Caps / 2XS | 11 | Caption 2 | 11 |
| Number / 2XL | 48 | Large Title | 34 |
| Number / XL | 30 | Title 1 | 28 |
| Number / M | 20 | Title 3 | 20 |

## Реализация

В TUITypographyRole добавлены uiXXSmall, uiXXSmallBold, uiXXXSmall, uiXXXSmallBold, capsSmall, capsSmallBold, capsXXSmall и capsXXSmallBold. Все 31 документированные роли доступны через существующий публичный API. Числовые метрики читаются из Platform/iOS; новые визуальные значения в production-код не добавлены.

Свойство textStyle сопоставляет роли с таблицей выше. Модификатор масштабирует размер через ScaledMetric относительно соответствующего нативного стиля и убирает повторное применение tracking. Использование системного SF сохраняет прежний путь общей типографики; это не решает выбор legacy SF для существующих компонентов и распространения. Новые файлы шрифтов не добавлены.

Каталог автоматически показывает все 31 роли. Подпись к метрикам различает tracking Figma и стиль Dynamic Type.

## Межстрочный интервал: PARTIAL

В разделе iOS говорится об особом формате токенов Body и дополнительном respectsFontLineHeight. [Исходная схема](ios-line-height-source-2026-10-08.png) показывает body/xs: lineHeight = line-height.x3-5, respectsFontLineHeight = true, textStyle = Caption 1.

Значение ключа для каждой другой роли и точное правило применения нативным renderer пока UNVERIFIED. Импорт Variables не содержит этот составной ключ. При дальнейшей сверке Body обнаружено ещё одно расхождение: текущая таблица XS задаёт lineHeight 17 pt, а иллюстрация составного JSON показывает ссылку на 14 pt. API сохраняет метрики из действующей таблицы/Variables и не подменяет их значением иллюстрации.

Установлена отдельная ошибка реализации: lineSpacing вычислялся как lineHeight − fontSize, хотя point size не равен высоте нативной строки. Теперь модификатор получает UIFont с тем же системным семейством, размером и весом, масштабирует целевой lineHeight относительно исходного textStyle и добавляет max(0, scaledLineHeight − nativeFont.lineHeight). Естественный line box не уменьшается, чтобы не обрезать диакритику и descenders. Это исправление расчёта не является утверждением о полном контракте respectsFontLineHeight. Реальные расстояния между baseline проверяются отдельно для всех восьми Body-ролей в Large и AX5.

## Расхождения источника и ограничения

В таблице UI строка XS в левой колонке Text Style содержит Caption 1, а в правой колонке литерал Caption 2. Общая таблица iOS указывает Caption 1. API следует общей таблице; неоднозначность сохранена для сверки источника и не скрыта под отметкой полной приёмки.

Code/M и Code/S присутствуют в сохранённом Platform JSON, но не обнаружены среди пяти групп на прочитанной странице и в таблице iOS. Их актуальность и назначение UNVERIFIED; JetBrains Mono не подменяется системным monospaced.

Полная свежесть всех 957 Variables, визуальное совпадение всех ролей в Light/Dark, многострочный line box, реальный VoiceOver и готовность шрифтов к выпуску остаются открытыми. Системный рендер не является доказательством полного совпадения с legacy SF из Figma.

## Проверки

TypographySpecificationTests содержит независимые ожидания из таблиц: 31 роль и textStyle, веса/высоты/tracking восьми новых ролей, нативные однострочные рендеры Large/AX5 в Day/Night относительно UIFontMetrics и системного шрифта без повторного tracking, четыре обзорных нативных снимка. FoundationTokenTests проверяет все импортированные значения и поля всех публичных ролей. Результаты текущего запуска сохраняются в Documentation/Validation/2026-10-08/Typography.

Первый прогон нашёл две ошибки ожиданий теста (веса 2XS Bold и 3XS Bold были переставлены). Ожидания исправлены после чтения соответствующих строк iOS в Figma; production-токены не изменены. Первоначальный журнал сохранён в Initial/native-tests.log.

Пакет: 23 теста прошли, 0 ошибок и 0 пропусков, iPhone 17 Pro, iOS 26.4.1 (23E254a). Из них 4 FoundationTokenTests, 4 TypographySpecificationTests и 15 HeaderLargeTests. Отдельный каталог собран успешно. Доказательства: [сводка](../../Validation/2026-10-08/Typography/test-summary.json), [журнал тестов](../../Validation/2026-10-08/Typography/native-tests.log), [сборка каталога](../../Validation/2026-10-08/Typography/catalog-build.log), [вложения](../../Validation/2026-10-08/Typography/Native/manifest.json). Нативные overview-снимки просмотрены; это не парная визуальная приёмка относительно Figma.

После исправления lineSpacing выполнен новый прогон: [25 тестов прошли](../../Validation/2026-10-08/TypographyBaselines/test-summary.json) — 5 FoundationTokenTests, 5 TypographySpecificationTests и 15 HeaderLargeTests. Все проверки однострочного шрифта/масштабирования и 16 сочетаний Body/размера текста с явными переводами строки прошли. Затем [отдельный тест](../../Validation/2026-10-08/TypographyBaselines/soft-wrap-summary.json) добавил автоматические переносы: теперь проверены 32 сочетания, по каждой строке измерено расстояние между baseline через TextRenderer. Результаты и исходные суммы — [input-hashes.json](../../Validation/2026-10-08/TypographyBaselines/input-hashes.json), фактические измерения — [нативные вложения](../../Validation/2026-10-08/TypographyBaselines/SoftWrap/manifest.json). [Каталог собран с исправлением](../../Validation/2026-10-08/TypographyBaselines/catalog-build.log). Это подтверждает расчёт межстрочного интервала для проверенных Body-ролей; противоречие составного ключа в источнике и полная визуальная приёмка всех ролей остаются открытыми.

Попиксельная регрессия Header Large: [42 сопоставленных рендера](../../Validation/2026-10-08/Typography/header-large-regression.json), 40 идентичны прежней принятой версии, включая всю матрицу Day/Night. Два примера с вложенным TUILink изменились после удаления общего tracking. Их нужно отдельно сверить по Figma. Прежний complete Header Large не восстанавливается на основании одной успешной сборки; соответствующий вопрос добавлен в паспорт.

Изменение общей типографики делает прежние inputHashes затронутых компонентов неактуальными. Проверенные суммы не обновляются только для сохранения complete; повторная приёмка оформляется отдельно. Ни один компонент этим документом не объявляется complete.
