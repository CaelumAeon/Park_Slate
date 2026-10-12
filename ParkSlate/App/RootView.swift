import SwiftUI

struct RootView: View {
    @Environment(LocationService.self) private var location
    @Environment(SlateState.self) private var slate
    @Environment(\.scenePhase) private var phase
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        @Bindable var slate = slate
        ZStack {
            SlateColors.deepNavy.ignoresSafeArea()
            if slate.isAwakened {
                TabView(selection: $slate.tab) {
                    NavigationStack { ParkMapView() }
                        .tabItem { Label("Atlas", systemImage: "map") }
                        .tag(SlateTab.atlas)
                    NavigationStack { CompendiumView() }
                        .tabItem { Label("Compendium", systemImage: "books.vertical") }
                        .tag(SlateTab.compendium)
                }
                .tint(SlateColors.teal)
                .transition(.opacity)
            } else {
                AwakeningView()
                    .transition(.opacity)
            }
        }
        .animation(reduceMotion ? nil : .easeInOut(duration: 0.7), value: slate.isAwakened)
        .task { updateLocationContext() }
        .onChange(of: phase) { _, _ in updateLocationContext() }
        .onChange(of: slate.isDemo) { _, _ in updateLocationContext() }
    }

    private func updateLocationContext() {
        location.setContext(foreground: phase == .active, demo: slate.isDemo)
    }
}

#Preview {
    let slate = SlateState(defaults: UserDefaults(suiteName: "slate.preview")!)
    slate.enterDemo()
    return RootView()
        .environment(slate)
        .environment(LocationService(simulatedPermission: .notDetermined))
        .preferredColorScheme(.dark)
}
