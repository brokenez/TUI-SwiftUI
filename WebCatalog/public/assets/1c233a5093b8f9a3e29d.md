# Header Card: сопоставление и независимый потребитель

На iPhone 17 Pro, iOS 26.4.1, проверены публичный пакет и отдельное приложение `Examples/ConsumerApp/TUIConsumer.xcodeproj`. Приложение импортирует `TUIDesignSystem`, получает ресурсы из пакета и владеет состоянием, обработчиками и нативной шторкой. Копий компонентов и ассетов в нём нет. Это проверка использования Header Card, а не готовность всей системы или полного экрана зарплатного клуба.

## Сопоставление исходной матрицы

| Figma ID | Публичный `Variant` | Обязательные данные приложения |
| --- | --- | --- |
| 17714:53773 | skeleton | Нет |
| 17714:53869 | extendedSkeleton | Нет |
| 44217:298678 | avatar | Нет |
| 44217:299480 | button | `accessoryAction` |
| 44217:299616 | buttonLink | `accessoryAction` |
| 44217:299699 | switch | writable `isOn` Binding |
| 44217:299799 | none | Нет |
| 59830:293851 | extendedAvatar | Нет |
| 59830:293951 | extended | Нет |

Это все девять фактически существующих iOS-вариантов набора `44217:298609`. Android не входит в целевую платформу. Названия и значения `System`, `Accessory`, `Extended`, `skeleton` сохранены в `figmaProperties`; тест сверяет их непосредственно с импортированной матрицей. `Variant` сохраняет точный исходный ID, а не синтезирует несуществующие сочетания.

| Исходное свойство | Публичное соответствие |
| --- | --- |
| HeaderText#42565:68 | `title`, String или AttributedString |
| SubheaderText#42565:77 | `subheader`, String или AttributedString |
| Subheader#42565:95 | `showsSubheader` |
| Description#56480:0 | `showsDescription`; содержимое — `description` |
| Caption#59837:0 | `showsCaption` для Extended |
| CaptionText#59837:15 | `caption`; исходный uppercase применяется компонентом |
| Badge#41997:19 | `badgeCount == nil` скрывает badge; полный смысл передаёт `badgeAccessibilityValue` |
| Hint#41997:12 | отсутствие `.hint` скрывает подсказку; `.hint(label, action:)` задаёт текст и обработчик |

Вложенные Action label/state доступны через `actionTitle`, `accessoryAction`, `isOn`, `isEnabled`. Редакторские слоты расширенного подзаголовка представлены `.subheaderLeading`/`.subheaderTrailing`; собственный accessory — `.accessory`. Эти View сохраняют содержимое потребителя. Ссылки передаются через AttributedString, обработка URL принадлежит OpenURLAction приложения. Отсутствие обработчика Button/Link или writable Binding Switch не скрывается бездействующим контролом: конструктор требует их явно.

## Выполненные проверки

- Package: прежние четыре Header Card и 15 Header Large тестов прошли; исходный production-код после них не изменялся. Новый тест подтвердил все восемь сочетаний Caption/Subheader/Description и размеры 375×52…128 pt. Скрытый контейнер не оставляет отступ. Рендеры — `Validation/2026-10-07/HeaderCardContentProperties/`.
- Каталог: два прежних UI-теста подтвердили реальные Button/Link и native Switch, два чистых снимка переключателя Day/Night в активной сцене.
- Отдельное приложение: выбор всех девяти вариантов, два независимых действия Button/Link, disabled Link, изменение native Switch через Binding и disabled Switch проверены физическими нажатиями. Состояние переключателя не вызывает обработчики кнопки или подсказки.
- Дополнительные действия: один доступный заголовок содержит полный Caption/title/subheader и три действия — подсказка, ссылка заголовка и ссылка подзаголовка. Description имеет собственную ссылку. Все четыре обработчика исполнены; три URL различны, подсказка открыла стандартную iOS-шторку. Полное значение badge — `124 уведомления`; видимое `99+` не подменяет смысл. Данные публичных UIKit AX API и XCTest сохраняются отдельно от фактического прослушивания VoiceOver, которое здесь не заявлено.
- Публичные веб-примеры: 109 уникальных примеров компилируются, включая все девять Header Card. UIKit Switch проверяется в приложении, а не ImageRenderer.
- После добавления маршрута потребителя прошли прежний Card Medium UI-сценарий и два Header Large сценария дополнительных ссылок. Их production-реализации не изменялись. Только hash входного маршрута потребителя обновляется на основании этой регрессии.

Первый UI-прогон: пять сценариев прошли, один AX-сценарий не прошёл. Причина находилась в проверочном обработчике: поиск по слову «Подробнее» выбрал более раннюю подсказку с этим словом. Исправление ограничено тестовым маршрутом потребителя — поиск по полному имени `Открыть ссылку: Подробнее`. Повторный AX-сценарий прошёл. Первый Failed summary сохранён как история; он не объявляется успешным полным прогоном. Индивидуальные результаты — `HeaderCardConsumer/tests.json` и `HeaderCardConsumerAX/tests.json`.

Сборки пакета, каталога и потребителя прошли. Компонент использован через публичный API с ресурсами пакета. Поэтому проверки `variantMapping` и `integration` приняты. `specification`, `visual`, `interaction`, `accessibility`, `motion` остаются pending: полная спецификация и дочерние состояния, визуальные различия шрифтов, физический Hint/слоты и полный порядок VoiceOver ещё требуют проверки. Дерево AX и исполнение дополнительных действий не заменяют прослушивание и проверку порядка фокуса.

Инвентаризация прототипных reactions через Figma Plugin API не завершилась: сервис дважды отклонил запрос чтения с сообщением о read-only mode, в том числе без переключения страницы. Первая более широкая попытка превысила лимит ответа. Никаких записей в исходный макет не выполнялось. Это не доказательство отсутствия анимаций; motion не принят.

## Воспроизведение

Из корня проекта, на данном компьютере:

```sh
xcodebuild -project Examples/ConsumerApp/TUIConsumer.xcodeproj -scheme TUIConsumer \
  -destination 'platform=iOS Simulator,id=6D3F35A1-AC30-4F0E-BDD6-0F912B714E59' \
  -derivedDataPath /private/tmp/tui-consumer-card-medium-derived \
  -skipPackageUpdates CODE_SIGNING_ALLOWED=NO build
xcrun simctl install 6D3F35A1-AC30-4F0E-BDD6-0F912B714E59 \
  /private/tmp/tui-consumer-card-medium-derived/Build/Products/Debug-iphonesimulator/TUIConsumer.app
xcodebuild -project TUIDesignSystemCatalog.xcodeproj -scheme TUIDesignSystemCatalogUITests \
  -destination 'platform=iOS Simulator,id=6D3F35A1-AC30-4F0E-BDD6-0F912B714E59' \
  -derivedDataPath /private/tmp/tui-card-medium-ui-derived \
  -only-testing:TUIDesignSystemCatalogUITests/HeaderCardConsumerUITests \
  -parallel-testing-enabled NO -skipPackageUpdates CODE_SIGNING_ALLOWED=NO test
```

На другом компьютере следует выбрать существующий симулятор iOS 26. Ручной вход — «Header Card из пакета»; специальный запуск — `--header-card-consumer`. AX inspection включается только аргументом `--header-card-ax-probe`. Его вспомогательные кнопки не являются частью библиотеки.
