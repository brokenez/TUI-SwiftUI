# Сборка экранов из TUI Design System

Решение от 9 октября 2026: [16 системных наборов Apple исключены из переноса](system-components-scope-2026-10-09.md). Резолвер возвращает для них `status: excluded`, `swiftAPI: null` и указание использовать нативные API iOS 26 напрямую в приложении. Не создавайте для них новые компоненты или обёртки TUI. Для кастомных `tui-*` продолжает действовать описанный ниже контракт. Текущая полнота библиотеки — приёмка 112 оставшихся наборов; 128 — число сохранённых исходных записей.

Этот Swift Package предназначен для новых сценариев, а не только для «Зарплатного клуба». Если на входе дана ссылка на экран или компонент TUI Mobile, сначала прочитайте узел через Figma `get_design_context`. У ссылки вида `...?node-id=115603-32334` идентификатор набора — `115603:32334`.

## Контракт сборки в другом проекте

Ссылка на репозиторий указывает источник библиотеки. Для сборки нужен доступ к его файлам и к исходному экрану Figma. При использовании из другого проекта сначала получите репозиторий, прочитайте этот документ, `Package.swift` и актуальные паспорта компонентов. Инструкции в корневом `AGENTS.md` описывают разработку самой библиотеки; порядок использования потребителем описан здесь.

1. Составьте список вложенных компонентов экрана: постоянный ключ, исходный набор/вариант, изменённый контент и состояние экземпляра. Проверьте, что параметры доступны в публичном API, а подтверждение готовности актуально.
2. Подключите продукт `TUIDesignSystem` как зависимость приложения. Для опубликованного выпуска зафиксируйте версию пакета; пока используется локальная зависимость. Каталог и его Xcode-проект для подключения не нужны.
3. Соберите композицию экрана из публичных компонентов и токенов. Состояние, данные, действия и маршруты принадлежат приложению. Компоненты и ресурсы остаются внутри пакета.
4. Соберите и запустите приложение на iOS 26, проверьте взаимодействия и сравните его с Figma в одинаковых размере и теме. Зафиксируйте использованные варианты и найденные расхождения. Если исправление относится к компоненту, внесите его в библиотеку и повторите проверку потребителя.

Неизвестный ключ, отсутствующий вариант или недоступный исходник — явный незакрытый пункт сборки. Не объявляйте экран соответствующим Figma, пока эти пункты не разрешены. Полная готовность дизайн-системы определяется приёмкой всех 112 наборов текущей области поставки, а не успешной сборкой одного экрана.

## Как найти реализацию

1. Выполните `python3 Scripts/resolve_figma_node.py 'https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=115603-32367'` или найдите ID набора в `Documentation/component-coverage.json`. Резолвер возвращает публичный SwiftUI-символ, исходный файл, статус и свойства варианта. `status: complete` означает, что полная применимая матрица iOS 26, спецификация, визуальная и поведенческая приёмка подтверждены паспортом. `in-progress` означает рабочий компонент с незавершённой сверкой; `catalogued` — реализации пока нет.
2. Если ссылка ведёт на вариант, найдите его ID в `Sources/TUIDesignSystem/Resources/Metadata/figma-component-variants.json`. Поля `setId` и `variantProperties` связывают этот вариант с компонентом и его свойствами. Для экрана с несколькими компонентами повторите это для каждого вложенного набора.
3. Исторические iOS 18 узлы сохраняются в реестре отдельно. Поле `historicalVariant` резолвера отмечает такой вход; оно не подтверждает исполнение iOS 18. Для системного компонента используйте нативную iOS 26 и применимый вариант этого набора.
4. Используйте `variantMapping` для точных параметров конкретного узла или `availableMappings` для набора. Для сопоставленных Checkicon, Spacing, Close, Skeleton, SkeletonText, Share, Like, Header Large и Card Medium параметры уже сохранены; остальные наборы требуют заполнения паспорта. `variantScope` различает применимую iOS 26, историю и другую платформу. Резолвер проверяет актуальные контрольные суммы входных файлов при каждом вызове. Проверьте детали в файле `swiftAPI.source` и в Figma-спецификации из `specificationURLs`: допустимые значения, поведение, контент и доступность. Не выводите готовность из одного только наличия символа.
5. Используйте `TUIColor`, `TUITypographyRole`, `TUISpacing`, `TUIRadius` и `TUIControlSize` для недостающей композиции экрана. Системные элементы навигации, шторки, меню, списки и поля поиска оставляйте нативными для iOS 26.
6. После сборки экрана сравните его на симуляторе с Figma в том же размере и теме. Если нужный набор ещё `catalogued` либо его вариант не покрыт API, сначала реализуйте и проверьте компонент здесь, затем собирайте экран потребителя.

