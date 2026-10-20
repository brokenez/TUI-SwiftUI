#if DEBUG
import SwiftUI
import Combine
import UIKit
import TUIDesignSystem

/// Measures the public component in an active scene. No animation is reproduced
/// by this probe: the display link reads the actual native editor's layer bounds.
struct TextfieldMotionProbe: View {
    @State private var text = "Value"
    @State private var state = TUITextfieldState.normal
    @State private var validationTrigger = 0
    @StateObject private var samples = TextfieldMotionSamples()

    var body: some View {
        VStack(spacing: TUISpacing.x4) {
            TUITextfield(text: $text, state: $state, label: "Label",
                placeholder: "Placeholder", errorText: "Error", validationTrigger: validationTrigger)
                .frame(width: 320)
            Text(state.rawValue)
            Button("Проверить анимацию") {
                Task { @MainActor in
                    samples.start()
                    try? await Task.sleep(for: .milliseconds(300))
                    samples.event("first"); state = .invalid; validationTrigger += 1
                    try? await Task.sleep(for: .milliseconds(850))
                    samples.event("repeated"); validationTrigger += 1
                    try? await Task.sleep(for: .milliseconds(700))
                    samples.event("focus-only"); state = .invalidFocus
                    try? await Task.sleep(for: .milliseconds(700))
                    samples.event("reset"); state = .normal
                    try? await Task.sleep(for: .milliseconds(300))
                    samples.finish()
                }
            }
            .disabled(samples.running)
            .accessibilityIdentifier("textfieldMotionStart")
            Text(samples.result).accessibilityIdentifier("textfieldMotionResult")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .environment(\.colorScheme, .light)
        .background(TextfieldMotionWindowCapture(samples: samples))
        .navigationTitle("Textfield motion QA")
        .navigationBarTitleDisplayMode(.inline)
    }
}

@MainActor private final class TextfieldMotionSamples: NSObject, ObservableObject {
    @Published var running = false
    @Published var result = "Ожидание"
    weak var window: UIWindow?
    private var displayLink: CADisplayLink?
    private var started = 0.0
    private var events: [[String: Any]] = []
    private var frames: [[String: Any]] = []
    private var screenshots: [(String, Data)] = []
    private var lastScreenshot = -1.0
    private let capturesStills = CommandLine.arguments.contains("--tui-textfield-motion-stills")

    func start() {
        displayLink?.invalidate()
        events = []; frames = []; screenshots = []; lastScreenshot = -1
        started = CACurrentMediaTime(); running = true; result = "Измерение"
        let link = CADisplayLink(target: self, selector: #selector(sample))
        link.add(to: .main, forMode: .common); displayLink = link
    }

    func event(_ name: String) {
        events.append(["name": name, "elapsed": CACurrentMediaTime() - started])
    }

    @objc private func sample() {
        guard let window,
            let field = findEditor(in: window) else { return }
        let time = CACurrentMediaTime() - started
        let model = field.convert(field.bounds, to: window)
        let rendered: CGRect
        if let layer = field.layer.presentation(), let root = window.layer.presentation() {
            rendered = layer.convert(layer.bounds, to: root)
        } else { rendered = model }
        frames.append(["elapsed": time, "modelX": model.minX, "renderedX": rendered.minX,
            "renderedY": rendered.minY, "isFirstResponder": field.isFirstResponder])
        // Retain sparse actual window renders, not reconstructed component images.
        // PNG encoding on the main thread can obscure fast shake extrema.
        // Sparse stills supplement an external Simulator recording; geometry
        // samples continue on every display-link callback.
        // Native bitmap rendering/PNG encoding caused ~117 ms main-thread
        // gaps during a 500 ms shake. Use the external Simulator recording
        // for motion and enable sparse stills only in a separate visual run.
        if capturesStills && time - lastScreenshot >= 0.8 {
            lastScreenshot = time
            let renderer = UIGraphicsImageRenderer(bounds: window.bounds)
            let image = renderer.image { _ in window.drawHierarchy(in: window.bounds, afterScreenUpdates: false) }
            if let data = image.pngData() { screenshots.append(("frame-\(frames.count).png", data)) }
        }
    }

    func finish() {
        displayLink?.invalidate(); displayLink = nil; running = false
        do {
            let folder = URL.documentsDirectory.appending(path: "TextfieldMotionProbe", directoryHint: .isDirectory)
            try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
            let payload: [String: Any] = ["events": events, "frames": frames,
                "scale": window?.screen.scale ?? 0,
                "capture": "Active UIWindow.drawHierarchy; native editor model/presentation bounds from CADisplayLink",
                "screenshotNames": screenshots.map(\.0)]
            try JSONSerialization.data(withJSONObject: payload, options: [.prettyPrinted, .sortedKeys])
                .write(to: folder.appending(path: "samples.json"), options: .atomic)
            for (name, data) in screenshots { try data.write(to: folder.appending(path: name), options: .atomic) }
            result = "Готово"
        } catch { result = "Ошибка: \(error.localizedDescription)" }
    }

    private func findEditor(in view: UIView) -> UITextField? {
        if let field = view as? UITextField, field.accessibilityIdentifier == "tuiTextfieldInput" { return field }
        for child in view.subviews { if let field = findEditor(in: child) { return field } }
        return nil
    }
}

private struct TextfieldMotionWindowCapture: UIViewRepresentable {
    let samples: TextfieldMotionSamples
    func makeUIView(context: Context) -> WindowCapture {
        let view = WindowCapture(); view.samples = samples; return view
    }
    func updateUIView(_ view: WindowCapture, context: Context) {}
    final class WindowCapture: UIView {
        weak var samples: TextfieldMotionSamples?
        override func didMoveToWindow() { super.didMoveToWindow(); samples?.window = window }
    }
}
#endif
