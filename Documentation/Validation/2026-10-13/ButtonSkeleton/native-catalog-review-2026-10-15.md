# Итоговая проверка нативного каталога — 15 октября 2026

`TUIDesignSystemCatalog.xcodeproj`, схема `TUIDesignSystemCatalog`, собран для iOS Simulator с изменённым публичным Swift Package: [журнал](catalog-build.log), `BUILD SUCCEEDED`. Отдельный consumer также собирается: [consumer-build.log](consumer-build.log). [Команды](commands.json), [версии входов](source-versions.json).

Установлено итоговое приложение из `/private/tmp/tui-typography-catalog-derived/Build/Products/Debug-iphonesimulator/TUIDesignSystemCatalog.app` на iPhone 17 Pro `6D3F35A1-AC30-4F0E-BDD6-0F912B714E59`. Запущено без DEBUG probe arguments, через обычный вход каталога. Проект открыт в Xcode, приложение — в Simulator.

В реальном интерфейсе выполнено:

1. Открыт `tui-button · 147 вариантов` из списка интерактивных компонентов.
2. У normal Button source ID `41658:296907` выполнено нажатие: счётчик изменился с 0 на 1.
3. Включён переключатель Skeleton: source ID изменился на `55915:350412`, настоящий Button стал disabled. Доступны оформление, размер, состояние, текст, иконка и переход к кастомизации.

[Снимок обычного каталога](native-catalog-screen-20261015.png) снят после этих действий и просмотрен. Он подтверждает текущую поверхность просмотра и состояние управления; статичный снимок не считается доказательством временных параметров анимации. Живой цикл и действие проверяются отдельно двумя UITests и source-curve тестом: [основной отчёт](verification-report.md).

23 теста правил реестра прошли, 0 ошибок: [registry-tests.log](registry-tests.log). Генератор сохраняет **2 complete / 112 активных кастомных наборов**, 53 реализации, 15 наборов с принятым сопоставлением вариантов; 16 Apple system sets исключены. Полная библиотека ещё не готова. Исторические веб-файлы не использовались для этой демонстрации и не изменялись в этой проверке.
