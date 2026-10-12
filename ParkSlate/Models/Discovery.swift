import Foundation
import CoreLocation

enum DiscoveryKind: String, Codable, CaseIterable {
    case landmark
    case historicSite
    case monument
    case bridge
    case scenicView
    case water
    case flora
    case wildlife
    case unknown
}

enum DiscoveryState: String, Codable {
    case unknown
    case detected
    case discovered
    case catalogued
}

struct Discovery: Identifiable, Hashable {
    let id: UUID
    var name: String
    var kind: DiscoveryKind
    var state: DiscoveryState
    var latitude: Double
    var longitude: Double
    var summary: String

    var coordinate: CLLocationCoordinate2D {
        .init(latitude: latitude, longitude: longitude)
    }

    static let starter: [Discovery] = [
        .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, name: "Bethesda Terrace", kind: .landmark, state: .unknown,
              latitude: 40.7739, longitude: -73.9709,
              summary: "A major architectural landmark overlooking the Lake."),
        .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, name: "Belvedere Castle", kind: .landmark, state: .unknown,
              latitude: 40.7794, longitude: -73.9692,
              summary: "A stone overlook near the center of the park."),
        .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!, name: "Bow Bridge", kind: .bridge, state: .unknown,
              latitude: 40.7750, longitude: -73.9718,
              summary: "An iconic cast-iron bridge spanning the Lake.")
    ]
}

