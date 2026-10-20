# Textfield и мобильная форма: проверка 12 октября 2026

Статус Textfield: **in-progress**. Интеграция текущего публичного API проверена; полная визуальная/specification/motion приёмка не завершена. Проверенная форма не является новым Component Set и не увеличивает количество complete.

## Что реализовано и проверено

Публичный `TUITextfieldForm(order:content:)` использует пакетные TUITextfield и TUIButton. `.tuiTextfieldFormID` связывает поля с явной последовательностью; `.boundary` разрывает непрерывную группу. Значения и валидация принадлежат приложению. Код компонентов не копируется в consumer.

В Day/Night проверены последовательные переходы, пропуск read-only/disabled/tap-only, сохранение видимой клавиатуры, «Дальше» на границе группы без перехода через неё, «Готово» последнего поля, закрытие при тапе в видимый промежуток и прокрутка целого поля вместе с hint. Отдельно проверена внешняя смена активного поля в read-only/disabled: кнопка навигации исчезает, нативное выделение/Copy в read-only сохраняется.

Кнопка над клавиатурой — accent/medium, Hug, 44 pt высотой. В сценарии с hint: ширина поля 370, полная высота 98 (56 + 42), layout y=369, нижняя граница 467; кнопка y=479, высота 44, ширина 92; начало полной клавиатуры со строкой predictions y=539. Промежутки: **12 pt между полем и кнопкой, 16 pt до клавиатуры и справа**. Данные двух тем находятся в `FinalNative` как textfield-form-geometry. AX-рамка поля имеет высоту 86 и не включает нижний пустой padding; она сохранена отдельно и не подменена. Проверка использует настоящий SwiftUI layout, записанный consumer через onGeometryChange.

Нативный live demo открывается из раздела Textfield каталога, принимает ввод и меняет Day/Night. Независимый consumer содержит десять полей и импортирует публичный пакет. В `Documentation/assembling-screens-from-figma.md` есть полностью компилируемый ProfileForm; оба документированных примера проверяются package-тестами.

## Исправленные причины и история

- Queued resign старого редактора закрывал клавиатуру при передаче фокуса. Переход теперь передаёт native first responder из пользовательского действия вне updateUIView; async synchronization самого редактора сохранена.
- Повторное вычитание safeAreaInsets давало нулевой viewport при клавиатуре. Используется уже уменьшенный размер ScrollView в его именованной системе координат; исходный диагностический журнал сохранён 9 октября.
- Medium Fill заменён штатным Hug через fixedSize, без нового аналога кнопки.
- При read-only иногда показывался системный word-correction popover «No Replacements Found». Диагностика подтвердила корректные стандартные UICommand Copy, но отдельный попап замены. Autocorrection/spellchecking отключены только для read-only; editable сохраняет default. Copy → Paste реально выполнен; меню Cut/Paste/AutoFill/Replace в read-only отсутствует. Это техническое решение ограничения ввода, не выдуманное правило Figma об орфографии.
- UIKit closing transition проверяется ожиданием фактического исчезновения клавиатуры/контрола. Скорость системных анимаций не меняется.

Первоначальный текущий suite: 9 native passed / 1 failed (`native-summary.json`, `NativeRun`). Предыдущие ложноположительные и неудачные результаты 9 октября находятся в `Documentation/Validation/2026-10-09/TextfieldForm`; не принимаются как доказательство исправленной версии. Диагностическое логирование удалено из компонентов.

## Тесты и версии

`final-package-summary.json`: **19 passed / 0 failed** — Textfield, form navigation/geometry/dynamic eligibility, два публичных примера, 312 SwiftUI-примеров веб-каталога и Medium Hug/Fill. `final-native-summary.json`: **11 passed / 0 failed** — независимые формы, live catalog, вся матрица, ввод/clear/submit, лимит, слоты/tap-only, read-only Copy → Paste, disabled, live Skeleton и запуск validation probe. Consumer и catalog собраны отдельно; установка consumer завершилась до запуска тестов.

Команды и вывод находятся в final-*-build.log и final-*-tests.log. `final-source-versions.json` сохраняет проверенные исходники; публичные компоненты/consumer после проверки не изменялись. Более поздняя правка catalog motion recorder отдельно фиксируется в motion-source-versions: синхронное сохранение PNG отключено в измерительном проходе, поскольку давало ~117 ms пробелы CADisplayLink. Это не изменение анимации компонента. Измерение движения и его ограничения документируются отдельно ниже.

## Визуальная сверка

`FinalNative`: 44 PNG активной нативной сцены — 22 iOS-варианта × Day/Night, 3x. `FinalMatrixComparison`: индекс, 22 Day-сравнения с точными Figma PNG 1x и просмотренный contact sheet. Реальные caret присутствуют в 16 focused captures. Без сдвига, перекраски, рисования курсора или автоматической визуальной приёмки. Наибольший mean absolute RGB difference: **1.5202566964 / 255**; это диагностическая метрика, не допуск.

Night source exports ещё UNVERIFIED. Остались различия растеризации шрифта/курсора, вопросы SF font distribution и исходный overflow hint у 65702:51258 (320 pt parent, 336 pt export). История 9 октября сохраняется без замены её версиями текущих исходников.

## Остальные условия приёмки

Полный instance-property mapping; counter, overflow fade/selection-background token; точная кастомизация hit areas и выключаемый Screen Padding; применимость prefix/suffix/dynamic number; связанные Dropdown/Select/compound правила. Анимации hint/clear/label, точные шаги error shake, scope hint и историческое расхождение ±3 с −4/+2 остаются pending. Физический haptic в Simulator не подтверждается.

Связанная спецификация Floating Container найдена на реальной странице 0:1, основные тексты/12 схем прочитаны: `Documentation/References/FloatingContainer/2026-10-12/specification-reading.md`. Одиночная кнопка по триггеру допускает отсутствие fade-подложки; тень Guide не требует. Общие 20 pt в конце обычного скролла не заменяют специальные Forms 12/16 над клавиатурой. Прототипы и вся приёмка Floating Container ещё UNVERIFIED; его специфичные переходы не объявляются пройденными для формы.

Figma не изменялась. 16 system-* наборов Apple исключены; внутри кастомных TUI используются native editor/keyboard/scroll/navigation. Расширенная accessibility исключена пользователем и не считается проверенной. Все 112 кастомных наборов остаются общей целью; этот отчёт не означает готовность всей библиотеки.

## Повторный временной замер

При синхронных PNG в catalog recorder первая observed shake выходила за диагностический допуск: последнее движение 647.2 ms после события. Временные пробелы CADisplayLink после PNG составляли 116.6–133.3 ms; эта запись сохранена как диагностика, не приёмка motion.

Geometry-only rerun выполнен в активной сцене без bitmap/PNG на каждом периодическом захвате. Сохранены 117 реальных координатных samples; проверка observed geometry прошла (`geometry-only-error-motion-measured.json`). Первая ошибка: −3/+2.667 и четыре смены направления, последнее движение 543.7 ms после события; повторная: −2.667/+2.667, два направления, 324.8 ms. Значения включают задержку обработки/display sampling и не заменяют токены 500/300. Focus/reset snapshots имеют нулевое смещение, но этих фаз всего 1/3 samples, поэтому их полная временная приёмка не заявляется. Исходная кривая и точные времена отдельных шагов по-прежнему требуют сверки; физический haptic UNVERIFIED. Тест geometry rerun также прошёл отдельно.
