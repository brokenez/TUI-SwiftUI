# Button: загрузка, нативные действия и accessibility-дерево

Исходные требования: [States 81:48109](https://www.figma.com/design/HErJrp1BcNRUFCyg3QccuG/tui-button?node-id=81-48109), [Accessibility 25085:11903](https://www.figma.com/design/HErJrp1BcNRUFCyg3QccuG/tui-button?node-id=25085-11903). Полный исходный PDF и просмотренная таблица находятся в [отчёте чтения](construction-accessibility-review-2026-10-08.md).

## Исправление

Loading озвучивается label «Идет загрузка», а не исходным названием с value «Загрузка». Нативная кнопка остаётся enabled: признак «Недоступно» предусмотрен источником для disabled, но отсутствует в строке loading. Повторное действие блокируется в общем обработчике. Disabled и skeleton сохраняют блокировку нативного Button.

После loading код отправляет announcement исходного названия только если на кнопке остаётся VoiceOver-фокус. Для отслеживания используется нативный AccessibilityFocusState; он подключается только при активном системном VoiceOver. Успешная сборка этого кода не доказывает фактическое сохранение фокуса или полное озвучивание trait/hint: эти проверки остаются pending.

Публичные параметры и существующий модуль не изменены. DEBUG-пример `ButtonInteractionProbe` импортирует настоящий TUIButton из пакета; отдельной реализации кнопки в каталоге нет.

## Реальные проверки

Каталог запущен на iPhone 17 Pro, iOS Simulator 26.4.1 (23E254a), Xcode 26.4.1, Debug. [Шесть UI-тестов](../../Validation/2026-10-08/ButtonInteraction/catalog-ui-test-summary.json) проверяют:

- Normal и явный Pressed выполняют действие; повторное обычное нажатие работает.
- Loading имеет label «Идет загрузка», пустой value, тип Button и enabled; действие не повторяется, после завершения вновь выполняется.
- Disabled и skeleton имеют disabled и не выполняют действие.
- Normal → loading → normal сохраняет идентификатор и размеры во всех трёх размерах в Day/Night; повторное нажатие во время загрузки не увеличивает счётчик, после завершения счётчик вновь увеличивается.
- Увод пальца за пределы Small отменяет нажатие; последующее обычное нажатие работает.
- Icon-only имеет содержательный label «Добавить документ», остаётся нативной кнопкой 56 × 56 и выполняет действие.

Снимки и accessibility-деревья экспортированы в [Native/manifest.json](../../Validation/2026-10-08/ButtonInteraction/Native/manifest.json). Команда и полный лог: [catalog-ui-test.log](../../Validation/2026-10-08/ButtonInteraction/catalog-ui-test.log). Автоматизация обращается к `app.buttons`: проверен тип доступного элемента; VoiceOver-аудио не прослушано.

После исправления проходят [14 package-тестов](../../Validation/2026-10-08/ButtonInteraction/package-test-summary.json): 2 ButtonColorTests, 7 ButtonTests, 5 FoundationTokenTests. Проверены 270 фоновых и 198 текстовых случаев Day/Night, размеры, Dynamic Type, загрузка, иконка/отступы и исходные токены. [Восемь RGBA-снимков](../../Validation/2026-10-08/ButtonInteraction/render-regression-comparison.json) совпадают с последней проверенной версией ButtonTheme; это проверка отсутствия регрессии, а не сравнение всей матрицы с Figma. Проверенные файлы перечислены в [input-hashes.json](../../Validation/2026-10-08/ButtonInteraction/input-hashes.json).

## Выявленные и устранённые сбои проверки

- Первоначально выбрана обычная схема приложения без TestAction. Схема не изменялась: запуск переключён на существующую TUIDesignSystemCatalogUITests. Ошибка сохранена в `initial-wrong-scheme.log`.
- Постоянный нативный focus bridge мешал offscreen ImageRenderer: 6 тестов падали, 8 проходили. Сохранены `initial-package-focus-render-failure.log` и `initial-package-test-summary.json`. Подключение фокуса только при активном VoiceOver восстановило 14 тестов и все 8 прежних снимков.
- Попытка принудительно включить VoiceOver EnvironmentValues в тестовом примере не компилируется: ключ read-only. Подмена удалена; сохранён `voiceover-environment-readonly-build-failure.log`. Принудительная среда не выдаётся за реальный VoiceOver.

## Открытая приёмка

Озвучивание и hint VoiceOver, сохранение/возврат фокуса после загрузки, полный порядок фокуса и связанные общие требования доступности — UNVERIFIED. Нативные UI-тесты выполнены для primary, со всеми состояниями/размерами, но не являются самостоятельной приёмкой всех дополнительных свойств и 147 визуальных вариантов. Параметры кастомных иконок, отдельных цветов и радиуса ещё отсутствуют; отдельный Component Set [two labels] имеет собственную приёмку. Glass, профиль fade, шрифты и движение loader также остаются открытыми. Семь проверок компонента не объявлены завершёнными.
