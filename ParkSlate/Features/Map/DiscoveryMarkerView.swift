import SwiftUI

struct DiscoveryMarkerView: View {
    let discovery: Discovery

    var body: some View {
        ZStack {
            Circle()
                .fill(SlateColors.deepNavy.opacity(0.9))
                .frame(width: 34, height: 34)

            Circle()
                .stroke(markerColor, lineWidth: 1.2)
                .frame(width: 30, height: 30)

            Image(systemName: symbolName)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(markerColor)
        }
        .shadow(color: markerColor.opacity(0.55), radius: discovery.state == .unknown ? 5 : 2)
    }

    private var markerColor: Color {
        discovery.state == .unknown ? SlateColors.electricOrange : SlateColors.teal
    }

    private var symbolName: String {
        switch discovery.kind {
        case .landmark: "building.columns"
        case .historicSite: "clock.arrow.circlepath"
        case .monument: "seal"
        case .bridge: "point.bottomleft.forward.to.point.topright.scurvepath"
        case .scenicView: "binoculars"
        case .water: "drop"
        case .flora: "leaf"
        case .wildlife: "bird"
        case .unknown: "questionmark"
        }
    }
}
