import SwiftUI

/// Placeholder tree glyph. Replace with the final animation-ready SVG paths.
struct TreeGlyphView: View {
    var traceProgress: CGFloat
    var color: Color

    var body: some View {
        ZStack {
            Circle()
                .fill(SlateColors.deepNavy.opacity(0.9))

            Image(systemName: "tree")
                .font(.system(size: 62, weight: .ultraLight))
                .foregroundStyle(color)
                .symbolEffect(.appear, value: traceProgress > 0.5)
        }
        .frame(width: 150, height: 150)
    }
}
