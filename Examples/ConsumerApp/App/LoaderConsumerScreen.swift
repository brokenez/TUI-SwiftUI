import SwiftUI
import TUIDesignSystem

/// Visibility belongs to the consumer. A fast operation still shows the
/// public package Loader for the minimum duration specified by its guide.
struct LoaderConsumerScreen: View {
    @State private var isLoading = false
    @State private var completed = 0
    @State private var lastVisibleSeconds: Double?
    @State private var loadingTask: Task<Void, Never>?

    var body: some View {
        VStack(spacing: TUISpacing.x6) {
            Spacer()
            if isLoading {
                TUILoader(size: .x32)
                    .onAppear(perform: finishFastOperationAfterMinimumDisplay)
            }
            TUIButton("Загрузить данные", size: .medium,
                      state: isLoading ? .loading : .normal) {
                lastVisibleSeconds = nil
                isLoading = true
            }
            .fixedSize(horizontal: true, vertical: false)
            .accessibilityIdentifier("consumerLoaderStart")
            Text(String(completed))
                .accessibilityIdentifier("consumerLoaderCompleted")
            if let lastVisibleSeconds {
                Text(lastVisibleSeconds.formatted(.number.precision(.fractionLength(3))))
                    .accessibilityIdentifier("consumerLoaderVisibleSeconds")
            }
            Text("Операция завершается сразу. Индикатор остаётся видимым минимум 500 мс по спецификации.")
                .font(.callout)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding(TUISpacing.x4)
        .navigationTitle("Loader из пакета")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            loadingTask?.cancel()
            loadingTask = nil
            isLoading = false
        }
    }

    private func finishFastOperationAfterMinimumDisplay() {
        guard loadingTask == nil else { return }
        let clock = ContinuousClock()
        let appearedAt = clock.now
        loadingTask = Task { @MainActor in
            // No artificial operation delay: the consumer retains visibility.
            await Task.yield()
            do {
                try await clock.sleep(until: appearedAt.advanced(by: TUILoader.recommendedMinimumVisibleDuration))
                try Task.checkCancellation()
                let elapsed = appearedAt.duration(to: clock.now).components
                lastVisibleSeconds = Double(elapsed.seconds) + Double(elapsed.attoseconds) / 1e18
                completed += 1
                isLoading = false
                loadingTask = nil
            } catch {
                // Leaving the screen cancels the owned task; no late result.
                loadingTask = nil
            }
        }
    }
}
