# Card Medium: приёмка независимого потребителя

Категория integration принята для текущего публичного API. `Examples/ConsumerApp` подключает локальный Swift Package `TUIDesignSystem`, не копирует реализацию, токены или ресурсы и теперь открывает `CardMediumConsumerScreen` из нативного списка. Код компонента при этой проверке не изменялся.

На iPhone 17 Pro, arm64, iOS Simulator 26.4.1 выполнен `CardMediumConsumerUITests/testIndependentCardOwnsSelectionAndPresentsNativeSheet`: **1 Passed, 0 Failed, 0 Skipped**. Точный результат — `Validation/2026-10-07/CardMediumConsumer/summary.json`; снимки и дерево доступности — `Native/manifest.json` в той же папке.

Проверено:

- Публичная карточка `badgeBottomFill` имеет размер 140×140, содержимое потребителя и значение доступности `Pro, 10%`.
- Нажатие переключает принадлежащий приложению `@State`, открывает нативную шторку и сохраняет selected после её закрытия. Второе нажатие снимает выбор.
- Статическая карточка `stackTopFill` остаётся отдельным элементом доступности без Button; исходные три логотипа загружаются из ресурсов пакета. Их наличие дополнительно проверено на реальном снимке.
- `avatarBottomFill` с notification выполняет собственное действие, сохраняет предоставленное значение доступности и не меняет выбранность первой карточки.
- Выполнен системный аудит elementDetection, sufficientElementDescription и trait. Это не заменяет полную приёмку доступности, реальные увеличенные размеры текста и прослушивание VoiceOver.

Отдельное приложение собралось через схему `TUIConsumer`; сохранён `Validation/2026-10-07/CardMediumConsumer/build.log`. Каталог и пакет собраны в составе UI-прогона: `test.log`. Шесть тестов API/матрицы пакета из `Validation/2026-10-06/CardMediumFontOverride/summary.json` сохраняют применимость: реализация, ресурсы и эти тесты после того результата не изменялись. Их успешный результат не объявляется новым прогоном 7 октября.

## Ошибка первого прогона

Первый общий прогон дал 3 Passed и 1 Failed. Card-тест ошибочно искал статическую карточку как `StaticText`; сохранённое дерево показало объединённый элемент `Other` с нужной меткой. Исправлен только класс запроса в тесте. Действия, selected, sheet и аудит в первом прогоне уже выполнялись, но весь Card-тест всё равно считается Failed. Повторный Card-прогон завершился Passed. Первый результат сохранён в `Validation/2026-10-07/ConsumerNavigationRegression/first-run-summary.json`; диагностическое дерево — `CardMediumConsumer/first-run-accessibility-tree.txt`.

После изменения меню потребителя отдельно прошли два сценария Header (ссылки/состояние/пять режимов размеров и baseline accessory) и существующий сценарий Like/Share. Их индивидуальные результаты находятся в `ConsumerNavigationRegression/first-run-tests.json`. Общий первый запуск не переименовывается в успешный.

## Воспроизведение

Из корня проекта, с существующим на этом компьютере симулятором:

```sh
xcodebuild -project Examples/ConsumerApp/TUIConsumer.xcodeproj \
  -scheme TUIConsumer -configuration Debug \
  -destination 'platform=iOS Simulator,id=6D3F35A1-AC30-4F0E-BDD6-0F912B714E59' \
  -derivedDataPath /private/tmp/tui-consumer-card-medium-derived \
  -skipPackageUpdates CODE_SIGNING_ALLOWED=NO build
xcrun simctl install 6D3F35A1-AC30-4F0E-BDD6-0F912B714E59 \
  /private/tmp/tui-consumer-card-medium-derived/Build/Products/Debug-iphonesimulator/TUIConsumer.app
xcodebuild -project TUIDesignSystemCatalog.xcodeproj \
  -scheme TUIDesignSystemCatalogUITests \
  -destination 'platform=iOS Simulator,id=6D3F35A1-AC30-4F0E-BDD6-0F912B714E59' \
  -derivedDataPath /private/tmp/tui-card-medium-ui-derived \
  -skipPackageUpdates CODE_SIGNING_ALLOWED=NO \
  -only-testing:TUIDesignSystemCatalogUITests/CardMediumConsumerUITests test
```

На другом компьютере необходимо выбрать имеющийся симулятор iOS 26. Это приёмка использования компонента через публичный API, а не совпадения полного экрана с Figma, удалённой установки из GitHub или готовности всего набора. Card Medium остаётся `in-progress`: specification, visual и полная accessibility ещё не завершены.
