# Textfield — текущая проверка, 2026-10-09

Статус: **in-progress**, не complete. Интеграция текущего публичного API проверена; полная приёмка спецификации, кастомизации, визуального оформления и движения остаётся pending. Figma только читалась. Основной Guide, девять схем, актуальная матрица, Variables, ассеты и связанные quantity/SmartFields материалы изучены до соответствующей реализации. Первоисточники: `Documentation/References/Textfield/specification-reading-2026-10-09.md`.

## Реализация и исправления

`TUITextfield` использует нативный UITextField для ввода, клавиатуры, composing text, курсора, выделения и Copy. Оформление, label, clear, hints, ограничения, Loader и слоты находятся в пакете. Есть 22 точных iOS mappings; другим сочетаниям API не назначаются выдуманные Figma ID. Android не реализуется. Исключение системных компонентов Apple не исключает нативный редактор внутри кастомного TUI.

Пустые focus/invalid-focus без label показывают Placeholder, Text/Secondary. Пустой invalid без label (`65702:51231`) показывает Label, Text/Negative. Legacy line boxes: label 16 pt, value 20 pt. У пустого focused placeholder исходное перекрытие курсора: cursor 2 pt, margin −1 pt, начало placeholder x=1. Это локальные измерения Textfield, не изменения глобальных токенов.

Read-only сохраняет нативное выделение и Copy, скрывая клавиатуру и команды редактирования/AutoFill. Проверен переход уже активного редактора в read-only, двойной тап для выделения слова, Copy → Paste и затем disabled. Disabled блокирует всё дерево, включая пользовательские start/end кнопки, hint и tap-only. Нажатие отдельного аксессуара не фокусирует редактор и не вызывает действие всего поля. Действия подтверждены UI-тестами, а не только наличием callback.

Skeleton переиспользует `TUISkeleton`, сохраняя радиус исходного skeleton-варианта 12 pt и адаптивную ширину. Обычный контейнер имеет радиус 16 pt. `isSkeletonAnimating` по умолчанию true; source-mode и статический копируемый пример явно используют false. Восемь временных снимков подтверждают изменение пикселей живого цикла, но не являются полной временной приёмкой Textfield.

Независимая форма обнаружила зависание после submit и добавления результата в VStack. Native sample `consumer-submit-hang.sample.txt` подтверждает updateUIView → resignFirstResponder → SwiftUI responderNode → повторное обновление AttributeGraph. Изменения firstResponder, native enabled и reloadInputViews теперь выполняются после синхронного обновления SwiftUI на следующем проходе main queue, с объединением запросов и последними flags. Исправленная форма проходит submit в обеих темах; переходы read-only/disabled также проверены. Системная скорость анимаций не изменена.

Исправлена потеря существующего suffix при вводе в середине полного поля. Лишний одиночный символ отклоняется без изменения значения/ошибки. Длинная вставка ограничивает только заменяемый фрагмент, сохраняя остальные символы и UTF-16 позицию курсора. Уже завершённый composing text обрабатывается по изменённому фрагменту. Unicode-тесты включают emoji и combining characters. Это проверка delegate/commit, не прогон всех языковых клавиатур.

## Feedback валидации

После чтения текущего Guide реализован `validationTrigger`: consumer увеличивает его на каждом ошибочном submit. Переход в invalid создаёт первое событие; изменение состояния и trigger вместе не дублирует его. Первый feedback: 0 → −3 → +3 → −3 → +3 → 0 pt, 500 мс; повторный: 0 → −3 → +3 → 0 pt, 300 мс. Используются существующие slow/moderate и productive-standard tokens, SwiftUI keyframeAnimator и notification-error haptic. Начальный invalid, смена invalid ↔ invalidFocus, disabled/read-only и Skeleton не запускают feedback. Возврат из ошибки прекращает смещение. В каталоге и независимой форме есть повторная валидация без смены Binding.

