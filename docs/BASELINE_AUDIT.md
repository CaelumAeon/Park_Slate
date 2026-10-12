# Foundation baseline audit
Audited branch foundation/v0.1.0 at 20f46841a3b3d2a70596f1a382a2e4a21fb67e79, before code changes.

Every tracked file was read; no AGENTS.md, generated Xcode project, dependencies, test sources or CI exist.
- App/ParkSlateApp.swift composes observable services and forces dark mode. App/RootView.swift switches Awakening/map using volatile state.
- Models/SlateState.swift has no persistence; selectedDiscovery drives a sheet; explorationProgress is unused.
- Models/Discovery.swift contains three unverified sample landmarks, random per-process UUIDs and unused progression states. No award logic exists.
- Core/Location/LocationService.swift requests When In Use, starts location/heading, computes park membership, exposes errors. No foreground stopping, accuracy UX, stale-fix filtering or revocation cleanup.
- Core/Location/CentralParkRegion.swift uses a rough four-corner polygon and ray casting, not authoritative geography.
- Features/Awakening/AwakeningView.swift retains orange-to-teal ring, trace, pulse and haptics; depends on a new fix, allows awakening outside park, uses uncancellable delayed work, repeats on relaunch.
- Features/Awakening/TreeGlyphView.swift is an SF Symbol, not final vector; exact two-spark ring is absent.
- Features/Map/ParkMapView.swift has MapKit, user annotation and sample markers; footer labels are inert; marker opens Compendium sheet; recenter silently does nothing without fix; repeated pulse ignores reduced motion.
- Features/Map/DiscoveryMarkerView.swift uses color/symbol state, with no accessible action label.
- Features/Compendium/CompendiumEntryView.swift is summary plus future AI placeholder; no archive list, journal, notes, search or persistence.
- Core/Map/TopographicOverlayView.swift is decorative procedural sine-wave Canvas, unrelated to terrain/camera.
- Core/Design/SlateColors.swift defines existing palette. SlateTypography.swift uses fixed sizes, not Dynamic Type.
- Resources/Info.plist contains When In Use purpose and empty launch screen. Asset catalog contains teal accent, metadata and empty icon images.
- project.yml defines iOS 17, SWIFT_VERSION 5.10 (a compiler release, not a supported Swift language mode; corrected to 5.0 in F1), app version 0.0.1, no test targets/signing team. README incorrectly says generate inside ParkSlate; project.yml is at repository root.
- README.md and docs/FOUNDATION_V0.1.0.md describe starter and proposed gates, not certification.

## Baseline execution (Linux, 2026-10-12)
git clone --branch foundation/v0.1.0 --single-branch https://github.com/CaelumAeon/Park_Slate.git failed: configured proxy unavailable. All files retrieved via authenticated GitHub connector at the pinned commit.
Commands attempted from repository root:
```sh
xcodegen generate
xcodebuild -list -project ParkSlate.xcodeproj
xcodebuild -project ParkSlate.xcodeproj -scheme ParkSlate -sdk iphonesimulator -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build
xcodebuild -project ParkSlate.xcodeproj -scheme ParkSlate -destination 'platform=iOS Simulator,name=iPhone 16' CODE_SIGNING_ALLOWED=NO test
```
All exited 127: command not found. Swift also unavailable. No simulator launch/build/tests verified. Physical deployment requires macOS, Xcode, provisioning team and device. Empty app icon remains a delivery placeholder.

F2 geography/contours/provenance and F3 accuracy/proximity/dwell/confirmation/dedupe/SwiftData remain unimplemented. CloudKit, AI and AR are deferred. F1 must not award discoveries using these sample data.

