# Header Card: центрирование и повторная проверка

В исходной композиции Card Large `44231:308359` колонка Header+Subheader имеет `justify-center` и `self-stretch`. Если Subheader скрыт, заголовок высотой 24 pt должен центрироваться рядом с аватаром 40 pt. Ранее он оставался у верхнего края. Исправление в публичном Header Card ограничено растяжением колонки через `frame(maxHeight: .infinity, alignment: .leading)`; шрифты, токены и отступы не менялись.

Тест `testTitleCentersInsideTallerAvatarWhenSubheaderIsHidden` проверяет реальный рендер 375×68 pt: область текста Avatar при y=24 совпадает по пикселям с областью None при y=16. Разница 8 pt соответствует центрированию 24 pt внутри 40 pt. Источник сохранён в `References/CardLarge/composition-44231-308359-2026-10-07.txt`.

На iPhone 17 Pro / iOS 26.4.1 прошли все шесть HeaderCardTests. Все 16 стандартных Day/Night изображений совпали по пикселям с предыдущим прогоном. Доказательства: `Validation/2026-10-07/HeaderCardCenteredColumn/summary.json`, `mcp-result.json`, `test.log`, `manifest.json` и `baseline-regression.json`.

После исправления отдельное приложение потребителя пересобрано. Свежий общий прогон прошёл полностью: три HeaderCardConsumerUITests, два HeaderCardUITests и один CardLargeUITests, всего 6/6. Он проверяет матрицу, Button/Link, writable Switch, disabled-состояния, дополнительные действия ссылок и подсказки, независимость действий карточки. Чистые Day/Night снимки Switch получены в активной сцене, без имитации UIKit-контрола в ImageRenderer. Доказательства: `Validation/2026-10-07/HeaderCardCenteredIntegration/mcp-result.json`, `test.log`, `build.log`, `manifest.json` и приложения к ним.

Экспорт отдельной xcresult-сводки этого UI-прогона не выполнен: сервис автоматической проверки разрешений вернул 403. Сохранён оригинальный структурированный результат XcodeBuildMCP со статусом SUCCEEDED и шестью именованными Passed тестами; журнал подтверждает 6 tests / 0 failures. Он не выдаётся за экспорт xcresulttool. В журнале есть служебное предупреждение об отсутствии AppIntents.framework; ошибок и проваленных тестов нет.

Обновлены контрольные суммы Header Card и его тестов на основании этих прогонов. Принятые `variantMapping` и `integration` сохраняются. Полная спецификация, визуальная приёмка типографики и дополнительных состояний, физический Hint/слоты, полный порядок VoiceOver и motion остаются pending. Центрирование и успешные тесты не означают принятие всего набора.
