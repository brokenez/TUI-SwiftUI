import SwiftUI
import UIKit

/// Interactive TUI rating: tap or drag across the five stars to choose a value.
public struct TUIRating: View {
    @Binding public var value: Int
    public let isEnabled: Bool
    public let showsSparkles: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var previewValue: Int?
    @State private var pressedIndex: Int?
    @State private var burstingIndices: Set<Int> = []
    @State private var starScale: CGFloat = 1
    @State private var sparkleScale: CGFloat = 0.1
    @State private var sparkleOpacity: Double = 0
    @State private var motionGeneration = 0

    private let starSize: CGFloat = 40
    private let starSpacing: CGFloat = 16

    public init(value: Binding<Int>, isEnabled: Bool = true, showsSparkles: Bool = true) {
        _value = value
        self.isEnabled = isEnabled
        self.showsSparkles = showsSparkles
    }

    private var displayedValue: Int { previewValue ?? value }

    public var body: some View {
        HStack(spacing: starSpacing) {
            ForEach(1...5, id: \.self) { index in
                ZStack {
                    if showsSparkles && !reduceMotion && burstingIndices.contains(index) {
                        sparkleRing.scaleEffect(sparkleScale).opacity(sparkleOpacity)
                    }
                    Image("tui-rating-star-empty", bundle: .module)
                        .resizable()
                        .opacity(index <= displayedValue ? 0 : 1)
                    Image("tui-rating-star-filled", bundle: .module)
                        .resizable()
                        .opacity(index <= displayedValue ? 1 : 0)
                }
                .frame(width: starSize, height: starSize)
                .scaleEffect(pressedIndex == index ? 0.85 : (burstingIndices.contains(index) ? starScale : 1))
                .animation(TUIMotionCurve.productiveEntrance.animation(duration: .fast), value: displayedValue)
                .animation(TUIMotionCurve.productiveEntrance.animation(duration: .fast), value: pressedIndex)
                .accessibilityHidden(true)
            }
        }
        .frame(width: starSize * 5 + starSpacing * 4, height: starSize)
        .padding(4)
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { gesture in
                    guard isEnabled else { return }
                    let index = index(at: gesture.location.x)
                    if pressedIndex == nil {
                        motionGeneration += 1
                        burstingIndices = []
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }
                    pressedIndex = index
                    previewValue = index
                }
                .onEnded { gesture in
                    guard isEnabled else { return }
                    select(index(at: gesture.location.x))
                }
        )
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Оценка")
        .accessibilityValue("\(value) из 5")
        .accessibilityAdjustableAction { direction in
            guard isEnabled else { return }
            switch direction {
            case .increment: select(min(value + 1, 5))
            case .decrement: select(max(value - 1, 0))
            @unknown default: break
            }
        }
    }

    private var sparkleRing: some View {
        ZStack {
            ForEach(0..<12, id: \.self) { particle in
                let angle = Double(particle) * .pi / 6
                Circle()
                    .fill(TUIColor.named("Brand/T-Bank"))
                    .frame(width: starSize * 0.08, height: starSize * 0.08)
                    .offset(
                        x: starSize * 2.25 / 2 * cos(angle),
                        y: starSize * 2.25 / 2 * sin(angle)
                    )
            }
        }
        .frame(width: starSize, height: starSize)
        .allowsHitTesting(false)
    }

    private func index(at location: CGFloat) -> Int {
        min(5, max(1, Int((location - 4 + starSpacing / 2) / (starSize + starSpacing)) + 1))
    }

    private func select(_ selected: Int) {
        motionGeneration += 1
        let generation = motionGeneration
        value = selected
        previewValue = nil
        pressedIndex = nil
        guard !reduceMotion, selected > 0 else {
            burstingIndices = []
            return
        }

        burstingIndices = Set(1...selected)
        starScale = 0.85
        sparkleScale = 0.1
        sparkleOpacity = 0

        withAnimation(TUIMotionCurve.expressiveEntrance.animation(duration: .moderate)) {
            starScale = 1.1
        }
        Task { @MainActor in
            await Self.wait(0.05)
            guard generation == motionGeneration else { return }
            if showsSparkles {
                withAnimation(TUIMotionCurve.productiveEntrance.animation(duration: .moderate)) {
                    sparkleScale = 1
                }
                withAnimation(TUIMotionCurve.productiveEntrance.animation(duration: .fast)) {
                    sparkleOpacity = 1
                }
            }
            await Self.wait(TUIMotionDuration.fast.seconds)
            guard generation == motionGeneration else { return }
            withAnimation(TUIMotionCurve.productiveEntrance.animation(duration: .fast)) {
                sparkleOpacity = 0
            }
            await Self.wait(TUIMotionDuration.moderate.seconds - 0.05 - TUIMotionDuration.fast.seconds)
            guard generation == motionGeneration else { return }
            withAnimation(TUIMotionCurve.productiveEntrance.animation(duration: .fast)) {
                starScale = 0.95
            }
            await Self.wait(TUIMotionDuration.fast.seconds)
            guard generation == motionGeneration else { return }
            withAnimation(TUIMotionCurve.productiveExit.animation(duration: .fast)) {
                starScale = 1
            }
            await Self.wait(TUIMotionDuration.fast.seconds)
            guard generation == motionGeneration else { return }
            burstingIndices = []
        }
    }

    private static func wait(_ seconds: Double) async {
        try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }
}
