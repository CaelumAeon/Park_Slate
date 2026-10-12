import SwiftUI

/// MVP visual renderer for PARK//SLATE's topo language.
/// Production path: replace this procedural layer with geolocal elevation contours
/// generated from DEM/vector-tile data around the current map camera.
struct TopographicOverlayView: View {
    var pulse: CGFloat = 0

    var body: some View {
        Canvas { context, size in
            let lineCount = 18
            for index in 0..<lineCount {
                let baseY = size.height * CGFloat(index + 1) / CGFloat(lineCount + 1)
                var path = Path()
                path.move(to: CGPoint(x: -20, y: baseY))

                for step in 0...40 {
                    let x = size.width * CGFloat(step) / 40
                    let wave = sin(CGFloat(step) * 0.55 + CGFloat(index) * 0.7) * 10
                    let bend = sin(CGFloat(step) * 0.16 + CGFloat(index)) * 16
                    path.addLine(to: CGPoint(x: x, y: baseY + wave + bend))
                }

                let illumination = max(0, 1 - abs(baseY - pulse * size.height) / 90)
                let color = SlateColors.darkTeal.opacity(0.46 + Double(illumination) * 0.46)
                context.stroke(path, with: .color(color), lineWidth: 0.8 + illumination * 0.8)
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
        .blendMode(.screen)
    }
}

