import SwiftUI
import UIKit

struct LocationStatusView: View {
    @Environment(LocationService.self) private var location
    @Environment(SlateState.self) private var slate
    @Environment(\.openURL) private var openURL

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(slate.isDemo ? "DEMO // No location tracking or discovery awards." : location.permission.message)
                .font(.callout)
                .accessibilityIdentifier("locationStatus")
            if !slate.isDemo {
                if let error = location.lastError { Text(error).font(.caption) }
                if location.permission == .notDetermined {
                    Button("Enable Location") { location.requestAccessAndStart() }
                        .accessibilityIdentifier("enableLocation")
                } else if [.denied, .servicesDisabled, .approximate].contains(location.permission) {
                    Button("Open Settings") {
                        if let url = URL(string: UIApplication.openSettingsURLString) { openURL(url) }
                    }
                }
            }
        }
        .foregroundStyle(SlateColors.warmIvory)
        .tint(SlateColors.teal)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
