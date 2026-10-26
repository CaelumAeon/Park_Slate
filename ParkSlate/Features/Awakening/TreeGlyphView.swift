import SwiftUI

/// Placeholder tree glyph. Replace with the final animation-ready SVG paths.
struct TreeGlyphView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    var traceProgress: CGFloat
    var color: Color

    var body: some View {
        ZStack {
            Circle().fill(SlateColors.deepNavy.opacity(0.9))
            if reduceMotion {
                tree
            } else {
                tree.symbolEffect(.appear, isActive: traceProgress > 0.5)
            }
        }
        .frame(width: 150, height: 150)
        .accessibilityHidden(true)
    }

    private var tree: some View {
        Image(systemName: "tree")
            .font(.system(size: 62, weight: .ultraLight))
            .foregroundStyle(color)
    }
}
