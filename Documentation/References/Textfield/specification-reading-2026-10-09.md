# Textfield: чтение спецификации до реализации

**Статус: основной Guide и связанные материалы о форматировании и SmartFields прочитаны. Первая реализация Textfield и нативный playground добавлены после чтения; полная приёмка остаётся pending.** Figma использована только для чтения get_design_context/get_motion_context и экспорта download_assets. Ни один исходный файл не изменён.

Основной набор: [TUI Mobile 65702:51131](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=65702-51131). Спецификация: [Дизайн 4923:11438](https://www.figma.com/design/R4dFzxFzgDIGTcdlrqaRpe?node-id=4923-11438). Исходная короткая ссылка `https://go.tcsbank.ru/tui-textfield-specs` сохранена в метаданных. Работа продолжает существующую инвентаризацию, не заменяет её новым набором.

Свежий полный контекст набора содержит те же 44 variant ID и значения свойств, что импортированная матрица: 22 iOS, 22 Android. Изменённых, новых и пропущенных ID нет (`source-matrix-comparison-2026-10-09.json`). Android не входит в реализацию. Есть normal, focus, invalid, invalid-focus, read-only, disabled, filled, label и skeleton; матрица не является полным декартовым произведением. Не придумывать ID отсутствующих комбинаций.

## Прочитанные разделы

| Раздел | Node ID | Как проверен |
| --- | --- | --- |
| Реализация в коде | 7072:42795 | полный текст |
| Состояния | 4802:3778 | полная PNG-матрица; тексты заголовков состояний отдельно |
| Построение | 4803:6152 | полный контекст и PNG, включая таблицу и структурную схему |
| Размеры | 4827:6778 | текст дочерних блоков, полная PNG-схема Mobile/Desktop |
| Поведение | 4830:6945 | текст дочерних блоков, полная PNG со схемами |
| Подсказки | 7084:56801 | полный контекст и PNG |
| Анимация | 4859:6710 | полный контекст, PNG, ссылки на прототипы |
| Дополнительные возможности | 4831:7321 | текст дочерних блоков, полная PNG |
| Кастомизация | 4857:7477 | полный контекст и PNG |
| Правила использования | 4880:8888 | полный контекст и PNG |

Ответы верхнего section и больших frames были sparse metadata. Они не считаются прочитанной спецификацией сами по себе: текст запрошен по наблюдаемым дочерним ID, схемы экспортированы отдельно. Сохранены все ответы. Один ошибочный запрос `4802:33259` не является источником Invalid; фактическая наблюдаемая подпись `4802:32726` прочитана отдельно. Не использовать ошибочный ответ как требование.

В полном контексте Построения две строки таблицы представлены пустыми техническими плейсхолдерами. PNG показывает фактические подписи: **Value — текст значения, обязательно; Placeholder — подсказка, необязательно**. При чтении учтена схема, а не только сгенерированный JSX. JSX не является целевой реализацией и не устанавливает поведение нативного ввода.

## Контракт iOS по прочитанным источникам

- Минимальная высота поля 56, внутренние горизонтальные отступы 12, радиус контейнера 16. Между содержимым и аксессуарами 8; между label и value 2. В актуальном Mobile-наборе внешний Screen Padding 16, внутренний вертикальный padding содержимого 8. Это различающиеся уровни; не складывать внешний padding дважды при сборке формы. Ширина адаптивна.
- Незаполненное неактивное поле показывает label в размере Body L 17 / tracking −0.41. Заполненное либо в фокусе с label — малый label UI S 13 / −0.08 и value/placeholder Body L 17 / −0.41. SF Pro Text Regular. Подсказка в актуальных вариантах — Body M 15 / −0.24. Значение `lineHeight: 100` в описании стиля не подменять фиксированной высотой 100 или 17; у слоёв leading normal.
- Фон Neutral 1 сохраняется при фокусе. Ошибка красит label в Text/Negative; без label — значение. Состояния disabled/read-only показывают исходный lock, но read-only сохраняет возможность выделения, а disabled исключает взаимодействие. Это разные режимы.
- iOS при получении фокуса ставит курсор в конец. Длинный текст в нативной мобиле имеет fade с соответствующей стороны; пример в фокусе сохраняет конец и затухание слева. Не заменять native fade десктопным многоточием.
- Область нажатия аксессуара по высоте равна минимуму поля 56, а по ширине включает отступы в зависимости от позиции. На схеме крайний справа включает 12 снаружи и 8 перед ним при единственном элементе; внутренние границы нескольких элементов делят gap 12 пополам (6). Не ограничивать действие только 16 pt иконкой.
- Фон выделения использует `service.selection-background` по Guide; соответствующий импортированный Theme-токен — `Service/Selection Background`. Точный механизм применения токена в нативном UITextField ещё не проверен. Desktop autofill, hover и tooltip не становятся требованиями iOS.
- Очистка опциональна, только в фокусе и при непустом значении; при других end-accessories не показывается. Значение стирается мгновенно. Появление clear анимировано как переход состояния, скрытие — без анимации.
- Слоты допускают динамическое содержимое/действия слева и справа, включая другие библиотечные компоненты. По подтверждённой кастомизации правый внешний отступ можно выключить для кнопки у края. Hint допускает изображение и ссылку.
- Hint в нативной iOS указан как возможность SmartFields: по умолчанию только в фокусе, возможен always-visible. Расстояние до первого hint, между hints и горизонтальный inset на мобильной схеме — 12. Ошибка замещает обычные подсказки. Валидация по умолчанию при submit, может выполняться по мере ввода.
- Ограничение ввода выключено по умолчанию. Если включено, ввод сверх лимита не добавляется, вставка большого текста обрезается; мобильный feedback Impact Heavy. Счётчик может быть постоянно доступным по правилам hint или появляться при достижении заданного порога. Числа 5, 100, 300 в примерах не являются фиксированными лимитами компонента.
- Center alignment допустим только без label, accessories, placeholder в фокусе и clear. Отдельного пресета в Figma нет. Tap-only допускает нажатие всего поля без ввода, выделения и редактирования; это не read-only.
- Префиксы/суффиксы видны сразу в фокусе без placeholder, либо после начала ввода при наличии placeholder. При переполнении значение обрезается, суффикс остаётся у края. Dynamic font только без label и clear: уменьшается до 10, потом overflow; высота и отступы остаются. Полный отдельный контракт количества/number ещё требуется прочитать до реализации этой части.
- Auto-height относится к multiline и select: общие правила сохранены, спецификации этих отдельных наборов ещё не прочитаны. Не выдавать это за готовность multiline/number/convert/counter.
- Loader располагается первым в правом контейнере; стиль/размер нельзя произвольно менять. В **актуальном Mobile** это 24 × 24, проверенный вложенный `65702:51201` разрешается в исходный variant **42819:293395**, set **9999:26**. Схема Построения Guide показывает 16; это историческое расхождение примера и текущей матрицы. Сохранять связь с актуальным источником, не уменьшать Loader молча. Публичный TUILoader уже имеется, его приёмка остаётся pending.

## Motion

Переходы состояний: 150 мс, productive-standard. Нажатие iOS: фон Neutral 1 Pressed сразу; отпускание возвращает фон за 150 мс / productive-standard. Первичная ошибка: notification-error haptic, 500 мс / productive-standard, X 0 → −3 → 3 → −3 → 3 → 0. Повторная ошибка уже валидированного поля: 300 мс / productive-standard, X 0 → −3 → 3 → 0. После добавления или удаления символа поле возвращается в дефолтное состояние.

Hint появляется opacity 0 → 1 за 300 мс / productive-entrance, скрывается 1 → 0 за 150 мс / productive-exit. Несколько hints анимируются одним блоком и сдвигают контент ниже.

В локальных Foundations уже существуют TUIMotionDuration и TUIMotionCurve; примитивы fast = 0.150000006, moderate = 0.300000012 соответствуют текстовым 150/300 мс. Не добавлять отдельные универсальные длительности и не менять глобальную скорость iOS.

Прототипные кадры 4904:13195, 4904:12998, 4923:2332 прочитаны: в них вложены `[deprecated] tui-textfield`. Это **исторические примеры**, не новая Deprecated-библиотека и не источник нового API. Ответы recursive get_motion_context для этих кадров и guide frames — `nodes: []`. Они не доказывают отсутствия движения. Reactions/AFTER_TIMEOUT и интервалы между шагами shake не получены; не выдавать равномерную раскладку шагов за прочитанную спецификацию. Полные URL сохранены в `observed-links-2026-10-09.json`.

## Зависимости и остающиеся UNVERIFIED

Иконки найдены через figma-assets.json: `tui-ic-service / clearfield-ios` — Assets 5247:560, `tui-ic-small / lock` — 1622:496, обе 16 × 16. Точные source assets экспортированы: clear совпал с уже существующим ресурсом SearchInput и переиспользован; lock сохранён в OriginalSVG и imageset с исходным расположением маски. Общий Skeleton уже есть; в текущем skeleton-варианте поля radius 12, а не 16. Его анимация ещё не принята.

Связанные материалы о количественных данных (2A6TJKC6Ijfq4eXJKjgeVP, 33:940) и статическом SmartFields hint prototype (jmEgQqdY10CU7Yq3gPsF50, 4446:17673) прочитаны; подробности ниже. Правила построения форм остаются UNVERIFIED. У ссылки на формы MCP не вернул URL; он не придумывается. Ссылки на multiline/select местами возвращаются как навигационные подписи, а не URL. Основные тексты и схемы не заменяют эти зависимости. Распределение timing shake, все bindings Variables по темам и полный instance-swap граф требуют подтверждения. Распространение/системная замена старых SF-шрифтов остаются отдельным нерешённым условием поставки библиотеки.

SwiftUI Textfield добавлен в публичный пакет. Первый нативный playground включает состояния, ввод, очистку, лимит, hints, Loader, 22 варианта и переключение темы. Реестр содержит 22 Figma-to-API mappings, статус in-progress. Проверки и выявленные ограничения сохраняются в Documentation/Validation/2026-10-09/Textfield; категории приёмки остаются pending до полного подтверждения. Это не complete.

## Дополнение после чтения связанных источников

Материалы quantity (2A6TJKC6Ijfq4eXJKjgeVP, 33:940) и статический SmartFields (jmEgQqdY10CU7Yq3gPsF50, 4446:17673) прочитаны целиком в контексте и PNG. Сохранены related-quantity/related-smartfields-context и изображения. Правила форм остаются UNVERIFIED: MCP не вернул target URL. Safari показал экран входа, не содержимое документа. Нативной работе пользователя не мешаем; файлы Figma не редактируем.

### Повторная сверка Read-only и пустого focus

Повторно прочитаны текущие исходные варианты `65702:51460`, `65702:51586`, `65702:51616`; ответы сохранены как `readonly-and-placeholder-source-*`. Для пустых focus/invalid-focus без label исходный текст — `Placeholder`, SF Pro Text Regular 17, tracking −0.41, цвет Text/Secondary. Ошибка красит введённое значение, но не этот плейсхолдер. Исправлены пример каталога, два публичных mappings и цвет плейсхолдера. Это подтверждение конкретных вариантов, а не полного component property mapping.

Read-only проверен настоящим выделением и Copy с последующей вставкой в редактируемое поле. Первоначальный тест искал команды как Button, тогда как iOS 26 предоставляет MenuItem. Дополнительная проверка выявила AutoFill в Read-only: он приходит через системное edit menu отдельно от canPerformAction. Публичные делегаты UIKit фильтруют меню до нативных команд выделения/Copy; их действия и локализация сохраняются. Редактируемое поле получает исходное системное меню без подмены. Успешный нативный результат сохранён в `Documentation/Validation/2026-10-09/Textfield/ReadOnlyVerified`.

Quantity: если дробная часть показана — два знака; ненулевую дробную часть не скрывать. Разделитель определяется locale, группировка от четырёх цифр по три справа, пробелы неразрывные. Плюс U+002B, минус U+2212 без пробела. В русском интерфейсе знак валюты справа после U+00A0, в иноязычном — слева без пробела; валютный код без знака — латинские заглавные буквы после неразрывного пробела. Это правила отдельного форматтера, не автоматическое преобразование обычного текстового ввода. Схемы правильных/неправильных примеров и группировки прочитаны.

SmartFields: hidden MasterHint 8762:95518 имеет Body M 15/−0.24 и padding 12. Исторические Deprecated-вложения не переносятся. Recursive motion ответ nodes: [] не подтверждает отсутствие движения; параметры hints берутся из основного Guide.

Clear и lock выгружены в SVG/PNG. Clear побайтно совпал с существующим ресурсом SearchInput и переиспользуется. Lock сохраняет исходный mask 10 × 11.998, path и градиент; размещение в 16 × 16 slot с offset (3, 1.4) взято из source-lock-context. Свежие Variables основного набора сохранены отдельно. Все 22 iOS-экспорта находятся в FreshFigma. В четырёх invalid-focus присутствует Error и высота 98; остальные имеют 56. В заполненных focus/invalid-focus clear присутствует независимо от show-end-accessory и использует Text/Tertiary. Эти сведения учтены по полным веткам текущего набора и PNG.

Первая попытка снимков через layer.render в безоконном раннере дала полностью прозрачные изображения. Они сохраняются как история неудачного способа, **не как визуальные доказательства**; тест теперь проверяет layout size, а актуальные снимки выполняются в активной сцене каталога. Наличие PNG и успешная сборка сами по себе не означают приёмку.

### Измеренные текстовые bounds и расхождение hint bounds

Повторно прочитан `65702:51231`: это **invalid / unfilled / show-label=off**, а не normal. Ответ сохранён в `normal-empty-binding-65702-51231-2026-10-09.txt` (историческое имя файла не является именем состояния). Исходный Label использует Text/Negative; нельзя переносить Text/Secondary из пустого focus на эту ветку.

Текущий context и metadata `65702:51258` сохранены в width-source-* файлах. Root 320×98; container x=16 / width=288 / height=56. В content label y=9 / height=16, value-container y=27 / height=20. Cursor x=0 / y=0.5 / width=2 / height=19; placeholder x=1 / width=263 / height=20. Эти legacy bounds применены локально к Textfield, не к глобальным line-height токенам.

При этом error-container x=16 / y=56 / width=320 / height=42 выходит за root до x=336. Экспорт Figma 336×98; крайние 16 px белые. Root совпадает с импортированной матрицей 320, изображение не растягивается. Сохранены исходные размеры, сравнение использует дополнительный белый canvas справа. Полное адаптивное поведение hint при этих противоречивых bounds остаётся UNVERIFIED. Figma не изменялась.

### Disabled, слоты и Skeleton: продолжение реализации

Перед исправлением повторно прочитаны текущие «Состояния» (`4802:3778`), описание Disabled (`4802:32298`), «Кастомизация» (`4857:7477`) и tap-only (`6845:62102`). Сохранены disabled-and-state-source, spec-4802-32298-refresh, customization-refresh и tap-only-refresh. Disabled описан как недоступный для взаимодействия; кастомизация допускает кнопки слева/справа и ссылки в hint. Tap-only разрешает нажатие без ввода, выделения и редактирования.

Блокировка disabled распространена на всё дерево TUITextfield, включая пользовательские слоты и hint. Общий tap обработчик разделён между текстовой областью и свободным padding; отдельная кнопка аксессуара не активирует редактор. Read-only остаётся отличным от disabled и сохраняет нативное выделение. Эти контракты проверены фактическими действиями в каталоге, результаты NestedActionsVerified.

Skeleton переиспользует существующий TUISkeleton с его проверенным циклом opacity; новый цикл не создаётся. Textfield сохраняет свой исходный радиус 12 и адаптивную ширину через GeometryReader/clip. Публичный isSkeletonAnimating по умолчанию true; false — только для статического просмотра исходного варианта. В source-mode каталога и копируемом skeleton-примере цикл явно остановлен, в обычном playground — активен. NativeMatrixWithSkeleton содержит повторную матрицу и восемь временных снимков активной сцены. Изменение пикселей подтверждает работу цикла, но не заменяет измерение всех анимаций Textfield. First/repeated error shake и остальная временная приёмка остаются pending.

### Исправление передачи нативного фокуса

Запуск формы в независимом потребителе обнаружил зависание после submit и добавления результата в SwiftUI VStack. Стек `Documentation/Validation/2026-10-09/Textfield/consumer-submit-hang.sample.txt` подтверждает цепочку: updateUIView → resignFirstResponder → SwiftUI responderNode → повторное обновление AttributeGraph. Это дефект интеграции редактора, а не требование Figma или длительная продуктовая анимация.

Передача фокуса, native enabled и reloadInputViews вынесены за пределы синхронного updateUIView на следующий проход main queue. Запросы объединяются, выполняются по последним flags и не восстанавливают устаревший фокус. Read-only использует один пустой inputView; при смене режима активного редактора выполняется reloadInputViews без изменения системной скорости анимаций. Форма с добавлением результата прошла в Day/Night, переходы focus → read-only/disabled и selection/Copy → Paste проверены отдельным успешным запуском. Итоги и история неудачных запусков находятся в `Documentation/Validation/2026-10-09/Textfield/verification-report.md`; интеграция не означает полную приёмку компонента.

### Лимит и сохранность существующего текста

Повторно прочитан `4831:7323`, свежий ответ сохранён в input-limit-refresh. Требование: символы сверх лимита не добавляются; длинная вставка обрезается; ограничение выключено по умолчанию; мобильный feedback — Impact Heavy. Ранее обрезался весь результат редактирования, поэтому вставка символа в середине полного поля могла удалить его старый конец. Теперь лишний отдельный символ отклоняется без изменения данных и без сброса ошибки. Длинная вставка ограничивается в пределах изменяемого фрагмента, сохраняя неизменённые части строки и нативную позицию курсора. Для завершения composing text применено то же ограничение к изменённому фрагменту, а не к хвосту уже введённого значения.

Три регрессионных теста проверяют середину заполненного поля, вставку emoji/combining characters с сохранением suffix и UTF-16 insertion point, а также обработку уже завершённого составного ввода. Последний тест моделирует commit через editingChanged; он не выдаётся за прогон всех языковых клавиатур. Примеры из источника не задают фиксированный лимит API.

### Error feedback: current motion source and implementation

Read-only Desktop MCP successfully read Guide 4859:6710 again after cloud transport failed. The native file was opened by navigation, without content edits. motion-guide-read-desktop is the successful full context; earlier *refresh files retain failed tool responses and must not be treated as specifications. The current Guide still defines notification-error haptic, 500 ms / productive-standard / X 0 -> -3 -> 3 -> -3 -> 3 -> 0 for first validation and 300 ms / X 0 -> -3 -> 3 -> 0 for repeated validation. get_motion_context on the Guide returns nodes: []; this does not negate the textual requirement. The linked prototype was not loaded by Desktop MCP yet; exact per-step timing remains UNVERIFIED.

SwiftUI native keyframeAnimator owns the lifecycle. It drives linear progress over the duration token; the shared productive-standard UnitCurve maps progress before sampling the source position sequence. Equally spaced progress knots are an explicit implementation choice, not a reported source timing. The whole field and its hint move together; this scope still requires prototype verification. Initial invalid rendering is static. A composite invalid/validationTrigger/enabled request prevents duplicate feedback when a submit changes state and trigger together; invalidFocus changes do not revalidate. Increasing validationTrigger permits repeated errors with unchanged value/state. Disabled/read-only/Skeleton suppress error feedback. Leaving invalid hides displacement immediately. Haptic invocation is implemented; physical sensation cannot be verified in Simulator.

After native page navigation completed, the linked prototype page 4885:31175 and frame 4923:2332 were read successfully. motion-prototype-read-desktop and motion-prototype-tracks-read-desktop supersede the earlier failed prototype refresh responses; the successful motion response still has nodes: []. Page geometry and complete contexts of 4923:2270 / 4923:2284 confirm a discrepancy: the older [deprecated] wrapper uses X 76 and 82 relative to its default 80, i.e. -4 and +2, while the main Guide explicitly specifies -3 and +3. No Deprecated component is implemented. The new component follows the Guide's textual sequence; the inconsistent prototype is preserved as historical evidence. Classic prototype reaction timings are not exposed by these context/motion outputs, so the exact source allocation of individual steps remains UNVERIFIED.

The latest active-scene native trace has 114 samples. First error reaches -3 / +3 and the signs alternate twice; last observed movement is at 524.6 ms after the screen's validation event. Repeated error alternates once, reaches sampled -2.667 / +2.667 and last moves at 323.8 ms. Sampling, display latency and pixel rounding explain why these observed times are not the token values themselves. Focus-only and reset have zero X displacement. The 5-second recording is a passthrough trim of real Simulator video, not a reconstruction or retimed animation. This evidence verifies implemented native movement, not the missing source per-step times or all Textfield transitions.

## Связанная страница Forms найдена и прочитана

Предыдущая отметка недоступности правил форм выше — история неудачного чтения. После навигации в нативном Figma наблюдаемая страница `9702:48708` оказалась доступна. Четыре мобильных frames и все содержательные child instances прочитаны; 12 схем просмотрены. Полный разбор, node IDs, правила и границы текущей реализации: `forms-reading-2026-10-09.md`; исходные контексты: `forms-*-context-2026-10-09.txt`, ресурсы: `FormsAssets`.

Источник подтверждает 12 pt между полями, отключаемый внешний inset, primary-accent medium «Дальше»/«Готово» над клавиатурой с отступами 16/12 pt, последовательность непрерывных полей с пропуском disabled/read-only/tap-only, автопрокрутку, снятие фокуса с пустого пространства и три варианта валидации. Чтение источника завершено. Form coordinator реализован через публичный TUITextfieldForm и проверяется в независимом consumer; текущий протокол находится в Documentation/Validation/2026-10-09/TextfieldForm/verification-report.md. Полная кастомизация inset/hints и связанные dropdown/select страницы остаются pending/UNVERIFIED. Одна работающая форма не подтверждает всю спецификацию.
