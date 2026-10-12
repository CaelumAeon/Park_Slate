import SwiftUI
import UIKit

enum SlateTypography {
    static func display(_ size: CGFloat) -> Font {
        let descriptor = UIFont.systemFont(ofSize: size, weight: .light).fontDescriptor
            .withDesign(.serif) ?? UIFont.systemFont(ofSize: size, weight: .light).fontDescriptor
        return .custom(UIFont(descriptor: descriptor, size: size).fontName, size: size, relativeTo: .title)
    }

    static func data(_ size: CGFloat) -> Font {
        .custom(UIFont.monospacedSystemFont(ofSize: size, weight: .medium).fontName,
                size: size, relativeTo: .body)
    }
}
