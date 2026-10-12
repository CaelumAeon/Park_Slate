import XCTest
import CoreLocation
@testable import ParkSlate

@MainActor
final class FoundationTests: XCTestCase {
    func testPermissionMapping() {
        let cases: [(CLAuthorizationStatus, CLAccuracyAuthorization, Bool, LocationPermission)] = [
            (.notDetermined, .fullAccuracy, true, .notDetermined),
            (.denied, .fullAccuracy, true, .denied),
            (.restricted, .fullAccuracy, true, .restricted),
            (.authorizedWhenInUse, .reducedAccuracy, true, .approximate),
            (.authorizedWhenInUse, .fullAccuracy, true, .precise),
            (.authorizedAlways, .reducedAccuracy, true, .approximate),
            (.authorizedAlways, .fullAccuracy, false, .servicesDisabled)
        ]
        for (status, accuracy, enabled, expected) in cases {
            XCTAssertEqual(LocationPermission.resolve(status: status, accuracy: accuracy,
                                                       servicesEnabled: enabled), expected)
        }
        XCTAssertFalse(LocationPermission.denied.canLocate)
        XCTAssertFalse(LocationPermission.restricted.canLocate)
        XCTAssertTrue(LocationPermission.approximate.canLocate)
    }

    func testFixValidityRejectsStaleFutureAndInvalidAccuracy() {
        let now = Date()
        func fix(age: TimeInterval, accuracy: Double) -> CLLocation {
            CLLocation(coordinate: CentralParkRegion.center, altitude: 0,
                       horizontalAccuracy: accuracy, verticalAccuracy: -1,
                       timestamp: now.addingTimeInterval(-age))
        }
        XCTAssertTrue(LocationService.usable(fix(age: 1, accuracy: 10), now: now))
        XCTAssertFalse(LocationService.usable(fix(age: 31, accuracy: 10), now: now))
        XCTAssertFalse(LocationService.usable(fix(age: -10, accuracy: 10), now: now))
        XCTAssertFalse(LocationService.usable(fix(age: 1, accuracy: -1), now: now))
    }

    func testForegroundFixIsClearedWhenSuspendedAndLateCallbacksIgnored() {
        let service = LocationService(simulatedPermission: .precise)
        let callbackManager = CLLocationManager()
        let fix = CLLocation(latitude: CentralParkRegion.center.latitude,
                             longitude: CentralParkRegion.center.longitude)
        service.setContext(foreground: true, demo: false)
        service.locationManager(callbackManager, didUpdateLocations: [fix])
        XCTAssertNotNil(service.location)
        XCTAssertTrue(service.isInsideCentralPark)
        service.setContext(foreground: false, demo: false)
        XCTAssertNil(service.location)
        XCTAssertFalse(service.isInsideCentralPark)
        service.locationManager(callbackManager, didUpdateLocations: [fix])
        XCTAssertNil(service.location)
    }

    func testDemoClearsFixAndIgnoresLocationCallbacks() {
        let service = LocationService(simulatedPermission: .precise)
        let callbackManager = CLLocationManager()
        let fix = CLLocation(latitude: 40.7829, longitude: -73.9654)
        service.setContext(foreground: true, demo: false)
        service.locationManager(callbackManager, didUpdateLocations: [fix])
        XCTAssertNotNil(service.location)
        service.setContext(foreground: true, demo: true)
        service.requestAccessAndStart()
        service.locationManager(callbackManager, didUpdateLocations: [fix])
        XCTAssertNil(service.location)
        XCTAssertFalse(service.isInsideCentralPark)
    }

    func testDeniedAndRestrictedIgnoreFixes() {
        let callbackManager = CLLocationManager()
        for permission in [LocationPermission.denied, .restricted, .servicesDisabled] {
            let service = LocationService(simulatedPermission: permission)
            service.setContext(foreground: true, demo: false)
            service.locationManager(callbackManager, didUpdateLocations: [CLLocation(latitude: 40.7829, longitude: -73.9654)])
            XCTAssertNil(service.location)
            XCTAssertFalse(service.isInsideCentralPark)
        }
    }

    func testApproximateFixNeverClaimsParkMembership() {
        let service = LocationService(simulatedPermission: .approximate)
        service.setContext(foreground: true, demo: false)
        service.locationManager(CLLocationManager(), didUpdateLocations: [CLLocation(latitude: 40.7829, longitude: -73.9654)])
        XCTAssertNotNil(service.location)
        XCTAssertFalse(service.isInsideCentralPark)
    }

    func testAwakeningSurvivesNewStateInstance() {
        withDefaults { defaults in
            let state = SlateState(defaults: defaults)
            XCTAssertFalse(state.isAwakened)
            state.awaken()
            XCTAssertTrue(SlateState(defaults: defaults).isAwakened)
        }
    }

    func testDemoDoesNotPersistCompletionOrMutateCatalog() {
        withDefaults { defaults in
            let state = SlateState(defaults: defaults)
            state.enterDemo()
            state.awaken()
            XCTAssertTrue(state.isDemo)
            XCTAssertTrue(state.isAwakened)
            XCTAssertNil(defaults.object(forKey: SlateState.awakeningKey))
            XCTAssertFalse(SlateState(defaults: defaults).isAwakened)
            state.leaveDemo()
            XCTAssertFalse(state.isAwakened)
            XCTAssertFalse(state.isDemo)
            XCTAssertTrue(Discovery.starter.allSatisfy { $0.state == .unknown })
        }
    }

    func testDemoExitPreservesExistingCompletion() {
        withDefaults { defaults in
            let state = SlateState(defaults: defaults)
            state.awaken()
            state.enterDemo()
            state.tab = .compendium
            state.leaveDemo()
            XCTAssertTrue(state.isAwakened)
            XCTAssertEqual(state.tab, .atlas)
            XCTAssertTrue(defaults.bool(forKey: SlateState.awakeningKey))
        }
    }

    func testPrototypeBoundaryAndStableSampleIDs() {
        XCTAssertTrue(CentralParkRegion.contains(CentralParkRegion.center))
        XCTAssertFalse(CentralParkRegion.contains(CLLocationCoordinate2D(latitude: 0, longitude: 0)))
        XCTAssertEqual(Set(Discovery.starter.map(\.id)).count, 3)
        XCTAssertEqual(Discovery.starter.first?.id.uuidString, "00000000-0000-0000-0000-000000000001")
    }

    private func withDefaults(_ body: (UserDefaults) -> Void) {
        let suite = "slate.tests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        defaults.removePersistentDomain(forName: suite)
        defer { defaults.removePersistentDomain(forName: suite) }
        body(defaults)
    }
}
