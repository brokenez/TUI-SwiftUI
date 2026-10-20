# Floating Container: реализация переходов

Дополнение к исходному implementation-review.md. Спецификация и её схемы прочитаны до изменений; исходные файлы Figma не менялись. Статус полной приёмки — **in-progress**.

Источник правил: [Behavior, 4351:40803](https://www.figma.com/design/jvYMs0sCSCZCHEFrRcL4vW/tui-floating-container?node-id=4351-40803), сохранённые remote/static contexts и Screenshots/4351-40803.png. Точный набор и варианты Mobile остаются прежними: 44286:299509 и шесть применимых iOS ID. Связанные ссылки и ограничения находятся в observed-links.json и implementation-review.md.

| Сценарий из Guide | Параметры источника | Реализация |
| --- | --- | --- |
| Показ/скрытие основного блока | expressive-entrance 500 ms / productive-exit 200 ms | Фаза нативного Transition, движение к фактической нижней границе окна |
| Замена основной кнопки одинаковой формы | productive-exit 75 ms | Fade двух идентичностей внутри стабильного primary slot |
| Элемент другой формы | productive-exit 200 ms / expressive-entrance 500 ms | Независимые removal/insertion фазы; смена размера/ширины/радиуса основной кнопки |
| Secondary ↔ legal | productive-standard 200 ms in / 300 ms out | Раздельные fade фазы при неизменном родительском slot |
| Появление/уход второстепенного элемента и подложки | expressive-entrance 500 ms / productive-exit 200 ms | Движение secondary/legal row и подложки; primary не пересоздаётся |

Кривые берутся из импортированных Primitive Variables: expressive-entrance (0.35, 1.3, 0.25, 1), productive-exit (0.2, 0, 1, 1), productive-standard (0.2, 0, 0.4, 0.9). Значения 200 ms задаются явно по Guide; Primitive/fast 150 ms не используется как их замена. Глобальная скорость iOS-анимаций не меняется. Не добавлены задержки или последовательность, не указанные в доступной спецификации.

Конструктор action-вариантов объединён с необязательными secondary/legalText, сохранив вызовы существующих клиентов. Это позволяет сохранять identity при выборе разновидностей. Автоматическая primary identity учитывает заголовок, appearance, размер и параметры формы; loading/disabled не запускают замену. Не проверены отдельные замены произвольного Image и цветовых overrides. Произвольный footer можно заменить через replacementID/replacementKind модификатора; полное временное измерение этих дополнительных публичных параметров ещё pending.

SwiftUI-фазы различают появление и уход и используют scoped animation, чтобы родительский layout не удлинил 200 ms до 500 ms. Проверенная поверхность API: [TransitionPhase](https://developer.apple.com/documentation/swiftui/transitionphase), [animation(_:body:)](https://developer.apple.com/documentation/swiftui/view/animation%28_%3Abody%3A%29). Замыкания scoped body объявлены Sendable: в пробной версии MainActor-изоляция вызвала подтверждённый native crash во время асинхронного обновления SwiftUI graph. История и исправленный полный прогон сохранены в отчёте.

Повторное чтение get_motion_context для Guide и трёх доступных linked nodes снова вернуло nodes:[]; четыре исходных ответа сохранены как motion-recheck-*.json. Это **не доказательство отсутствия анимаций** в прототипах. Полные динамические связи между кадрами, два недоступных linked nodes и master/Variables graph остаются UNVERIFIED.

Фактические десять переключений записаны в Simulator; измерения и результаты сборки/тестов — [текущий отчёт](../../../Validation/2026-10-12/FloatingContainerMotion/verification-report.md). Выявленные скачки размещения при изменении высоты не скрываются и не объявляются принятой анимацией. Исходный отчёт FloatingContainer остаётся историей предыдущей версии.
