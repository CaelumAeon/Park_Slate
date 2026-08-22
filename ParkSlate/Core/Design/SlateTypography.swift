import SwiftUI

enum SlateTypography {
    static func display(_ size: CGFloat) -> Font {
        .system(size: size, weight: .light, design: .serif)
    }

    static func data(_ size: CGFloat) -> Font {
        .system(size: size, weight: .medium, design: .monospaced)
    }
}