Для интерактивной проверки откройте `TUIDesignSystemCatalog.xcodeproj`: каталог использует реальные SwiftUI-компоненты, а у живых наборов показывает текущий ID варианта Figma. Полная матрица хранится отдельно от кода, чтобы при появлении новых сценариев можно было искать компоненты по Figma ID без зависимости от названия экрана.

## Пример использования компонента

### Floating Container: закреплённые действия

Набор `44286:299509` доступен как `TUIFloatingContainer`; его шесть iOS-вариантов сопоставлены с публичными конструкторами. Текущий статус — `in-progress`: конечные layout и базовые интеракции проверены, полная visual/motion приёмка открыта. [Полный рабочий экран независимого потребителя](../Examples/ConsumerApp/App/FloatingContainerConsumerScreen.swift) импортирует только публичный пакет и владеет действиями/состоянием.

Для размещения используйте `.tuiFloatingContainer(isPresented:content:)` на содержимом экрана. В closure возвращайте сам `TUIFloatingContainer`, без вложенного второго контейнера: иначе поля 16 и отступы 24 применятся дважды. Системная нижняя область и навигация остаются нативными. Modifier задаёт 20 pt после конца обычного скролла; он не заменяет специализированный `TUITextfieldForm` с отступами 12/16 над клавиатурой.

Одна кнопка использует `init(primary:showsFade:)`; если она видна сразу, передайте `showsFade: true`, если появляется по scroll/trigger — false. Две кнопки используют `init(primary:secondary:background:)`, предпочтительный secondary — `.flat`. Для дисклеймера используйте `init(primary:legalText:background:)`, максимум три строки; юридический текст не сочетается с двумя кнопками. Произвольный слот — `TUIFloatingContainer { ... }` с реальными SwiftUI-компонентами, не с изображением редакционного Placeholder. Размеры/оформление/состояния кнопок передаются через существующий `TUIButton`.

Показ/скрытие основного блока и элементов другой формы используют 500/200 ms из Guide; одинаковая форма меняется через fade 75 ms. Прочитанные дорожки прототипа уточняют secondary/legal: весь переход fade + layout длится 200 ms к legal и 300 ms к secondary с productive-standard. При изменении secondary/legal сохраняйте одну ветку `TUIFloatingContainer(primary:secondary:legalText:background:showsFade:)`, передавая отсутствующее содержимое как nil. Раздельные ветки switch пересоздают весь контейнер и теряют переход между дополнениями. Два дополнения одновременно запрещены исходной спецификацией. Loading/disabled меняют состояние существующего Button, а не его идентичность.

Для замены произвольного слота модификатор принимает `replacementID` и `replacementKind: .sameShape` либо `.differentShape`. Ключ меняется только при замене содержимого; показ/скрытие независимо сохраняют движение основного блока. Автоматическая идентичность основной кнопки учитывает текст, оформление, размер, ширину и форму; смена произвольной картинки или переопределённого цвета ещё не проверена как отдельный сценарий замены. Размер входящего содержимого измеряется внутри пакета; вручную задавать высоту 136/120 или добавлять анимацию в потребителе не требуется. Новая native-запись подтверждает промежуточные положения при изменении высоты и уход старого элемента. Полная motion-приёмка остаётся pending: остальные исходные переходы, точная временная сверка и быстрые прерывания ещё не проверены. [Источники, матрица и ограничения](References/FloatingContainer/2026-10-12/implementation-review.md), [уточнение исходных дорожек](References/FloatingContainer/2026-10-12/PrototypeObservation/reading-review.md), [текущий отчёт](Validation/2026-10-12/FloatingContainerHeight/verification-report.md).

### Textfield: нативный ввод и состояние приложения

