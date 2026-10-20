# Foundations: Color, Size, Shadow, Animation

Источники прочитаны через Figma Desktop MCP 8 октября 2026. Оригинальный файл не изменён. Это извлечение правил и частичная проверка API; полный визуальный acceptance Foundations ещё не завершён.

## Color

Прочитаны [Коллекции, 678:13747](https://www.figma.com/design/gGt4PaQxQhX7ozPVImsgL5/TUI-Foundations?node-id=678-13747), [Структура, 678:13591](https://www.figma.com/design/gGt4PaQxQhX7ozPVImsgL5/TUI-Foundations?node-id=678-13591), [Представление в коде, 6859:4909](https://www.figma.com/design/gGt4PaQxQhX7ozPVImsgL5/TUI-Foundations?node-id=6859-4909), [Day/Night, 1000:6872](https://www.figma.com/design/gGt4PaQxQhX7ozPVImsgL5/TUI-Foundations?node-id=1000-6872), [FAQ, 678:13536](https://www.figma.com/design/gGt4PaQxQhX7ozPVImsgL5/TUI-Foundations?node-id=678-13536), [Нейминг, 18272:36200](https://www.figma.com/design/gGt4PaQxQhX7ozPVImsgL5/TUI-Foundations?node-id=18272-36200).

Семантические токены должны применяться по назначению группы и scoping. Background относится к поверхности; Text — к тексту и допустимым в источнике поверхностям. Значения с модификаторами On Light/On Dark не меняются при смене темы. Применение подходящего уровня Background в Day важно для корректного уровня в Night: в Night разделение уровней создаётся цветом, тени выключаются. Border/Darkmode Only используется для дополнительного контраста изображений и бледных поверхностей: в Day прозрачен, в Night виден.

Theme выбирает Day/Night, Platform — платформенные значения, Primitive — конечные примитивы. Одинаковые между платформами семантические токены могут ссылаться сразу на Primitive. По умолчанию Figma использует Auto (Day); изменение режима фрейма переключает тему.

Градиенты и другие составные стили не представлены целиком обычными Variables. В источнике указаны Gradient/Text, Gradient/Brand, Gradient/Overlay, Gradient/Mask и Service/Map. Наличие 957 Variables не доказывает полноту этих стилей. У градиента есть color, position и angle; для полного перекрытия контейнера под углом крайние позиции могут выходить за его границы. Реализация всех таких стилей пока UNVERIFIED.

SwiftUI-потребитель использует TUIColor. Проверка конкретных Day/Night цветов с alpha выполнена ранее и повторяется после изменений. Весь текущий platform/theme alias graph и все составные стили требуют отдельной актуализации; тест чтения импорта не доказывает свежесть каждого значения относительно Figma.

## Size

Прочитан [Размеры экрана, 1349:2112](https://www.figma.com/design/gGt4PaQxQhX7ozPVImsgL5/TUI-Foundations?node-id=1349-2112) на странице 2. Size (1348:2099). В текущей странице наблюдается этот единственный верхний фрейм.

| Переменная | iOS | Android | Desktop |
| --- | --- | --- | --- |
| Size / Screen Width | 375 | 360 | 1360 |
| Size / Screen Height | 812 | 800 | 800 |

Это размеры рабочих фреймов Figma для переключения платформ. Они не задают фиксированный экран устройства в SwiftUI: приложение должно раскладываться в доступной области текущего устройства. Страница не является подтверждением всей шкалы TUISpacing/TUIRadius/TUIControlSize. Для их принятия нужны соответствующие компоненты и bindings Variables; не выводить радиусы кнопок из размера экранного фрейма.

## Shadow

Прочитан [Тени, 2872:5946](https://www.figma.com/design/gGt4PaQxQhX7ozPVImsgL5/TUI-Foundations?node-id=2872-5946), включая схемы. Параметры общие для Desktop/Mobile. Small — небольшие элементы, например Chip/Tooltip; Medium — карточки и крупные объекты; Popup — попапы. Small Hover и Medium Hover относятся к Desktop и не добавляются в iOS API. Тени автоматически отключаются в Night.

| Токен iOS | Day: alpha чёрного | Blur | Y-axis | Night |
| --- | --- | --- | --- | --- |
| Small | 0.10 | 20 | 5 | alpha/blur/offset 0 |
| Medium | 0.12 | 34 | 6 | alpha/blur/offset 0 |
| Popup | 0.14 | 40 | 10 | alpha/blur/offset 0 |

Определения из текущего фрейма сохранены в foundations-shadow-definitions-mcp.json в Documentation/Inventory/2026-10-08. В публичный TUIShadow добавлены mediumColor, mediumBlur(theme:) и mediumYOffset(theme:). Они читают существующие исходные Variables, дополнительных визуальных констант не вводят. Small/Popup продолжают существовать.

Blur здесь — значение Figma-токена. Оно не доказывает численную эквивалентность параметру SwiftUI shadow(radius:). Нативные тени нужно сравнивать с source-render; полноценная проверка renderer и всех потребителей теней ещё открыта. Чтение цвета, Blur и Y-axis из правильной темы — отдельная runtime-проверка.

## Animation

Прочитан [Animation, 18708:974](https://www.figma.com/design/gGt4PaQxQhX7ozPVImsgL5/TUI-Foundations?node-id=18708-974), включая изображения всех кривых и назначения duration.

| Токен | ms | Назначение из источника |
| --- | --- | --- |
| fastest | 75 | Микроанимации, например toggle/checkbox |
| fast | 150 | Микроанимации и fade |
| moderate | 300 | Notifications, появление компонентов, перемещение |
| slow | 500 | Модальные окна, крупные объекты |
| slowest | 700 | Модальные окна, затемнение, крупные объекты |

| Кривая | cubic-bezier |
| --- | --- |
| productive-standard | (0.2, 0, 0.4, 0.9) |
| productive-entrance | (0, 0, 0.4, 0.9) |
| productive-exit | (0.2, 0, 1, 1) |
| expressive-standard | (0.4, 0.1, 0.2, 1) |
| expressive-entrance | (0.35, 1.3, 0.25, 1) |
| expressive-exit | (0.4, 0, 1, 1) |

Productive — сглаженная смена скорости; Expressive — резкие изменения, отскок и перерастяжение. Для fast и fastest источник предписывает Productive. Это не разрешение переопределять глобальные анимации iOS: для нативной навигации и шторок сохраняются системные взаимодействия по решению пользователя.

Исходные значения совпадают с импортом; FoundationTokenTests теперь проверяет координаты независимо по этой таблице, а не только по тому же JSON, который читает runtime. Кроме того, сохраняется независимая параметрическая проверка UnitCurve, включая overshoot.

В источнике есть дополнительный [Гайд по анимации](https://www.figma.com/design/K1HvAzk3j5MglVkOOy9RO4/%D0%93%D0%B0%D0%B9%D0%B4-%D0%BF%D0%BE-%D0%B0%D0%BD%D0%B8%D0%BC%D0%B0%D1%86%D0%B8%D0%B8?m=auto&t=oaVQlpearFBaEUvd-6); содержимое связанного файла в этом извлечении ещё UNVERIFIED. Все наблюдаемые ссылки сохранены в [documentation-links-2026-10-08.json](documentation-links-2026-10-08.json). Ссылки из FAQ на канал Time сохранены; сообщения не отправлялись.

## Доказательства и дальнейшая приёмка

Полные ответы MCP для всех перечисленных фреймов сохранены в Documentation/Inventory/2026-10-08. Точные экспортированные схемы — DesktopAssets; обзорные исходные PNG для Size, Shadow, Animation лежат рядом с этим отчётом. Полнота снимков отличается от полноты реализованного API: неизвестные bindings, градиенты, renderer теней и дополнительные документы не объявляются проверенными.

Runtime-проверки новых теней, обновлённых ожиданий motion и регрессии Skeleton выполняются через реальный пакет на iOS 26 Simulator. Приёмка каждого из 128 наборов по семи категориям продолжается отдельно. Ни один статус complete не назначается по факту чтения этих страниц.

Текущий прогон: [11 тестов прошли, 0 ошибок и пропусков](../../Validation/2026-10-08/FoundationShadow/test-summary.json); [отдельный каталог собран](../../Validation/2026-10-08/FoundationShadow/catalog-build.log). [15 из 15 рендеров Skeleton идентичны прежней приёмке](../../Validation/2026-10-08/FoundationShadow/skeleton-regression.json); проверка цвета Night и новые shadow/motion ожидания прошли. Повторная приёмка этих двух наборов оформлена в [отчёте регрессии](../Skeleton/foundation-regression-2026-10-08.md). Полная Foundation-приёмка ещё открыта.
