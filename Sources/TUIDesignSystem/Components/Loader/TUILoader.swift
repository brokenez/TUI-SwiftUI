import SwiftUI

public enum TUILoaderSize: Int, CaseIterable, Sendable {
    case x12 = 12
    case x16 = 16
    case x24 = 24
    case x32 = 32
    case x40 = 40
}

/// Animated loading indicator using the five exact iOS vector contours from Figma.
public struct TUILoader: View {
    public let size: TUILoaderSize
    @State private var rotating = false

    public init(size: TUILoaderSize = .x24) {
        self.size = size
    }

    public var body: some View {
        Image("tui-loader-\(size.rawValue)", bundle: .module)
            .resizable()
            .frame(width: CGFloat(size.rawValue), height: CGFloat(size.rawValue))
            .rotationEffect(.degrees(rotating ? 360 : 0))
            .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: rotating)
            .onAppear { rotating = true }
            .accessibilityLabel("Загрузка")
    }
}
