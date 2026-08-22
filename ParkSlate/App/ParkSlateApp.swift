import SwiftUI

@main
struct ParkSlateApp: App {
    @State private var locationService = LocationService()
    @State private var slateState = SlateState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(locationService)
                .environment(slateState)
                .preferredColorScheme(.dark)
        }
    }
}