`TUITextfield` (`65702:51131`) доступен через публичный пакет и имеет 22 сопоставленных iOS-варианта. Компонент пока `in-progress`: пройдены основные нативные сценарии ввода, очистки, ограничения и Copy в Read-only; полная спецификация и motion ещё требуют завершения. Перед использованием уточняйте актуальный паспорт. Данные, валидация и отправка принадлежат экрану.

```swift
import SwiftUI
import TUIDesignSystem

struct NameForm: View {
    @State private var name = ""
    @State private var fieldState = TUITextfieldState.normal
    @State private var submittedName = ""
    @State private var validationTrigger = 0

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: TUISpacing.x4) {
                TUITextfield(
                    text: $name,
                    state: $fieldState,
                    label: "Имя",
                    placeholder: "Как к вам обращаться",
                    hintText: "Укажите имя для обращения",
                    errorText: "Введите имя",
                    characterLimit: 100,
                    validationTrigger: validationTrigger,
                    returnKeyType: .done,
                    onSubmit: submit
                )
                TUIButton("Продолжить", action: submit)
                if !submittedName.isEmpty {
                    Text(submittedName).tuiTypography(.bodyLarge)
                }
                Spacer()
            }
            .padding(TUISpacing.x4)
            .navigationTitle("Имя")
        }
    }

    private func submit() {
        if name.isEmpty {
            fieldState = .invalid
            validationTrigger += 1
        } else {
            fieldState = .normal
            submittedName = name
        }
    }
}
```

Лимит 100 в примере — решение этого экрана, а не лимит Figma-компонента. Без `characterLimit` ввод не ограничен. Без внешнего `state` компонент по умолчанию управляет своим фокусом; `state` нужен экрану для валидации и выбора режимов. `.readOnly` допускает нативное выделение/Copy без клавиатуры; `.disabled` исключает взаимодействие. Опциональный `action` задаёт режим нажатия без редактора и не подменяет Read-only. Для `show-placeholder=off` передайте пустой `placeholder`, для отсутствующего label — `label: nil`; start/end content задаются слотами. Не добавляйте к полю второй внешний Screen Padding, если он уже задан контейнером формы.

Disabled блокирует также действия вложенных слотов и hint. Нажатие отдельного аксессуара не переводит редактор в фокус. При `isSkeleton: true` применяется общий цикл `TUISkeleton`; `isSkeletonAnimating: false` нужен для статического просмотра/сравнения. Реальная форма через публичный пакет находится в `Examples/ConsumerApp/App/TextfieldConsumerScreen.swift`; компоненты в неё не копируются.

Для повторной валидации увеличивайте `validationTrigger` при каждом ошибочном submit: повторное присваивание того же `.invalid` не меняет Binding. Переход из обычного состояния в invalid уже создаёт один feedback; одновременное изменение состояния и trigger не дублирует событие. Первая ошибка использует 500 мс, повторная — 300 мс, обе с notification-error haptic. Начальный invalid preview и смена invalid ↔ invalidFocus сами по себе не запускают тряску. Точные времена отдельных шагов отсутствуют в прочитанном источнике; распределение по progress пока является выбором реализации и не считается полной приёмкой motion.

Ограничения текущего этапа: полная временная приёмка error shake и остальных переходов, overflow fade, полный selection-background контракт, prefix/suffix, dynamic number, counter и полная настройка hit areas ещё не завершены. Тряска первой и повторной ошибки реализована и измерена в активной нативной сцене; точные времена шагов не подтверждены, а старый deprecated-прототип расходится с текстом Guide по смещениям. Не обходите ограничения копированием реализации в экран или выдуманными параметрами API. Основные источники и проверки: `Documentation/References/Textfield/specification-reading-2026-10-09.md`, `Documentation/Validation/2026-10-09/Textfield/verification-report.md`.

### Textfield: последовательная мобильная форма

Для правил Forms используйте `TUITextfieldForm` и назначьте каждому полю уникальный `.tuiTextfieldFormID`. Порядок задаётся явно. `.boundary` соответствует промежуточному элементу, разрывающему непрерывную группу: «Дальше» закрывает клавиатуру, даже если за границей есть доступные поля. Read-only, disabled и tap-only пропускаются. Последнее поле показывает «Готово». Клавиатура остаётся нативной; отдельные системные компоненты Apple не переносятся в пакет.

