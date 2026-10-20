# Header Large: влияние нового пункта меню потребителя

В `Examples/ConsumerApp/App/TUIConsumerApp.swift` добавлен единственный NavigationLink на существующий публичный пример Card Medium. Маршрут `--header-consumer`, HeaderConsumerScreen, реализация Header, общая типографика, ресурсы, размеры и тесты Header не менялись.

Повторно проверено влияние изменения точки входа на интеграцию Header: `testIndependentHeaderLinksStateAndAX1Reflow` и `testIndependentBaselineLinkAccessoryExecutesConsumerAction` прошли на iPhone 17 Pro, arm64, iOS Simulator 26.4.1. Первый сценарий проверяет ссылки, состояние и пять режимов размера/переноса, включая ограничение AX1; второй — действие baseline accessory. Существующий потребитель Like/Share также прошёл.

Индивидуальные результаты сохранены в `Validation/2026-10-07/ConsumerNavigationRegression/first-run-tests.json`, снимки/деревья — в `Native/manifest.json`. Общий прогон имеет статус Failed из-за ошибочного типа запроса статической карточки в новом Card-тесте. Эта ошибка не скрыта и не переносится на индивидуально прошедшие Header-сценарии. После исправления запроса Card-тест отдельно прошёл; результат — `Validation/2026-10-07/CardMediumConsumer/summary.json`.

Обновлена только проверенная версия точки входа в паспорте Header и добавлено доказательство integration. Остальная приёмка 6 октября сохраняется на неизменённых исходниках; это не утверждение, что все её тесты повторялись 7 октября. Готовность распространяемого шрифта остаётся отдельным открытым вопросом выпуска, зафиксированным в плане библиотеки.
