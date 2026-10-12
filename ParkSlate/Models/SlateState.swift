import Foundation
import Observation

enum SlateTab: Hashable { case atlas, compendium }

/// F1 is read-only: no API here can grant or persist discovery awards.
@Observable
final class SlateState {
    private let defaults: UserDefaults
    static let awakeningKey = "slate.awakeningCompleted"
    private(set) var isAwakened: Bool
    private(set) var isDemo = false
    var tab: SlateTab = .atlas

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        isAwakened = defaults.bool(forKey: Self.awakeningKey)
    }

    func awaken() {
        isAwakened = true
        if !isDemo { defaults.set(true, forKey: Self.awakeningKey) }
    }

    func enterDemo() {
        isDemo = true
        isAwakened = true
        tab = .atlas
    }

    func leaveDemo() {
        isDemo = false
        isAwakened = defaults.bool(forKey: Self.awakeningKey)
        tab = .atlas
    }
}