Точные времена отдельных шагов отсутствуют в доступном тексте. Равномерные узлы progress с productive-standard easing — явно зафиксированный выбор реализации, **не подтверждённая полная спецификация**. Whole-field/hint scope также требует сверки. В старом прототипе с `[deprecated] tui-textfield` обнаружены −4/+2 pt вместо −3/+3 pt на отдельных кадрах. Он прочитан как исторический источник, не перенесён; текущий код следует тексту Guide. `get_motion_context` вернул пустой список tracks, что не отменяет прочитанную текстовую спецификацию.

`ErrorMotionNativeVerified/samples.json` содержит **114 настоящих CADisplayLink измерений** координат нативного UITextField. Проверка `Scripts/verify_textfield_error_motion.py` подтверждает два/один цикла, ограничение амплитуды, возврат в исходное положение и отсутствие новой тряски при смене фокуса/сбросе. Первое движение до ±3 pt, последнее ненулевое смещение через 524.6 мс от события; повторное — до ±2.67 pt в выборке, последнее через 323.8 мс. Эти времена включают dispatch/render и округление пикселей, а не означают точное измерение 500/300 мс. Физический haptic в Simulator не проверяется.

`ErrorMotionNativeVerified/validation-feedback.mp4` — настоящий пятисекундный фрагмент simctl записи. Trim выполнен AVFoundation passthrough без изменения скорости, дорисовки или наложений; исходные 74.5–79.5 с и 11 извлечённых кадров сохранены в `recording-preparation.json`. Этот фрагмент используется в веб-каталоге; он не выдаётся за веб-компонент.

## Проверки текущей версии

| Запуск | Результат | Что подтверждено |
| --- | --- | --- |
| `validation-package-summary.json` | **13 passed**, 0 failed/skipped | 11 TextfieldTests, включая motion sequences/tokens/bounds, 22 IDs, состояния, размеры/ширины и Unicode/лимит. Публичный NameForm с повторной валидацией и 312 уникальных примеров веб-каталога компилируются. |
| `validation-native-summary.json` | **3 passed**, 0 failed/skipped | Повторный ошибочный submit, ввод Alice, сброс/Done/результат/закрытая клавиатура в независимой форме Day/Night; активный read-only → selection/Copy/Paste → disabled; запуск motion probe. Точная геометрия проверяется отдельно по 114 samples. |
| `validation-matrix-summary.json` | **2 passed**, 0 failed/skipped | Все 22 iOS варианта в Day/Night; custom start/end/hint и tap-only actions, включая полную блокировку disabled. |

Пакет и каталог собраны этими успешными test-запусками. Независимый consumer собран отдельно (`validation-consumer-build.log`) и установлен до native suite; он импортирует публичный пакет без копий реализации. Конфигурация: iPhone 17 Pro, iOS Simulator 26.4.1, device `6D3F35A1-AC30-4F0E-BDD6-0F912B714E59`, scale 3, Xcode 26.4.1, `CODE_SIGNING_ALLOWED=NO`, `-skipPackageUpdates`. Команды: `validation-run-commands.json`; текущие API/dependency hashes: `validation-verified-versions.json`.

Текущий Skeleton внутри Textfield дополнительно прошёл `validation-skeleton-summary.json`: 1 passed, 0 failed/skipped, восемь живых кадров. Отдельная регрессия прежнего Skeleton QA route также прошла; см. `../TextfieldSkeletonRouteRegression/summary.json`. Production Skeleton не изменялся.

## Предыдущие запуски

Эта таблица сохраняет предыдущие версии и отдельные регрессии; её результаты не подменяют текущую приёмку.

