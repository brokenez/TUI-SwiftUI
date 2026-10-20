#if DEBUG
import SwiftUI
import UIKit
import TUIDesignSystem

/// Records the real public component. This probe changes only consumer state;
/// transitions and durations remain inside TUIDesignSystem.
struct FloatingContainerMotionProbe: View {
    @State private var presented = false
    @State private var title = "Продолжить"
    @State private var compact = false
    @State private var supplement = 0
    @State private var stage = 0
    @State private var running = false
    @State private var result = "Ожидание"
    @State private var taps = 0
    @State private var events: [[String: Any]] = []
    @State private var started = 0.0
    @State private var containerSize = CGSize.zero
    @State private var captureID = UUID()
    @Environment(\.displayScale) private var displayScale

    var body: some View {
        VStack(spacing: TUISpacing.x4) {
            // A stable color identifies the first rendered frame of each
            // mutation in the native movie, independent of external clocks.
            Color(red: Double(stage) / 16, green: 0.2, blue: 0.8)
                .frame(height: 16).accessibilityIdentifier("floatingMotionStageMarker")
                .transaction { $0.animation = nil }
            Text("Этап \(stage)").accessibilityIdentifier("floatingMotionStage")
            Text("Native Floating Container · motion QA").tuiTypography(.bodyLarge)
            Button("Записать переходы") { Task { await run() } }
                .disabled(running).accessibilityIdentifier("floatingMotionStart")
            Text(result).accessibilityIdentifier("floatingMotionResult")
            Text("Нажатия: \(taps)")
            Spacer()
        }
        .padding(.horizontal, TUISpacing.x4)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(white: 0.94))
        .tuiFloatingContainer(isPresented: presented) {
            TUIFloatingContainer(
                primary: TUIButton(title, size: compact ? .small : .large) { taps += 1 },
                secondary: supplement == 1 ? TUIButton("Отмена", appearance: .flat) { taps += 1 } : nil,
                legalText: supplement == 2 ? "Продолжая, вы соглашаетесь с условиями" : nil)
        }
        .environment(\.colorScheme, .light)
        .navigationTitle("Floating motion QA")
        .navigationBarTitleDisplayMode(.inline)
        .onGeometryChange(for: CGSize.self) { $0.size } action: { containerSize = $0 }
        .task {
            if CommandLine.arguments.contains("--tui-floating-motion-auto") {
                try? await Task.sleep(for: .seconds(3))
                await run()
            }
        }
    }

    @MainActor private func run() async {
        guard !running else { return }
        running = true; result = "Измерение"
        presented = false; title = "Продолжить"; compact = false; supplement = 0; stage = 0
        events = []; started = CACurrentMediaTime()
        captureID = UUID()
        do { try save(complete: false) }
        catch { result = "Ошибка: \(error.localizedDescription)"; running = false; return }
        await pause()
        event("show-primary"); presented = true
        await pause()
        event("same-shape-primary"); title = "Подтвердить"
        await pause()
        event("same-shape-primary-return"); title = "Продолжить"
        await pause()
        event("different-shape-compact"); compact = true
        await pause()
        event("different-shape-large"); compact = false
        await pause()
        event("show-secondary"); supplement = 1
        await pause()
        event("secondary-to-legal"); supplement = 2
        await pause()
        event("legal-to-secondary"); supplement = 1
        await pause()
        event("hide-secondary"); supplement = 0
        await pause()
        event("hide-primary"); presented = false
        await pause()
        do {
            try save(complete: true)
            result = "Готово"
        } catch { result = "Ошибка: \(error.localizedDescription)" }
        running = false
    }

    @MainActor private func save(complete: Bool) throws {
        let folder = URL.documentsDirectory.appending(path: "FloatingContainerMotionProbe", directoryHint: .isDirectory)
        try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        let payload: [String: Any] = ["events": events, "complete": complete,
            "captureID": captureID.uuidString, "device": UIDevice.current.model,
            "stageMarker": "RGB(stage/16, 0.2, 0.8), first native rendered frame; movie resolution governs time precision",
            "capture": "External simctl native movie; no replicated component or animation",
            "consumerContainer": ["width": containerSize.width, "height": containerSize.height,
                                  "scale": displayScale]]
        try JSONSerialization.data(withJSONObject: payload, options: [.prettyPrinted, .sortedKeys])
            .write(to: folder.appending(path: "events.json"), options: .atomic)
    }

    @MainActor private func event(_ name: String) {
        stage += 1
        events.append(["name": name, "stage": stage, "elapsed": CACurrentMediaTime() - started])
    }
    private func pause() async { try? await Task.sleep(for: .milliseconds(1100)) }
}
#endif
