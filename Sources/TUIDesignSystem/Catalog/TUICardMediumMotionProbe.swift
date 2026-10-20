#if DEBUG
import SwiftUI
import UIKit

/// Debug-only scene measuring the production button, not a copy of its style.
/// A UIKit marker follows the actual presentation-layer transform each frame.
struct TUICardMediumMotionProbe: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @StateObject private var recorder = TUICardMediumMotionRecorder()
    @State private var tapCount = 0

    var body: some View {
        VStack(spacing: 16) {
            Text("Reduce Motion: \(reduceMotion ? "on" : "off")")
                .accessibilityIdentifier("cardMotionSystemSetting")
            HStack(spacing: 16) {
                TUICardMedium("Motion", subtitle: "Production card", variant: .textBottomFill) {
                    tapCount += 1
                }
                .cardBackground { TUICardMediumMotionMarker(recorder: recorder, isCard: true) }
                TUICardMediumMotionMarker(recorder: recorder, isCard: false)
                    .frame(width: 80, height: 140)
                    .accessibilityHidden(true)
            }
            Text("Нажатий: \(tapCount)").accessibilityIdentifier("cardMotionTapCount")
            Button("Записать движение") { recorder.start() }
                .accessibilityIdentifier("cardMotionRecord")
            Text(recorder.report)
                .lineLimit(1)
                .accessibilityIdentifier("cardMotionReport")
        }
        .onDisappear { recorder.stop() }
    }
}

private struct TUICardMediumMotionMarker: UIViewRepresentable {
    let recorder: TUICardMediumMotionRecorder
    let isCard: Bool

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = isCard ? .systemPink : .systemBlue
        if isCard { recorder.card = view } else { recorder.neighbor = view }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

@MainActor
private final class TUICardMediumMotionRecorder: NSObject, ObservableObject {
    struct Sample: Codable {
        var time: Double
        var callbackTime: Double
        var frameDuration: Double
        var card: [Double]
        var cardLayout: [Double]
        var neighbor: [Double]
    }

    weak var card: UIView?
    weak var neighbor: UIView?
    @Published var report = "idle"
    private var displayLink: CADisplayLink?
    private var startTime = 0.0
    private var samples: [Sample] = []

    func start() {
        stop()
        samples.removeAll(keepingCapacity: true)
        report = "recording"
        startTime = CACurrentMediaTime()
        let link = CADisplayLink(target: self, selector: #selector(tick(_:)))
        link.preferredFrameRateRange = CAFrameRateRange(minimum: 60, maximum: 60, preferred: 60)
        link.add(to: .main, forMode: .common)
        displayLink = link
    }

    func stop() {
        displayLink?.invalidate()
        displayLink = nil
    }

    @objc private func tick(_ link: CADisplayLink) {
        guard let card, let neighbor, let window = card.window else { return }
        // Animation belongs to the display timeline. A delayed main-thread
        // callback is not the frame's presentation time; retain both clocks.
        let time = link.timestamp - startTime
        samples.append(Sample(time: time, callbackTime: CACurrentMediaTime() - startTime,
                              frameDuration: link.targetTimestamp - link.timestamp,
                              card: bounds(card, in: window),
                              cardLayout: coordinates(card.convert(card.bounds, to: window)),
                              neighbor: bounds(neighbor, in: window)))
        if time >= 4 {
            stop()
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.sortedKeys]
            report = (try? String(data: encoder.encode(samples), encoding: .utf8)) ?? "encoding failed"
        }
    }

    private func bounds(_ view: UIView, in window: UIWindow) -> [Double] {
        // Match source and target in the presentation tree. Measuring the
        // model's layout frame would miss scaleEffect during Core Animation.
        let rect: CGRect
        if let layer = view.layer.presentation(), let root = window.layer.presentation() {
            rect = layer.convert(layer.bounds, to: root)
        } else {
            rect = view.convert(view.bounds, to: window)
        }
        return coordinates(rect)
    }

    private func coordinates(_ rect: CGRect) -> [Double] {
        [rect.midX, rect.midY, rect.width, rect.height].map(Double.init)
    }

    isolated deinit { displayLink?.invalidate() }
}
#endif
