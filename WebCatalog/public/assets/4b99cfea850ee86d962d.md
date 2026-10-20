# Floating Container: переходы и текущая проверка

Результат: реализованы пять типов переходов из доступного Behavior Guide, добавлены смена основной кнопки и стабильная identity дополнений в живом каталоге. Подтверждены сборки, конечная геометрия, действия и повторные переключения. **Полная motion/visual/specification приёмка остаётся pending; компонент in-progress.** Figma не изменялась, системные Apple-наборы не переносились.

[Источники, параметры, текущий API и ограничения](../../../References/FloatingContainer/2026-10-12/motion-implementation-review.md). Предыдущий отчёт в ../FloatingContainer описывает предыдущую версию и сохраняется как история.

## Фактические проверки финальной версии

- [5 пакетных тестов, 0 ошибок](package-summary.json): четыре FloatingContainerTests повторно проверили шесть source ID, высоты, адаптивные ширины/слот, градиент и legal; один WebCatalogExamplesTests скомпилировал/отрендерил все **318** копируемых SwiftUI-примеров публичного пакета. Это пять тестов, а не 318 отдельных приёмок.
- [6 native-тестов, 0 ошибок](native-summary.json): три FloatingContainerUITests проверили закрепление при скролле, 20 pt end gap, поля 16, высоту 56 и gap 8, Day/Night, loading/disabled, повторное скрытие и реальные действия после замены primary и secondary/legal. Один FloatingContainerConsumerUITests проверил независимый публичный потребитель в обеих темах. Два TextfieldFormConsumerUITests проверили существующие keyboard/navigation/boundary сценарии после сборки обновлённого модуля.
- [Сборка standalone каталога](catalog-build.log) и [независимого потребителя](consumer-build.log) прошли. [23 теста метаданных/скриптов](script-tests.log) прошли. Новые скрипты компилируются, git diff --check не обнаружил ошибок whitespace.
- [10 финальных пакетных изображений пяти action/legal вариантов Day/Night](Package/manifest.json) и [native-attachments](Native/manifest.json) сохранены из actual XCTest. Они не объявляются полной визуальной приёмкой. Прежние source PNG/ограничения checkerboard и 1x/3x остаются в исходном отчёте.

## Запись и наблюдения

[Полная native-запись](final-native.mp4), [новые события завершившегося сценария](final-events.json), [исходные PNG и timestamps](FinalFrames/frames.json), [пиксельные измерения](final-measurement.json), [контактный лист](final-measurement.png). Пробник меняет только состояние потребителя; компоненты и анимации не скопированы из пакета в пробник. Ни кадры, ни исходная запись не ретаймятся и не дорисовываются.

Для каталога экспортирован [12.05 s фрагмент](floating-transitions.mp4) через AVFoundation passthrough; [параметры экспорта](recording-preparation.json). Для измерений используется полная исходная запись, а фрагмент — только для воспроизведения.

Зафиксированы десять операций: show primary, две same-shape replacements, large → small → large, show secondary, secondary → legal → secondary, hide secondary, hide primary. Финальный сценарий завершился и записал новый payload consumerContainer; нового crash report не появилось. Изображения показывают fade, раздельные in/out движения и overshoot expressive-entrance.

У быстрого fade сохранены по шесть кадров; у более медленных переходов — 14–32. Максимальные интервалы активных кадров 20–37 ms в зависимости от операции; средняя fps всего ролика с паузами не служит точностью измерения. Первый rendered stage marker является кадром изменения, **не точным моментом старта анимации**. [Сравнение двух presence-кривых без сдвига времени](presence-curve-diagnostic.json) даёт максимальные ошибки 8.64/9.05 pt. Возможный вклад задержки compositor на один кадр — предположение, не исправление данных и не основание для passed.

**Открытые расхождения:** при смене размера исходный primary меняет размещение скачком на 26 pt; добавление secondary сдвигает primary на 56 pt сразу; переходы legal/secondary меняют высоту на 16 pt. Source text задаёт движения элементов, но точная координация изменения layout со связанными прототипами ещё не прочитана/проверена. Непрерывность placement и полная временная сверка должны быть завершены до motion passed. Замена произвольных Image/color overrides и helper replacementID/replacementKind тоже не имеют отдельного полного временного прогона.

## История диагностики

- initial-native.mp4/InitialFrames показывают, что removal при different shape наследовал entrance 500 ms. initial package/native тесты проходили, но это не означало правильную анимацию. Фазовые переходы разделили source durations и довели движение до нижней границы реального окна.
- phase-native.mp4/PhaseFrames и phase-events.json содержат полный промежуточный прогон. Скачки layout остались, поэтому он не считается полной приёмкой.
- scoped-native.mp4 оборвался на третьем этапе. [Фактический crash](scoped-crash-summary.json) показывает MainActor queue assertion внутри scoped animation body в асинхронном обновлении SwiftUI graph. Sendable-замыкания исправили изоляцию; финальный полный прогон и шесть native-тестов прошли. scoped-events-stale-from-phase.json явно помечен как старый payload предыдущего запуска, **не данные этого неудачного прогона**.
- simctl сначала отклонил относительный путь RenderServer error 2; запись с абсолютным путём работает. Это инфраструктура записи, не ошибка принятого рендера. Sandbox также не дал xcresulttool создать TestReport; разрешённый повтор извлечения подтвердил реальные Passed summaries. Никакие эти ошибки не считались успешными проверками.

Повторные Figma motion MCP ответы nodes:[] не подтверждают отсутствие прототипных взаимодействий. Два недоступных linked nodes, граф source Variables, Night-эталоны, SF typography/distribution и full Button acceptance остаются открытыми. Accessibility исключена решением пользователя, не выдаётся за проверенную. Цель библиотеки остаётся активной.