| Запуск | Результат | Что подтверждено |
| --- | --- | --- |
| `package-input-quality-summary.json` | **11 passed**, 0 failed/skipped | Девять TextfieldTests: 22 IDs, состояния, меню, focus/reset, размеры всех вариантов в обеих темах и ширины 200/390/600, Unicode/лимит/сохранение suffix. Точный публичный NameForm из инструкции компилируется; 312 уникальных примеров веб-каталога компилируются. |
| `input-quality-native-summary.json` | **2 passed**, 0 failed/skipped | Текущая версия: реальный лимит редактора и независимая форма в Day/Night — пустой submit, ошибка, ввод Alice, сброс ошибки, Done, показ результата, закрытая клавиатура. |
| `active-readonly-summary.json` | **1 passed**, 0 failed/skipped | Активный редактор → read-only → native selection/Copy → Paste → disabled, без клавиатуры в неразрешённых состояниях. |
| `nested-actions-summary.json` | **3 passed**, 0 failed/skipped | Ввод/clear/submit; пользовательские start/end/hint actions и tap-only, вся блокировка disabled; read-only Copy/Paste. |
| `skeleton-matrix-summary.json` | **2 passed**, 0 failed/skipped | Матрица Day/Night и живой Skeleton. |
| `focus-regression-initial-summary.json` | **6 passed, 1 failed** | Consumer, input, limit, custom actions, matrix и Skeleton прошли. Read-only проверка использовала long-press уже активного редактора, который входил в режим перемещения курсора. Исправленная проверка с native double-tap прошла отдельным запуском выше. Весь первоначальный suite не объявляется успешным. |

## Визуальная сверка

Последняя полная матрица — `ValidationMatrixVerified`: **44 настоящих PNG текущей версии**, 22 iOS варианта × Day/Night, оба теста запуска прошли. Размеры 960×168 либо 960×294; в 16 focused снимках подтверждён настоящий UIKit caret. Crop округлён до физических пикселей; после захвата текст, курсор и цвета не дорисовываются.

`ValidationComparison` содержит индекс 44 кадров, сравнение 22 Day-пар и просмотренный контактный лист. Native 3x уменьшен до масштаба Figma 1x через LANCZOS; без сдвига, коррекции RGB или автоматической приёмки. Максимальное среднее абсолютное RGB-расхождение — **1.5202566964 / 255**. Метрика диагностическая, не критерий допуска. Остаются различия растеризации букв/курсора и округления Neutral 1. Совпадение типографики не объявлено.

Предыдущие `FocusRegressionInitial`, `FocusRegressionComparison` и `focus-native-input-versions.json` сохранены как история; новым checksum не перезаписаны.

Точных Night экспортов Figma ещё нет: **UNVERIFIED**. У `65702:51258` root шириной 320, но error-container x=16 / width=320 выходит до 336. Исходный PNG 336×98 сохранён. Для диагностического сравнения справа дополнен только белый canvas на 16 px; белая область Figma проверена. Текст не растянут, противоречие bounds остаётся открытым.

## Не завершено

Полная временная приёмка first/repeated error shake, точные времена шагов, scope hint и расхождение исторического прототипа с текстом Guide; анимации hints/clear/state; native overflow fade и selection-background token; полная кастомизация аксессуарных hit areas и отключение внешнего отступа; counter; применимость prefix/suffix и dynamic number к отдельным наборам; полное property mapping. Правила форм найдены на странице 9702:48708 и прочитаны вместе с 12 схемами: `forms-reading-2026-10-09.md`. Реализация form coordinator («Дальше»/«Готово», непрерывные группы, пропуск неактивных полей и автопрокрутка) остаётся pending; связанные правила dropdown/select — UNVERIFIED. Распространение legacy SF-шрифтов остаётся общим нерешённым условием поставки. Расширенная accessibility исключена пользователем; это waiver, не результат тестирования.

## История неудачных проверок

Прозрачные layer.render PNG без активной сцены не являются visual evidence и не публикуются. Первый consumer UI-запуск произошёл после неуспешной установки приложения: проверялась прежняя версия, он не принят. Последующий запуск с корректной установкой обнаружил описанное реальное submit-зависание; сохранён sample. Его неудачный запуск не стал доказательством исправления. Отдельная read-only ошибка в FocusRegressionInitial сохранена вместе с результатом повторной успешной проверки. Неудачные записи видео не являются motion evidence.
