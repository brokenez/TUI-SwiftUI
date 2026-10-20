# Button: публичная кастомизация и сопоставление с Figma

Проверка 8 октября 2026, iPhone 17 Pro, iOS Simulator 26.4.1 (23E254a), Xcode 26.4.1. Это приёмка сопоставления API и частичная проверка реализации; полный Button остаётся **in-progress**.

## Источники и контракт

Набор [TUI Mobile 41658:296906](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=41658-296906) содержит 294 варианта: 147 iOS и 147 Android. Цель библиотеки — iOS 26; Android не реализуется. Сохранены исходные имена и значения свойств. Дополнительное чтение MCP [129:27042](https://www.figma.com/design/HErJrp1BcNRUFCyg3QccuG/tui-button?node-id=129-27042) сохранено в [fresh context](../../Inventory/2026-10-08/button-customization-fresh-mcp.json). Прочитанные правила размеров, радиуса, цветов и двух лейблов — в [исходном отчёте](additional-features-review-2026-10-08.md); его описание отсутствующего API относится к версии до этого изменения.

[Сопоставление всех instance properties](../../Validation/2026-10-08/ButtonCustomization/instance-property-map.json) содержит исходные определения, включая значения по умолчанию и область применения. Базовые variant IDs сопоставлены в component-verification.json.

| Свойство Figma | Публичный Swift API | Правило |
| --- | --- | --- |
| Text#41658:28 | title | По умолчанию в исходнике Label; текст экземпляра берётся из макета |
| show-Icon#41658:14 | showsIcon | Исходное значение false |
| show-label#41658:21 | showsLabel | Исходное значение true |
| Icon#41658:0 | icon | Только Large/Medium; nil сохраняет исходную звезду |
| Icon (16)#41658:7 | smallIcon | Только Small; независимая замена, nil сохраняет исходную звезду |
| size | TUIButtonSize | large, medium, small |
| appearance | TUIButtonAppearance | Все 12 исходных значений, rawValue сохраняет дефисы |
| state | TUIButtonState | normal, pressed, loading, disabled |
| skeleton | skeleton | off → false, on → true; только 3 исходных Primary combinations |
| system | Платформа пакета | Исходный ios → iOS 26; android исключён |

Каждый из 147 базовых вариантов имеет точный публичный figmaNodeID. Для несуществующей комбинации, например Flat со Skeleton, он возвращает nil; такую комбинацию запрещено выдавать за исходный вариант. Figma Component Set ID доступен как TUIButton.figmaComponentSetID.

[Кастомизация 129:27042](https://www.figma.com/design/HErJrp1BcNRUFCyg3QccuG/tui-button?node-id=129-27042) разрешает фон, отдельные цвета текста и иконки, замену иконки и ширину. API: backgroundColor, textColor, iconColor, icon, smallIcon и width. nil сохраняет исходный стиль. Цвет текста не перекрашивает иконку. Для фиксированного цвета/многоцветной иллюстрации используется iconRenderingMode: .original; у template применяется iconColor. Проверена синтетическая многоцветная иллюстрация, а не все фиксированные исходные ассеты.

По [правилу радиуса iOS 17369:7059](https://www.figma.com/design/HErJrp1BcNRUFCyg3QccuG/tui-button?node-id=17369-7059) cornerRadius задаёт реальный контур. Source rule [17369:7090](https://www.figma.com/design/HErJrp1BcNRUFCyg3QccuG/tui-button?node-id=17369-7090) разрешает круглый Large/Medium, Small уже круглый. В каталог добавлено соответствующее управление TUIRadius.round; произвольные новые стили не объявлены специфицированными.

width задаётся до фоновой заливки, clipping и hit shape, поэтому меняет реальную кнопку, включая Small и icon-only. При nil Large/Medium с текстом заполняют доступную ширину, Small сохраняет естественную ширину. Числа width в variantMappings и веб-примерах воспроизводят ширину исходного демонстрационного фрейма. При сборке другого экрана читать ширину и Hug/Fill/Fixed исходного экземпляра, не копировать ширину базового варианта автоматически.

Иконка занимает исходный слот 24/24/16 pt. Крупное изображение пропорционально уменьшается до слота, маленькое сохраняет естественный размер; на AX1 слот увеличивается 1,25×. Состояние и действие принадлежат приложению. Loading сохраняет геометрию и доступный Button с label «Идет загрузка», подавляя повторное действие.

## Пакет и демонстрации

[TUIResources.bundle](../../../Sources/TUIDesignSystem/Foundation/TUIResources.swift) открывает ресурсы Swift Package потребителю. Точные уже экспортированные ассеты используются через Image с этой bundle; потребитель не копирует реализацию или изображения. Это доступ к существующим ресурсам, а не заявление о выгрузке всей TUI Assets.

В нативном каталоге используются настоящий TUIButton, независимые icon pickers для Small и Large/Medium, token pickers фона/текста/иконки, радиус Large/Medium и ширина. [Независимый consumer](../../../Examples/ConsumerApp/App/ButtonConsumerScreen.swift) импортирует только публичный модуль, меняет размер, использует изображения из bundle и управляет loading. Его три снимка и AX tree сохранены в ConsumerNative.

## Выполненные проверки

- [22 package-теста](../../Validation/2026-10-08/ButtonCustomization/package-test-summary.json) прошли: точные 147 IDs, независимые instance swaps и цвета, oversize/undersize иконок, Large/AX1/AX5, реальная ширина/радиус, многоцветный original и фактическая отрисовка четырёх ресурсов.
- 135 вариантов без Glass отрисованы в Day/Night @3x: **270 runtime PNG**, реальные размеры сравнены с исходными variant frames. [Связи variantID/theme](../../Validation/2026-10-08/ButtonCustomization/variant-renders.json). Эти PNG не заменяют сравнение с Figma.
- [8 прежних runtime-boards](../../Validation/2026-10-08/ButtonCustomization/default-render-regression.json) сохранили точное RGBA-совпадение, включая loading и Dynamic Type в обеих темах. Это регрессия реализации, не приёмка визуального совпадения Figma.
- В комбинированном запуске прошли **7 тестов Button** каталога. Восьмой тест consumer тогда упал из-за неустановленной актуальной версии. [Итог смешанного запуска](../../Validation/2026-10-08/ButtonCustomization/catalog-ui-test-summary.json) остаётся Failed, его нельзя выдавать за полный успех.
- Исправлена последовательность boot/install перед проверкой consumer. Повторная проверка выявила неверное ожидание AX label у нативного LabeledContent: фактическое «Нажатий, N» вместо «N». Исправлен тестовый oracle, компонент не менялся. [Финальный отдельный consumer test](../../Validation/2026-10-08/ButtonCustomization/consumer-ui-test-summary.json) прошёл: 1 тест, три размера, ширина 280, действие, loading guard и восстановление.
- Потребитель собран, каталог собран в UI-тестовом запуске. Команды и результаты — package-test.log, catalog-ui-test.log, consumer-build.log, consumer-ui-test.log.
- **285 копируемых SwiftUI-примеров**, включая 147 Button, скомпилированы и проверены одним [тестом веб-примеров](../../Validation/2026-10-08/ButtonCustomization/web-examples-test-summary.json); это 1 test case с проверками примеров, а не 285 тестов.

## Открытая приёмка

Полное попарное сравнение 147 вариантов с Figma, Glass на содержательном фоне, тень Floating, fade-профиль, оставшиеся разделы usage/editorial/masking, точная анимация Loader/Reduce Motion и реальное озвучивание VoiceOver остаются pending. Решение о версии и распространении SF fonts не получено; шрифты здесь не заменялись. Для custom colors поведение pressed/disabled и все допустимые исходные комбинации ещё не принято. Наличие API не подтверждает их полную визуальную/поведенческую приёмку. Two labels — самостоятельный set 51388:47169.

Базовая матрица/API проверена отдельно. Остальные шесть категорий полного паспорта остаются pending. inputHashes полного acceptance не обновляются ради статуса; [локальные контрольные суммы этого этапа](../../Validation/2026-10-08/ButtonCustomization/input-hashes.json) фиксируют фактически проверенные версии.

Изменение entry point consumer сделало прежние интеграционные input hashes Card Medium/Header устаревшими. Предыдущий consumer entry сохранён как архив с его исходным SHA256; исторические evidence ссылаются на эту неизменную копию. Это не новая приёмка прежних экранов.
