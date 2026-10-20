# TUI-SwiftUI

Нативная SwiftUI-библиотека для интерактивных iOS 26 прототипов из TUI Mobile. Публичный модуль — `TUIDesignSystem`; продукты Swift Package — `TUI-SwiftUI` и совместимый `TUIDesignSystem`. Каталог — самостоятельное приложение Xcode, компоненты в нём исполняются из библиотеки.

Репозиторий: [brokenez/TUI-SwiftUI](https://github.com/brokenez/TUI-SwiftUI), приватный. Это текущая разработка, а не завершённый релиз всех компонентов. Полная приёмка определяется [реестром](Documentation/component-coverage.json), а не количеством экранов каталога или успешной сборкой.

## Подключение

В Xcode → Add Package Dependencies добавьте `https://github.com/brokenez/TUI-SwiftUI.git`, выберите ветку `main` и продукт `TUI-SwiftUI`. Нужен доступ к приватному репозиторию. Минимальная платформа — iOS 26, Swift tools 6.2. Для воспроизводимого прототипа закрепляйте проверенный commit в Package.resolved.

```swift
import SwiftUI
import TUIDesignSystem

struct PrototypeScreen: View {
    @State private var showDetails = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: TUISpacing.x4) {
                Text("Зарплатный клуб").tuiTypography(.headingLarge)
                Text("Переведите зарплату в Т-Банк, чтобы открыть преимущества")
                    .tuiTypography(.bodyLarge)
                    .foregroundStyle(TUIColor.textSecondary)
                TUIButton("Как перевести зарплату") { showDetails = true }
            }
            .padding(TUISpacing.x4)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(TUIColor.backgroundPrimary)
            .sheet(isPresented: $showDetails) {
                NavigationStack {
                    Text("Передайте работодателю реквизиты счёта в Т-Банке")
                        .tuiTypography(.bodyLarge)
                        .padding(TUISpacing.x4)
                        .navigationTitle("Перевод зарплаты")
                }
            }
        }
    }
}
```

Это пример подключения API, не приёмка конкретного экрана Figma. Независимый проект-потребитель: [Examples/ConsumerApp](Examples/ConsumerApp).

## Foundations

Пакет содержит 957 исходных Variables четырёх коллекций, разрешение ссылок между ними, 289 цветовых токенов Day/Night, 31 документированную роль iOS, токены размеров и теней, пять длительностей и шесть кривых анимации. По [решению пользователя](Documentation/typography-decision-2026-10-20.md) используется системный SF Pro iOS 26; файлы шрифтов не распространяются.

В каталоге откройте «Foundations»: цвета, роли шрифтов, переключение темы и воспроизведение анимации работают на реальных API пакета. [Проверки и точные ограничения](Documentation/References/Foundations/release-2026-10-20.md): составные градиенты, полная визуальная приёмка теней и неоднозначность line box в первоисточнике ещё не приняты. Проверка чтения токенов не заменяет визуальную сверку с Figma.

## Использование через Codex

Сначала прочитайте [AGENTS.md](AGENTS.md), [инвентаризацию](docs/inventory.json), [спецификации](docs/specifications) и [правила сборки экранов](Documentation/assembling-screens-from-figma.md). Найдите Figma Component/Variant ID через `Scripts/resolve_figma_node.py`, проверьте публичный API и актуальную приёмку. Используйте компоненты и ресурсы пакета, без копирования реализаций в приложение.

Текущий объём — 112 кастомных наборов. 16 системных Apple-наборов исключены; для них потребитель использует нативные iOS 26 API. Deprecated не переносим. Исторические варианты iOS 18 сохранены отдельно. Дополнительные режимы доступности исключены из текущей приёмки по решению пользователя. Оригинальные файлы Figma изменять запрещено.

## Каталог и проверки

Откройте `TUIDesignSystemCatalog.xcodeproj`, выберите схему `TUIDesignSystemCatalog` и iOS 26 Simulator. Пакетные тесты запускаются через `PackageTests.xcworkspace`, схему `TUIDesignSystemTests`.

```sh
python3 Scripts/generate_component_coverage.py --check
python3 Scripts/verify_live_components.py
```

[Правила приёмки](Documentation/verification-workflow.md) требуют спецификации, применимых вариантов, визуальной сверки, поведения, анимации и интеграции. При изменении шрифта или общих исходников прежняя приёмка не переносится автоматически. В Git хранятся исходники, спецификации и доказательства из актуального реестра; полные временные DerivedData, старые сырые прогоны и локальный архив шрифтов не включаются.

Разработка веб-каталога остановлена [решением от 13 октября](Documentation/native-catalog-focus-2026-10-13.md). Исторические файлы сохранены; текущая проверка проходит в нативном приложении.

## Первоисточники

- [TUI Mobile](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile)
- [TUI Foundations](https://www.figma.com/design/gGt4PaQxQhX7ozPVImsgL5/TUI-Foundations)
- [TUI Assets](https://www.figma.com/design/R1oI4T6X9CHxl2x55MDypT/TUI-Assets)

Репозиторий приватный; лицензия на открытое распространение материалов TUI не заявляется.
