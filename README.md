# TUI Design System for iOS

Самостоятельный Swift Package, собранный по библиотекам TUI Mobile, TUI Assets и TUI Foundations. Он не зависит от приложения «Зарплатный клуб».

## Источники

- Components: `OBPLqL8JDThLuOP8M4JzBL`
- Assets: `R1oI4T6X9CHxl2x55MDypT`
- Foundations: `gGt4PaQxQhX7ozPVImsgL5`

Минимальная версия — iOS 26. Компоненты используют нативные SwiftUI-контейнеры и системную навигацию. Полный снимок переменных Figma хранится в `Sources/TUIDesignSystem/Resources/Metadata/figma-foundations.json`; каталоги компонентов и ассетов — рядом с ним.

В проекте сохранены 957 variables, 128 component sets, все 3 927 вариантов и индекс 3 518 ассетов. Из них 2 008 вариантов относятся к iOS, включая варианты, помеченные в Figma как iOS 18, iOS 26 или общие для платформ. `Documentation/component-coverage.json` хранит статус переноса каждого компонента. Наличие записи в каталоге не означает готовую SwiftUI-реализацию: статус `complete` выставляется только после реализации всей iOS-матрицы и визуального сравнения со спецификацией.

## Структура проекта

- `TUIDesignSystemCatalog.xcodeproj` — самостоятельное iOS-приложение-каталог для визуальной проверки.
- `Package.swift` — библиотека `TUIDesignSystem`, которую можно подключать к любому сценарию как локальный Swift Package.
- `Documentation/component-coverage.json` — измеряемый статус переноса каждого component set и его iOS-вариантов.
- `Documentation/figma-spec-links.json` — прямые адреса отдельных Figma-спецификаций, полученные из ссылок компонентов.
- `Documentation/assembling-screens-from-figma.md` — порядок поиска SwiftUI API по ссылке на Figma для новых сценариев.

Каталог запускается схемой `TUIDesignSystemCatalog`. В разделе «Интерактивные компоненты» он создаёт реальные SwiftUI-экземпляры, включая кнопки, чипы, списки, рейтинг, бейджи, загрузчики и нативные системные элементы. Можно нажимать на компоненты и менять их состояния, размеры и оформление. Скриншоты Figma используются только для сверки; они не подменяют компонент в каталоге.

Остальные разделы пока показывают исходную матрицу вариантов и ссылки на спецификации. Их статус — `catalogued`; живой просмотр добавляется вместе с реализацией компонента. Сейчас 25 наборов имеют статус `in-progress` и охватывают 522 iOS-варианта; визуальная сверка каждого сочетания ещё не завершена. `tui-badge [t-client]` и `tui-badge [subscription-icon]` имеют статус `complete`: их iOS-варианты сверены с Figma и отображением в симуляторе. Каталог показывает, если выбранной комбинации свойств нет в Figma.

Проверки данных запускаются командами `python3 Scripts/generate_component_coverage.py --check` и `python3 Scripts/verify_live_components.py`. Для проверки интерфейса соберите схему `TUIDesignSystemCatalog` в iOS Simulator и откройте интерактивные компоненты.
