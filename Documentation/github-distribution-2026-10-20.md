# GitHub-поставка и независимый потребитель

20 октября 2026 по запросу пользователя создан [brokenez/TUI-SwiftUI](https://github.com/brokenez/TUI-SwiftUI). Первоначально приватный; по следующему явному запросу пользователя сделан публичным. Анонимное чтение GitHub API подтвердило `visibility: public`, `private: false`. README обновлён под открытое подключение.

Исходники, нативный каталог, текущие спецификации и доказательства отправлены в ветку main: [c44dd5ead46cee016816967f4c8e4aa578f4be38](https://github.com/brokenez/TUI-SwiftUI/commit/c44dd5ead46cee016816967f4c8e4aa578f4be38). Удалённая ссылка проверена через git ls-remote. Этот документ и журналы проверки добавляются следующим коммитом, без изменения исполняемого кода.

## Удалённое подключение проверено

1. Репозиторий клонирован в отдельную временную папку.
2. В копии Examples/ConsumerApp локальная зависимость заменена на настоящую XCRemoteSwiftPackageReference с GitHub URL и веткой main. Выбран продукт **TUI-SwiftUI**; публичный импорт сохранён **TUIDesignSystem**. Рабочий проект библиотеки и оригинальный consumer при этом не изменялись.
3. Xcode скачал отдельный package checkout из GitHub и закрепил тот же commit: [Package.resolved](Validation/2026-10-20/GitHubDistribution/Package.resolved). [Проверенная конфигурация потребителя](Validation/2026-10-20/GitHubDistribution/remote-consumer-project.pbxproj).
4. Приложение с удалённой зависимостью собрано под iOS Simulator: [журнал](Validation/2026-10-20/GitHubDistribution/remote-consumer.log). Использованы публичный продукт и ресурсы, реализации компонентов в приложение не копировались.
5. В готовом приложении проверен resource bundle, точная сумма bundled figma-foundations.json и отсутствие font binaries: [результат](Validation/2026-10-20/GitHubDistribution/resource-check.json).
6. Приложение установлено и заново запущено на iPhone 17 Pro, iOS 26.4.1. Like сменился с 44290:299175 на 44290:299177 и изменил текст на «В избранном». Share передал действие приложению и открыл нативную шторку: [снимок](Validation/2026-10-20/GitHubDistribution/consumer-share.png).
7. На неизменённом package checkout из GitHub успешно выполнены [coverage --check](Validation/2026-10-20/GitHubDistribution/clean-coverage.log), [inventory --check](Validation/2026-10-20/GitHubDistribution/clean-inventory.log), [проверка живых компонентов/ассетов](Validation/2026-10-20/GitHubDistribution/clean-components.log). Суммы доказательств и текущие статусы воспроизводятся вне рабочей папки.

## Состав и границы поставки

Системный SF Pro iOS 26 выбран пользователем; Apple font files не публикуются. Сохранён локальный игнорируемый архив, без удаления исторических рендеров. В репозитории исходники, Metadata, ассеты, инструкции Codex, источники спецификаций и доказательства реестра. Временные сборки, DerivedData, xcresult и сырые неиспользуемые прогоны исключены. Проверка подготовленных текстовых файлов не выявила credential-кандидатов.

Текущая готовность: 112 кастомных наборов, 53 имеют реализацию, 2 имеют актуальный complete; 16 системных Apple-наборов excluded. Это рабочая поставка для дальнейшего развития и прототипов, не заявление о полной готовности дизайн-системы. [Проверки Foundations и непроверенное](References/Foundations/release-2026-10-20.md) сохранены отдельно. Версия стабильного релиза не назначалась.
