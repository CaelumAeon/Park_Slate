import CoreLocation
import MapKit

enum CentralParkRegion {
    static let center = CLLocationCoordinate2D(latitude: 40.7829, longitude: -73.9654)

    static let cameraRegion = MKCoordinateRegion(
        center: center,
        span: MKCoordinateSpan(latitudeDelta: 0.045, longitudeDelta: 0.030)
    )

    // MVP boundary approximation. Replace with the official park polygon before production.
    static let boundary: [CLLocationCoordinate2D] = [
        .init(latitude: 40.7644, longitude: -73.9738),
        .init(latitude: 40.7681, longitude: -73.9819),
        .init(latitude: 40.8007, longitude: -73.9581),
        .init(latitude: 40.7974, longitude: -73.9497)
    ]

    static func contains(_ coordinate: CLLocationCoordinate2D) -> Bool {
        var inside = false
        let x = coordinate.longitude
        let y = coordinate.latitude

        for i in boundary.indices {
            let j = (i + boundary.count - 1) % boundary.count
            let xi = boundary[i].longitude
            let yi = boundary[i].latitude
            let xj = boundary[j].longitude
            let yj = boundary[j].latitude

            let intersects = ((yi > y) != (yj > y)) &&
                (x < (xj - xi) * (y - yi) / ((yj - yi) == 0 ? 0.0000001 : (yj - yi)) + xi)
            if intersects { inside.toggle() }
        }
        return inside
    }
}
