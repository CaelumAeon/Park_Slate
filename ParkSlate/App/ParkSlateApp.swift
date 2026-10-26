import SwiftUI

@main
struct ParkSlateApp: App {
    @State private var locationService: LocationService
    @State private var slateState: SlateState

    private let testAccessibility: Bool

    init() {
        // Test-only controls never affect production installs.
        #if DEBUG
        let arguments = ProcessInfo.processInfo.arguments
        let testing = arguments.contains("--ui-testing")
        testAccessibility = testing && arguments.contains("--accessibility")
        let defaults = testing ? UserDefaults(suiteName: "slate.ui-tests")! : .standard
        if testing && arguments.contains("--reset-state") {
            defaults.removePersistentDomain(forName: "slate.ui-tests")
        }
        let fixture: LocationPermission? = testing
            ? (arguments.contains("--denied") ? .denied
               : arguments.contains("--approximate") ? .approximate : .notDetermined)
            : nil
        let slate = SlateState(defaults: defaults)
        if testing && arguments.contains("--demo") { slate.enterDemo() }
        _slateState = State(initialValue: slate)
        _locationService = State(initialValue: LocationService(simulatedPermission: fixture))
        #else
        testAccessibility = false
        _slateState = State(initialValue: SlateState())
        _locationService = State(initialValue: LocationService())
        #endif
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if testAccessibility {
                    // accessibilityReduceMotion is read-only; suppress animations directly instead.
                    RootView()
                        .transaction { transaction in
                            transaction.disablesAnimations = true
                            transaction.animation = nil
                        }
                        .environment(\.dynamicTypeSize, .accessibility5)
                } else {
                    RootView()
                }
            }
                .environment(locationService)
                .environment(slateState)
                .preferredColorScheme(.dark)
        }
    }
}
