# Button: спецификация и первая исправленная ошибка

Полная приёмка **UNVERIFIED**. Прочитаны части [отдельного руководства tui-button](https://www.figma.com/design/HErJrp1BcNRUFCyg3QccuG/tui-button?node-id=1-3) через Figma Desktop MCP. Исходный [Component Set](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=41658-296906) содержит 147 применимых iOS-вариантов; текущая реализация используется повторно.

## Подтверждённые правила

- [Размеры, 81:48206](https://www.figma.com/design/HErJrp1BcNRUFCyg3QccuG/tui-button?node-id=81-48206): мобильная платформа имеет три размера; четвёртый относится к desktop.
- [Состояния, 81:48109](https://www.figma.com/design/HErJrp1BcNRUFCyg3QccuG/tui-button?node-id=81-48109): контейнер сохраняет размер при загрузке. В iOS pressed меняет подложку мгновенно; Android использует ripple, его нельзя переносить в iOS. Hover и keyboard focus описаны для desktop. Disabled недоступен для нажатия, остаётся доступен для screen reader, цвета назначены индивидуально.
- [Корнер-кейсы, 130:282986](https://www.figma.com/design/HErJrp1BcNRUFCyg3QccuG/tui-button?node-id=130-282986): невмещающийся мобильный текст фейдится. Большая иконка уменьшается до контейнера; маленькая сохраняет собственный размер внутри контейнера.
- [Масштабирование iOS, 25085:11908](https://www.figma.com/design/HErJrp1BcNRUFCyg3QccuG/tui-button?node-id=25085-11908): текст использует Dynamic Type; иконка увеличивается в AX1; высота адаптируется к label с минимальными отступами, сохраняя минимальную высоту. Невмещающийся label фейдится. Плагин масштабирования показывает принцип и не гарантирует совпадения с runtime — [25085:11906](https://www.figma.com/design/HErJrp1BcNRUFCyg3QccuG/tui-button?node-id=25085-11906).
- [Озвучивание icon-only, 25085:11915](https://www.figma.com/design/HErJrp1BcNRUFCyg3QccuG/tui-button?node-id=25085-11915): предусмотрены содержательный Label, trait «Кнопка» и Default hint. Также прочитана первая строка с обычным label, 25085:11916.

MCP вернул полные контексты для этих узлов; они сохранены в `Documentation/Inventory/2026-10-08/button-spec-…-context.json`, изображения — рядом с этим отчётом, исходные SVG/PNG — в `DesktopAssets`. Материал относится к iOS и другим платформам одновременно; платформенные требования нужно разделять при реализации.

После ограничения MCP схема 25085:11909 прочитана через навигацию по слоям в нативном приложении. [Крупный фрагмент iOS](ios-ax1-large-medium-native-2026-10-08.jpg) показывает масштаб иконки 1.25× в AX1, минимальные вертикальные отступы Large 8 pt и Medium 6 pt, горизонтальные отступы Large icon-only 13 pt в AX1. [Продолжение той же схемы](ios-ax1-insets-native-2026-10-08.jpg) показывает Medium icon-only 7 pt, Small — минимальные вертикальные 2 pt и icon-only горизонтальные 5 pt в AX1. Это наблюдаемые аннотации именно в iOS-части схемы; соседняя Android-часть не служит источником iOS-поведения. Правило для размеров выше AX1 в прочитанном фрагменте явно не определено, его нельзя считать подтверждённым cap.

## Исправление loading

Раньше normal label/icon заменялись спиннером в HStack, и Small терял ширину исходного содержимого. Теперь label/icon остаются в layout невидимыми, спиннер накладывается по центру. Публичный API сохранён; loading и skeleton по-прежнему запрещают нажатие. Кнопка сохраняет содержательное accessibility label при скрытом визуальном тексте; русское accessibility value «Загрузка» — текущее решение реализации, не дословное требование ещё не прочитанной строки спецификации loading.

Проверка: [2 теста, 0 ошибок](../../Validation/2026-10-08/ButtonLoading/package-test-summary.json), iPhone 17 Pro, iOS 26.4.1. Сохранение размеров подтверждено для 12 оформлений × 3 размеров × 3 комбинаций label/icon × 2 тем = 216 пар normal/loading. [Нативные изображения](../../Validation/2026-10-08/ButtonLoading/Native/manifest.json) просмотрены; [каталог собран](../../Validation/2026-10-08/ButtonLoading/catalog-build.log). [Хеши](../../Validation/2026-10-08/ButtonLoading/input-hashes.json) фиксируют проверенную версию.

Эта проверка сравнивает normal/loading в коде и не подтверждает соответствие всех 147 вариантов Figma. Day/Night в тесте — окружение renderer, не доказательство правильности ночных цветов: текущий импорт Button содержит фиксированные fills и требует проверки bindings.

## Оставшаяся сверка

Стили, построение, дополнительные возможности, полное озвучивание, редакционные правила и правила использования ещё не прочитаны целиком. Несколько больших фреймов MCP вернул только как структуру. При чтении следующих дочерних узлов сервис сообщил `Rate limit exceeded, please try again tomorrow`; это ограничение извлечения, а не отсутствие страниц спецификации. [Схема iOS обнаружена в нативной навигации](ios-scaling-native-navigation-2026-10-08.jpg), node 25085:11909.

По уже прочитанным требованиям требуют реализации и проверки: Dynamic Type с адаптивной высотой; fade; public instance-swap иконки с правилами размеров; ночные bindings; мгновенный pressed; полное accessibility-поведение. Анимация loader, Reduce Motion, skeleton, custom content, glass, тени и соответствие шрифта остаются UNVERIFIED до содержательной сверки. Состояние complete не присваивалось.
