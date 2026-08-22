import Foundation
import Observation

@Observable
final class SlateState {
    var isAwakened = false
    var selectedDiscovery: Discovery?
    var explorationProgress: Double = 0

    func awaken() {
        isAwakened = true
    }
}
