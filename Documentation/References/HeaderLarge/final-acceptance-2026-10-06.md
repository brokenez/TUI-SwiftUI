# Header Large: итоговая приёмка iOS 26

Принят набор `42565:305012`: все десять применимых вариантов сопоставлены с `TUIHeaderLarge.Variant` и сверены визуально. Текущий пакет: 70 Passed, 0 Failed; полный изолированный UI-прогон: 11 Passed, 0 Failed. Пакет, самостоятельный каталог и независимый потребитель собраны из текущих исходников. Это приёмка одного набора, а не всей системы или полного экрана зарплатного клуба.

## Требования спецификации

Источник компонента — TUI Mobile `OBPLqL8JDThLuOP8M4JzBL`, набор `42565:305012`. Спецификация — `Vt4htBIFAjKUg8c547G0Ez`, страница `15:9185`; guide сложного fade — `eppql368TOxnGcRsGWVA0V`, иллюстрация `1443:5467`. Контексты разделов сохранены рядом с отчётом. Правило ссылок `4298:14488` повторно прочитано live в `spec-links-live-2026-10-06.txt`.

| Требование источника | Реализация и доказательство |
| --- | --- |
| Полная применимая матрица description/subheader, start/center, skeleton, extended | Десять значений `Variant`, точные `variantMappings`, тест матрицы, десять исходных PNG-пар |
| Large — основной заголовок экрана (`46:84021`), legacy Heading L | SF Pro Display Bold 30, tracking +0.36, строка 36, baseline 29. Проверены исходные размеры/векторы и `testExactLegacyFontFacesTrackingAndAX1Cap`; современная роль Mobile/L не подменяет legacy |
| Основной description и вторичный subheader (`1174:6592/6593`) | SF Pro Text Regular 17/15, tracking −0.41/−0.24, строки 20/18, `TUIColor.textPrimary/textSecondary`. Матрица и исходный token audit |
| Padding 8/16/24/16, gap текста 16; extended слоты 16 и gap 10 | Отступы через `TUISpacing`; исходные метрики слотов документированы. Текущие размеры 375×104/102, без subheader 375×68; два extended-варианта сверены |
| Цвет, начертание, размер (`46:83490`); кастомные отступы (`169:13762`) | `textStyles` принимает Foundation role, UIFont, lineHeight, color/tracking; `contentInsets` задаёт EdgeInsets. Тест явного UIFont 24 medium/lineHeight 30 и Foundation headingMedium; setters проверены по коду |
| Центрирование без accessories (`46:82795`) | Четыре centered-варианта, включая skeleton, сверены; правило использования записано в документации |
| Произвольный правый контент (`12787:8147`), mobile gap 16 (`12787:8518`) | `accessory` builder; состояние принадлежит приложению. Реальный Toggle 0→1→0 и настоящий Link в потребителе |
| Центр первой строки для badge/toggle/button, baseline для Link (`12787:8457/8491`); независимое выравнивание (`12787:8513`) | `firstLineCenter` по умолчанию, явный `firstBaseline` для Link, отдельные `textSlotAlignments`. Пять положений слотов проверены по геометрии; native PDF подтверждает Link baseline 37 от верха |
| Иконки/badge в Title/Subtitle/Description (`46:83504`) | Inline Text либо prefix/suffix/custom-content builders. Native inline-image перенос, отдельный suffix и живой inline-символ проверены |
| Однострочный fade сохраняет suffix (`5233:16600`) | `singleLineFade`, suffix вне маски. Тест его геометрии; UI подтверждает полный label и bounded focus |
| Многострочная inline-иконка — символ внутри fade (`5233:16605`, guide `1443:5467`) | Native Text interpolation, `multilineFade(lineLimit:)`, маска последней строки. Проверены inline-image, неизменность предыдущих строк, естественная высота короткого текста и продолжение последней строки без многоточия |
| Явный новый абзац не склеивается с ограниченной строкой | Native CharacterIndex ranges и `testMultilineFadeDoesNotContinueAnExplicitNewParagraph` |
| Увеличение до AX1; сохранение overflow (`12417:9919/9921/9922`) | UIFontMetrics и cap AX1. Метрики AX1/AX5 совпадают; пять живых UI-режимов |
| Reflow opt-in, по умолчанию off; accessory после всего текста с gap 8, проверка на ширине 375 (`12417:9925/9926`) | `accessory(reflowsAtAX1:)`, description также предшествует accessory. Проверены порядок, gap и AX5 cap |
| Ссылки в title/subheader/description (`80:20276`) | AttributedString; обычные native hit regions и исправленные регионы продолженного fade. Физические ссылки работают; обычные glyphs не превращены в ссылку |
| Полный текст и дополнительные действия вложенных ссылок (`4298:14488`) | Общий `TUIHeaderLinkedTextAccessibility`. Title+subheader — один heading с header trait и двумя действиями; description — отдельный полный элемент с действием. UIKit snapshots и реальное выполнение трёх различных URL |
| Accessory отдельно от heading; декоративные элементы не озвучиваются | Нативный Toggle/Link; avatar/placeholder скрыты от доступности. Пройдены штатные elementDetection/sufficientElementDescription/trait аудиты |
| Skeleton заменяет текст (`84:17194`) и не озвучивается | Четыре исходных skeleton-варианта через принятый `TUISkeletonText`. В полном UI-прогоне проверены настоящий Reduce Motion, фон/возврат и повторное появление |
| Чувствительный режим — внешний компонент поверх текста (`84:17193`) | `titleContent`/`secondaryContent` принимают внешнюю композицию; контракт замены проверен по коду. Сам sensitive-mode остаётся отдельным обязательным набором и не объявляется готовым этой приёмкой |
| Весь Header ссылкой — только desktop (`80:20282`) | Исключено из iOS API по явному правилу платформы |

