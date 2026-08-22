import SwiftUI

struct RootView: View {
    @Environment(LocationService.self) private var locationService
    @Environment(SlateState.self) private var slateState

    var body: some View {
        ZStack {
            SlateColors.deepNavy.ignoresSafeArea()

            if slateState.isAwakened {
                ParkMapView()
                    .transition(.opacity.combined(with: .scale(scale: 1.02)))
            } else {
                AwakeningView()
                    .transition(.opacity)
            }
        }
        .task {
            locationService.prepare()
        }
    }
}
