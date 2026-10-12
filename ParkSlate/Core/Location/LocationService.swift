import CoreLocation
import Observation

enum LocationPermission: Equatable {
    case notDetermined, denied, restricted, servicesDisabled, approximate, precise, unavailable

    static func resolve(status: CLAuthorizationStatus, accuracy: CLAccuracyAuthorization,
                        servicesEnabled: Bool) -> Self {
        guard servicesEnabled else { return .servicesDisabled }
        switch status {
        case .notDetermined: return .notDetermined
        case .denied: return .denied
        case .restricted: return .restricted
        case .authorizedAlways, .authorizedWhenInUse:
            return accuracy == .fullAccuracy ? .precise : .approximate
        @unknown default: return .unavailable
        }
    }

    var canLocate: Bool { self == .precise || self == .approximate }

    var message: String {
        switch self {
        case .notDetermined: return "Location is optional. Enable it for your position, or explore the demo."
        case .denied: return "Location access is denied. You can change access in Settings or browse without it."
        case .restricted: return "Location access is restricted by this device. You can still browse the Atlas."
        case .servicesDisabled: return "Location Services are off. Enable them in Settings or browse without location."
        case .approximate: return "Approximate location is enabled. Your position may be imprecise; no discoveries are awarded."
        case .precise: return "Precise location is enabled. Landmarks are preview data; discovery awards are not yet available."
        case .unavailable: return "Location access is unavailable. You can still browse the Atlas."
        }
    }
}

/// Created on SwiftUI's main thread; delegate callbacks use that run loop.
/// Demo and suspended scenes never start the hardware manager.
@Observable
final class LocationService: NSObject, CLLocationManagerDelegate {
    private let manager: CLLocationManager
    private let simulatedPermission: LocationPermission?
    private var foreground = false
    private var demo = false
    private(set) var permission: LocationPermission = .notDetermined
    private(set) var location: CLLocation?
    private(set) var isInsideCentralPark = false
    private(set) var lastError: String?

    init(simulatedPermission: LocationPermission? = nil) {
        manager = CLLocationManager()
        self.simulatedPermission = simulatedPermission
        super.init()
        if let simulatedPermission {
            permission = simulatedPermission
        } else {
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.distanceFilter = 5
        }
    }

    func setContext(foreground: Bool, demo: Bool) {
        self.foreground = foreground
        self.demo = demo
        refresh()
    }

    func refresh() {
        if let simulatedPermission {
            permission = simulatedPermission
        } else {
            permission = .resolve(status: manager.authorizationStatus,
                                  accuracy: manager.accuracyAuthorization,
                                  servicesEnabled: CLLocationManager.locationServicesEnabled())
        }
        if !permission.canLocate || demo || !foreground {
            manager.stopUpdatingLocation()
            location = nil
            isInsideCentralPark = false
            lastError = nil
        } else if simulatedPermission == nil {
            manager.startUpdatingLocation()
        }
    }

    func requestAccessAndStart() {
        guard foreground, !demo, simulatedPermission == nil else { return }
        refresh()
        if permission == .notDetermined { manager.requestWhenInUseAuthorization() }
    }

    static func usable(_ location: CLLocation, now: Date = Date()) -> Bool {
        let age = now.timeIntervalSince(location.timestamp)
        return location.horizontalAccuracy >= 0 && age >= -5 && age <= 30
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) { refresh() }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard foreground, !demo, permission.canLocate,
              let latest = locations.last, Self.usable(latest) else { return }
        location = latest
        lastError = nil
        // Informational only: the prototype polygon never grants an award.
        isInsideCentralPark = permission == .precise && CentralParkRegion.contains(latest.coordinate)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard foreground, !demo else { return }
        location = nil
        isInsideCentralPark = false
        if (error as? CLError)?.code == .denied {
            refresh()
        } else {
            lastError = "Your position is temporarily unavailable. You can continue browsing."
        }
    }
}