```swift
import SwiftUI
import TUIDesignSystem

struct ProfileForm: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var city = ""
    @State private var firstState = TUITextfieldState.normal
    @State private var lastState = TUITextfieldState.normal
    @State private var cityState = TUITextfieldState.normal

    var body: some View {
        NavigationStack {
            TUITextfieldForm(order: [.field("first"), .field("last"), .boundary, .field("city")]) {
                TUITextfield(text: $firstName, state: $firstState, label: "Имя")
                    .tuiTextfieldFormID("first")
                TUITextfield(text: $lastName, state: $lastState, label: "Фамилия",
                             hintText: "Как указано в документах")
                    .tuiTextfieldFormID("last")
                Text("Адрес").tuiTypography(.bodyLarge)
                TUITextfield(text: $city, state: $cityState, label: "Город")
                    .tuiTextfieldFormID("city")
            }
            .navigationTitle("Профиль")
        }
    }
}
```

Контейнер задаёт боковой отступ 16 и промежуток 12, координирует фокус, резервирует место для кнопки над клавиатурой и прокручивает целое поле вместе с hint/error. Не добавляйте повторный внешний отступ к этим полям. Binding состояния должен жить в приложении; бизнес-валидацию координатор не придумывает. Внутри формы Return использует её последовательность; самостоятельное поле сохраняет `onSubmit`.

