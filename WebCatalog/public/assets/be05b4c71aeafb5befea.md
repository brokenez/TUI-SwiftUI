# Button Medium: Hug / Fill

Источник требования: [Mobile 26:72691](https://www.figma.com/design/HErJrp1BcNRUFCyg3QccuG/tui-button?node-id=26-72691). Medium 44 pt разрешено использовать по ширине содержимого или родителя. Контекст и диаграммы прочитаны до проверки. [Дополнение к чтению источника](../../../References/Button/source-review-followup-2026-10-08.md) сохраняет остальные правила и ограничения приёмки.

Текущий публичный `TUIButton` уже реализует оба режима. Hug — `.fixedSize(horizontal: true, vertical: false)`, Fill — существующая ширина родительского контейнера. API и реализация `TUIButton.swift` на этом этапе не менялись. В живой playground добавлен нативный segmented picker «На всю ширину / По содержимому» только для Medium; при явно заданной ширине picker выключен. Новая кастомная layout-система не нужна.

## Результат

- Пакет: **2 tests passed**, [package-tests.log](package-tests.log). Hug проверен в 32 комбинациях: Day/Night × иконка/без × два текста × normal/pressed/loading/disabled. Высота 44 pt; ширина содержимого не меняется при loading. Fill проверен в 24 комбинациях: Day/Night × 180/240/323 pt × четыре состояния.
- Живой iOS-каталог: **1 UI test passed**, [catalog-ui-tests.log](catalog-ui-tests.log). Из списка открывается обычный Button, выбирается Medium, переключается реальный контейнер Fill → Hug, вызывается действие, выбирается loading, ширина Hug сохраняется; возврат к Fill восстанавливает полную ширину. На снимке normal виден результат действия «Нажатий 1». Это проверка обычного взаимодействия через UI-идентификаторы, не VoiceOver-аудит.
- Сборка пакета и каталога прошла в этих тестовых запусках. Xcode 26.4.1, iPhone 17 Pro, iOS Simulator 26.4.1, destination 6D3F35A1-AC30-4F0E-BDD6-0F912B714E59. Размер текста обычный `.large`; увеличенные accessibility-шрифты не проверялись.
- Сохранены 32 нативных пакетных PNG: [manifest](PackageNative/manifest.json), и 3 снимка живого каталога с диагностическими UI-деревьями: [manifest](NativeUI/manifest.json). Три снимка каталога просмотрены визуально. Деревья используются для подтверждения контроля и действия, без новой реализации accessibility.
- Свежая исходная матрица содержит все **147** импортированных iOS-вариантов с теми же ID, свойствами и размерами: [source-matrix-comparison.json](source-matrix-comparison.json). Сравнение metadata не заменяет проверку потомков/изображений.

Проверенные команды:

```sh
xcodebuild -workspace PackageTests.xcworkspace -scheme TUIDesignSystemTests -destination 'platform=iOS Simulator,id=6D3F35A1-AC30-4F0E-BDD6-0F912B714E59' -derivedDataPath /private/tmp/tui-foundations-audit-derived -skipPackageUpdates -only-testing:TUIDesignSystemTests/ButtonLayoutTests CODE_SIGNING_ALLOWED=NO test
xcodebuild -project TUIDesignSystemCatalog.xcodeproj -scheme TUIDesignSystemCatalogUITests -destination 'platform=iOS Simulator,id=6D3F35A1-AC30-4F0E-BDD6-0F912B714E59' -derivedDataPath /private/tmp/tui-typography-catalog-derived -skipPackageUpdates -only-testing:TUIDesignSystemCatalogUITests/ButtonInteractionUITests/testCatalogMediumHugFillAndLoadingRetainActualContainer CODE_SIGNING_ALLOWED=NO test
```

## Границы

Этот этап принимает поддержку адаптивной ширины Medium через существующий API и управление ею в каталоге. Он не принимает все 147 Button-вариантов, blur/shadow/fade, полную типографику, маскирование или точное движение loading. Статические снимки loading не доказывают длительность и easing. Полный Button остаётся in-progress. Оригинальные Figma-файлы не изменялись.