Все пять исходных text/boolean свойств сопоставлены. Отсутствующие привязки title/description/show-icon у `18083:44906` сохранены в `sourceBindingExceptions`: потребитель читает фактические characters/visibility, а не угадывает содержание по свойству.

## Визуальная сверка текущего кода

`HeaderLargeFullAcceptanceComparison3x/comparison.json` сравнивает десять новых Day кадров непосредственно с исходными Figma PNG 3x, без сдвигов, перекрашивания или изменения tracking. Просмотрен полный contact sheet. Геометрия, строки, baseline, шрифты и композиция соответствуют источнику. Среднее RGB-отличие 0–0.5405/255; различия сглаживания на контурах сохраняются, как описано в `visual-review-2026-10-06.md`. Это не побитовое равенство Figma/Core Text.

`header-large-full-acceptance-native-regression.json` подтверждает полное равенство декодированных RGBA всех двадцати новых Day/Night кадров предыдущей принятой нативной матрице. Прежние проверки цветов по Foundation modes и исходных контуров применимы к текущему коду. Night Figma PNG отдельно не экспортировался: Night проверен по токенам и нативному исполнению, отдельно от Day сравнения с Figma.

Последняя строка multiline fade продолжена без многоточия. Её пиксели проверены против непрерывного native single-line текста; иллюстрация источника просмотрена на предыдущем этапе. Текущий пакет также проверяет inline-image, предыдущие строки, явные абзацы и естественную высоту короткого текста.

## Доступность и публичный контракт

Первичная диагностика обычной ссылки выявила отсутствие дополнительных действий у полного heading; Failed summary и UIKit snapshot сохранены в `HeaderLargeStandardLinkInitial`. Исправление перенесено в общий модификатор всех overflow. Текущие нативные действия title/subheader/description реально вызывают обработчик своего URL. Диагностические кнопки явно различаются по button trait и не выдаются за дочерние текстовые ссылки. Встроенные ссылки не создают невидимых отдельных фокусов скринридера. Физические действия обычных ссылок и видимого фрагмента fade также прошли.

Проверены публичный UIKit accessibility bridge, полные labels, traits, границы, действия и их выполнение. Звуковой вывод VoiceOver отдельно не прослушивался. Штатный аудит трёх указанных категорий дополняет эти проверки; не заявляется аудит всех возможных категорий.

Для вложенных URL используйте AttributedString. `titleInlineText(Text)`/`secondaryInlineText(Text)` предназначены для native композиции с inline-символом: непрозрачные URL внутри произвольного Text не анализируются. Произвольные `titleContent`/`secondaryContent` принадлежат потребителю вместе с типографикой, overflow и доступностью. Приёмка не обещает автоматического восстановления семантики произвольного View. Отдельные sensitive-mode, tooltip и другие компоненты принимаются собственными паспортами.

## Текущие доказательства

- `Documentation/Validation/2026-10-06/header-large-full-acceptance-package-summary.json`: 70 Passed.
- `Documentation/Validation/2026-10-06/header-large-full-acceptance-ui-summary.json`: 11 Passed.
- `Documentation/Validation/2026-10-06/HeaderLargeFullAcceptanceNative/manifest.json`: матрица Day/Night, inline/fade, reflow и PDF.
- `Documentation/Validation/2026-10-06/HeaderLargeFullAcceptanceUI/manifest.json`: ссылки, UIKit действия, Toggle, системное движение, reflow и каталог.
- `Documentation/Validation/2026-10-06/HeaderLargeFullAcceptanceComparison3x/comparison.json`: десять актуальных пар Figma/native.
- `Documentation/Validation/2026-10-06/header-large-full-acceptance-native-regression.json`: равенство двадцати новых и ранее принятых нативных кадров.

Семь категорий паспорта закрыты перечисленными доказательствами и исходными контекстами. Контрольные суммы включают новый TUIHeaderTextLinks, UIKit probe и текущие исходники потребителя/тестов. Complete вычисляет общий генератор после обновления паспорта. Остальные наборы и проверочный экран остаются в работе.