Нативный consumer `Examples/ConsumerApp/App/TextfieldFormConsumerScreen.swift` проверяет переходы и границы в Day/Night; живой пример доступен в разделе Textfield каталога. Это проверенная композиция, а не новый Component Set или полная приёмка Textfield. Compound/Dropdown/Select из SmartFields, отключение Screen Padding, elevation Floating Container и полная временная сверка переходов остаются UNVERIFIED. [Исходные правила](https://www.figma.com/design/R4dFzxFzgDIGTcdlrqaRpe?node-id=9702-48708) и [протокол проверки](Validation/2026-10-09/TextfieldForm/verification-report.md).

### Button

```swift
import SwiftUI
import TUIDesignSystem

struct CategoryFilter: View {
    @State private var selectedCategory = "Все"
    private let categories = ["Все", "Карты", "Вклады"]

    var body: some View {
        TUIChipGroup(size: .small, scrollable: true) { size in
            ForEach(categories, id: \.self) { category in
                TUIChip(
                    category,
                    size: size,
                    appearance: selectedCategory == category ? .accent : .neutral
                ) {
                    selectedCategory = category
                }
            }
        }
    }
}
```

Группа передаёт размер каждому дочернему чипу через замыкание. Для многострочного режима передайте `scrollable: false`; расположение подстраивается под доступную ширину экрана.

## Card Medium: содержимое и вложенные поверхности

Все 21 применимых исходных варианта перечислены в `TUICardMedium.Variant`; резолвер возвращает точный `variant`. Заголовок, подпись, notification и Pro-текст передаются через публичный API. `cardBackground` заменяет фон, `accessory` — внутреннее содержимое. При замене accessory задайте осмысленный `accessibilityValue`: удалённый исходный badge не озвучивается. Действие и состояние принадлежат приложению; декоративные слоты не создают дополнительных интерактивных элементов внутри кнопки.

При вложении в другую карточку сопоставьте внешний radius и padding с [проверенной таблицей Mobile](References/CardMedium/nested-radius-2026-10-07.md), затем передайте внутренний радиус через `Style.radius` соответствующим токеном. При внешнем radius 24 и padding 12 исходный радиус Card Medium 12 корректен; для других комбинаций проверяйте таблицу и исходный экземпляр. Не выводите радиус из одного названия пресета.

Пример из отдельного приложения — [CardMediumConsumerScreen.swift](../Examples/ConsumerApp/App/CardMediumConsumerScreen.swift), пункт «Card Medium из пакета». Публичный импорт, состояние, действия, ресурсы и нативная шторка [проверены в работающем потребителе](References/CardMedium/consumer-acceptance-2026-10-07.md). Card Medium остаётся `in-progress`: specification, визуальная и полная accessibility-приёмка ещё не завершены.

## Состояние Like принадлежит приложению

Поле `isSelected` в сопоставлении Figma — значение начального состояния. Публичный API принимает `Binding<Bool>`, чтобы нажатие могло изменить выбор:

```swift
import SwiftUI
import TUIDesignSystem

struct FavoriteAction: View {
    @State private var isSelected = false

    var body: some View {
        TUIButtonLike(isSelected: $isSelected, appearance: .secondary, state: .normal)
    }
}
```

`Binding.constant` подходит только для неизменяемого примера состояния. Используйте принадлежащее приложению состояние для рабочего интерфейса. Полный интеграционный пример расположен в `Examples/ConsumerApp`.

## Актуальный объём прототипов

[Решение пользователя от 8 октября 2026](prototype-acceptance-scope-2026-10-08.md): не добавлять специальные механизмы VoiceOver и увеличенные accessibility-шрифты. Перед изменением компонента прочитать его доступную спецификацию целиком. Проверять оформление при обычном размере текста, адаптивность к контенту/ширине, все исходные свойства и состояния, действия и анимации по спецификации. Описанные в этой инструкции уже существующие accessibility API являются справкой, а не обязательной работой для нового прототипа.

## Button: содержимое экземпляра и ресурсы

Все 147 базовых iOS-вариантов сопоставлены TUIButton. Резолвер возвращает параметры размера, оформления, состояния и Skeleton. Проверяйте текущий статус: сопоставление API принято, полный Button ещё in-progress.

Текст и show-label/show-Icon читать у экземпляра макета, а не копировать Label и исходные boolean defaults. Figma Icon соответствует icon для Large/Medium, Icon (16) — smallIcon для Small; это независимые свойства. Передавайте Image точного экспортированного ассета с bundle: TUIResources.bundle. При nil используется исходная звезда. Для многоцветного/фиксированного изображения применяйте iconRenderingMode: .original; template допускает отдельный iconColor. Не подменяйте неизвестный asset системным символом.

Ширина в variantMappings и веб-примерах воспроизводит исходный демонстрационный фрейм. Для нового экрана читайте реальный экземпляр и его Hug/Fill/Fixed. width меняет заливку и область действия самой кнопки; внешний .frame может создавать пустое пространство вокруг Small. При отсутствии исходного переопределения оставляйте width nil и используйте layout контейнера.

Medium по спецификации поддерживает Hug и Fill. Hug уже работает через нативный SwiftUI modifier; новый параметр библиотеки не нужен:

```swift
import SwiftUI
import TUIDesignSystem

struct MediumHugExample: View {
    @State private var didContinue = false

    var body: some View {
        VStack {
            TUIButton("Продолжить", size: .medium) {
                didContinue = true
            }
            .fixedSize(horizontal: true, vertical: false)
            Text(didContinue ? "Действие выполнено" : "Ожидание действия")
        }
    }
}
```

Состояние действия принадлежит приложению. Для Fill оставьте modifier выключенным и задайте ширину родительского контейнера. Для Fixed передайте `width` самой кнопке. При заданном `width` он имеет приоритет; не применяйте Hug одновременно. Проверки normal/pressed/loading/disabled при обычном размере шрифта, обоих текстах, иконке и темах: [ButtonLayout](Validation/2026-10-08/ButtonLayout/verification-report.md).

Сначала выбирайте готовый appearance. При подтверждённой кастомизации используйте TUIColor для backgroundColor/textColor/iconColor; nil сохраняет исходный стиль, цвет текста не меняет иконку. Для круглого Large/Medium задавайте cornerRadius: TUIRadius.round. Small исходно круглый. Подтверждённые источники и ограничения — [API review](References/Button/customization-api-review-2026-10-08.md), точные instance properties — [property map](Validation/2026-10-08/ButtonCustomization/instance-property-map.json).

Полный рабочий пример с загрузкой, тремя размерами и ресурсами пакета — [ButtonConsumerScreen.swift](../Examples/ConsumerApp/App/ButtonConsumerScreen.swift), пункт «Button из пакета» отдельного приложения. Состояние и результат действия принадлежат приложению. Loading сохраняет размеры и доступный Button, подавляя повторные вызовы. Второй лейбл относится к отдельному набору 51388:47169; не имитируйте его обычным title.

## Loader: состояние и минимальная видимость

Пять исходных размеров доступны в `TUILoaderSize`; `figmaNodeID` сохраняет точный базовый вариант. Цвет, диаметр и толщина — переопределения экземпляра по Guide. По умолчанию компонент анимируется; `isAnimating: false` предназначен для просмотра исходного статического контура. Не используйте остановку как предположение об отдельном Figma state.

### Sensitive Mode внутри текста и компонентов

Пиксельный набор `46866:304541` представлен `TUISensitiveMode` и пятью значениями `TUISensitiveFontSize`, включая исходное `Font Size5`. Размер по умолчанию совпадает с исходным frame; для существующего блока используйте `.tuiSensitive(isHidden:color:cornerRadius:)`, чтобы сохранить его фактическую ширину/высоту и действие. При маскировании всего бейджа передавайте его радиус.

`TUISensitiveText` заменяет глифы в нативной раскладке. Его удобный инициализатор принимает полный текст и скрываемую подстроку; маскируются все буквальные вхождения, пустая строка оставляет текст видимым. Для разных цветов или ссылки поместите отдельные `Text(...).tuiSensitive(isHidden:color:)` в интерполяцию `Text` и оберните её в `TUISensitiveText`. Цвет скрытого фрагмента передаётся явно. Сам атрибут на `Text` без `TUISensitiveText` не заменяет нативное отображение — контейнер обязателен.

В Button используйте `sensitiveText:`. Остальная надпись, кернинг, ширина, fade, загрузка, скелетон и действие остаются у существующего `TUIButton`; не собирайте второй вариант кнопки из HStack. Полный потребитель — [SensitiveModeConsumerScreen.swift](../Examples/ConsumerApp/App/SensitiveModeConsumerScreen.swift). Пример сохраняет действие кнопки, целого блока и переход по скрытой части ссылки.

Механизм соответствует прочитанной функциональной пиксельной спецификации. Исходный дизайнерский placeholder с blur и новый частичный particle-эффект TUI Labs не подменяют runtime. Motion и полная визуальная приёмка набора ещё **UNVERIFIED/pending**; проверяйте актуальную запись реестра перед использованием в принятом сценарии.

Владелец экрана управляет загрузкой и её минимальной видимостью. Loader не может задержать удаление родителем. Для быстрого результата сохраняйте состояние загрузки минимум `TUILoader.recommendedMinimumVisibleDuration` (500 мс) после появления индикатора. Полный рабочий пример с отменой Task при уходе — [LoaderConsumerScreen.swift](../Examples/ConsumerApp/App/LoaderConsumerScreen.swift). Его сборка и два запуска проверены отдельно: [отчёт](Validation/2026-10-09/Loader/verification-report.md). Анимация текущей реализации соответствует текстовым 4 с trim / 2 с rotation; связанный прототип противоречит этому источнику. Проверяйте актуальную приёмку через резолвер: Loader ещё in-progress.

## Экземпляр компонента в другом файле Figma

Локальный ID узла не переносим между Figma-файлами. Например, на экране зарплатного клуба экземпляр кнопки `19287:38742` ссылается на main component `640:118784` в контексте файла экрана; исходный вариант TUI Mobile — `41658:296907`. Совпадение подтверждено постоянным ключом `9468a94cee29f0e04cae03a174c45b8f971c7846`.

После чтения design context установите main component и его постоянный `key` по доступному ответу MCP или ранее проверенному локальному индексу. Прямой `use_figma` / Plugin API в текущей работе запрещён пользователем, даже для предполагаемого чтения. Если ответ не содержит ключ, оставьте связь UNVERIFIED; не запускайте скрипты в исходном файле. Для уже проверенного ключа выполните:

```sh
python3 Scripts/resolve_figma_node.py --component-key 9468a94cee29f0e04cae03a174c45b8f971c7846
```

Индекс `figma-component-keys.json` сейчас частичный: 14 подтверждённых вариантов: все десять iOS Header Large и четыре другие зависимости исходного экрана. Неизвестный ключ возвращает `unindexed-component-key`; дополните индекс после проверки Figma. Не угадывайте компонент по названию. Ключ определяет исходный вариант, а изменённый текст, изображения, boolean/instance-swap свойства и геометрию берите из экземпляра экрана. Готовность проверяется по текущему паспорту.

## Header Large: текст и состояние accessory

Вариант по умолчанию — `subheaderLeading`, десять вариантов перечислены в `TUIHeaderLarge.Variant`. Текст можно передать как String или AttributedString со ссылками. Системные переключатели и кнопки в accessory передаются через builder; их состояние принадлежит приложению.

```swift
import SwiftUI
import TUIDesignSystem

struct NotificationsHeading: View {
    @State private var receivesNotifications = true

    var body: some View {
        TUIHeaderLarge("Уведомления", subheader: "Получать новости сервиса")
            .accessory(reflowsAtAX1: true) {
                Toggle("Получать уведомления", isOn: $receivesNotifications)
                    .labelsHidden()
                    .accessibilityLabel("Получать уведомления")
            }
    }
}
```

Для переопределения оформления сначала используйте `textStyles` с ролью `TUITypographyRole` и цветом `TUIColor`. Если в исходном тексте задан явный шрифт без роли, `TextStyle.font` принимает UIFont, а `lineHeight` — исходную высоту строки. Значения берите из макета; не подменяйте старый Heading L 30 современным Heading Mobile/L.

Резолвер возвращает `sourceBindingExceptions`: у `18083:44906` отсутствуют исходные привязки title, description и show-icon. В этом варианте читайте фактические characters и visibility слоёв экземпляра. Прочитанное значение свойства само по себе не подтверждает содержимое. Header Large принят по полному паспорту; доказательства и границы контракта — `References/HeaderLarge/final-acceptance-2026-10-06.md`. При каждом использовании резолвер проверяет актуальность исходников.

Для символа, участвующего в переносах текста, используйте `titleInlineText(Text)` или `secondaryInlineText(Text)`. Header применяет к такой композиции своё шрифтовое лицо, размер, tracking, цвет и line boxes. Композицию создавайте через интерполяцию SwiftUI Text, которая поддерживает изображения; конкатенация Text устарела в iOS 26. Изображение берите из исходного Figma asset, а его смысловую подпись задавайте согласно макету. Отдельный trailing-slot не является символом в потоке многострочного текста.

`titleLeading`/`titleTrailing` и secondary-slots по умолчанию центрируются по полной высоте своего label. Выравнивание можно изменить через `textSlotAlignments`. Это отличается от mobile accessory, которому по умолчанию задан центр первой строки; для Link accessory используйте `.firstBaseline`. На AX1 opt-in reflow переносит accessory после текста, включая description, с токеном gap 8. Центрированные заголовки по руководству предназначены для композиции без accessories.

По умолчанию текст переносится без ограничения числа строк (`.multiline`). Принятый `.multilineFade(lineLimit: 3)` в `TextStyle.overflow` ограничивает высоту тремя строками и применяет fade к последней строке, включая inline-изображения. Уместившийся текст сохраняет естественную высоту. Число строк должно быть положительным и взятым из макета. Последняя видимая строка продолжается в fade без добавленного многоточия; явный новый абзац не склеивается с ней. Нативный кадр и проверки описаны в `References/HeaderLarge/continuous-fade-review-2026-10-06.md`. Видимый фрагмент частичной ссылки в последней строке сохраняет физическое действие. URL из AttributedString доступны как дополнительные действия полного текстового элемента, включая обычный multiline и single-line режимы; действия title/subheader объединяются в heading, description остаётся отдельным элементом. `.singleLineFade` оставляет отдельный trailing-slot видимым. Оба ограничения сохраняют полный доступный label и ограничивают область фокуса видимой геометрией. Окончательная приёмка Header определяется паспортом.


Для встроенных ссылок передавайте AttributedString. Непрозрачные URL внутри произвольного `Text`, переданного через `titleInlineText`/`secondaryInlineText`, не анализируются: этот вход предназначен для композиции с inline-символом. Произвольный View в `titleContent`/`secondaryContent` принадлежит приложению вместе с типографикой, overflow и доступностью. Не переносите на него обещания проверенного AttributedString-контракта автоматически.
