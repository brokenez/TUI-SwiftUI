# TUI Design System for iOS

Самостоятельный Swift Package, собранный по библиотекам TUI Mobile, TUI Assets и TUI Foundations. Он не зависит от приложения «Зарплатный клуб».

## Источники

- Components: `OBPLqL8JDThLuOP8M4JzBL`
- Assets: `R1oI4T6X9CHxl2x55MDypT`
- Foundations: `gGt4PaQxQhX7ozPVImsgL5`

Минимальная версия — iOS 26. Компоненты используют нативные SwiftUI-контейнеры и системную навигацию. Полный снимок переменных Figma хранится в `Sources/TUIDesignSystem/Resources/Metadata/figma-foundations.json`; каталоги компонентов и ассетов — рядом с ним.

В проекте сохранены 957 variables, 128 component sets, все 3 927 вариантов и индекс 3 518 ассетов. `Documentation/component-coverage.json` хранит статус переноса каждого компонента. Наличие записи в каталоге не означает готовую SwiftUI-реализацию: статус `complete` выставляется только после реализации всей iOS-матрицы и визуального сравнения со спецификацией.

## Структура проекта

- `TUIDesignSystemCatalog.xcodeproj` — самостоятельное iOS-приложение-каталог для визуальной проверки.
- `Package.swift` — библиотека `TUIDesignSystem`, которую можно подключать к любому сценарию как локальный Swift Package.
- `Documentation/component-coverage.json` — измеряемый статус переноса каждого component set и его iOS-вариантов.

Каталог запускается схемой `TUIDesignSystemCatalog`. Он показывает исходную матрицу вариантов и ссылки на спецификации. Компонент считается перенесённым только после реализации всех его iOS-состояний и размеров, тестов публичной модели и визуальной сверки с Figma.

