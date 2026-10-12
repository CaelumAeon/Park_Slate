# Foundation F1 implementation and verification

Status: implemented in source, **not build-certified**. Linux workspace has no Swift, XcodeGen, Xcode, simulator or XCTest runtime. Baseline audit is in BASELINE_AUDIT.md. No CloudKit, AI or AR integration was added.

## Actual behavior
- App/RootView.swift supplies native Atlas/Compendium tabs and independent NavigationStacks. Map annotations and the accessible sample-landmark list open DiscoveryDetailView, which links to CompendiumEntryView. Native Back/Done controls return to previous views. The archive tab browses the same read-only catalog.
- Awakening no longer requires a location fix or park entry. The user explicitly completes onboarding with AWAKEN; this saves only slate.awakeningCompleted in UserDefaults. Relaunch bypasses completed onboarding. This defines F1 completion, not verified geographic entry. Automatic first park entry remains deferred until authoritative world data/validation exist.
- Original orange-to-teal ring, tree appearance, procedural pulse and haptics remain. The activation delay is cancellable on disappearance, scene suspension and motion changes. Reduce Motion uses immediate/static activation, omits symbol effects and repeating map pulses, and removes the root transition animation. TopographicOverlayView now exposes animatableData so its existing pulse value can interpolate.
- LocationPermission covers not determined, denied, restricted, disabled services, approximate, precise and unknown. Location is optional. Settings links are provided where the user can change permission; restriction guidance does not promise a Settings fix. Waiting/error states permit continued browsing. Only When In Use is requested by explicit user action.
- Root scene lifecycle stops updates and clears fixes outside active foreground. Permission refresh happens on foreground return and authorization callbacks; permission changes discard previous fixes. Invalid, stale (>30 seconds) and implausibly future fixes are rejected. Approximate fixes never claim prototype park membership. Recenter requires a currently usable fix. No background tracking or heading updates.
- Demo is explicitly entered/exited. It stops real tracking, hides the MapKit user annotation, ignores location callbacks and does not save Awakening completion. Xcode preview and debug UI fixtures use simulated permission without starting/requesting location updates. Demo does not persist across launch.
- There is **no discovery award or journal-writing API** in F1. Live and demo catalog states remain unknown. Stable sample IDs replace random launch IDs. Accuracy/proximity/dwell/user-confirmation validation and discovery persistence remain F3 work.
- Existing navy/ivory/orange/teal palette and serif/monospaced typography remain. Fonts scale relative to Dynamic Type. Awakening/details scroll; large-type Atlas status scrolls in a bounded panel and bottom controls adapt to vertical layout. Markers have spoken labels/state, decorative graphics are hidden from VoiceOver, controls have text and minimum touch areas. Dark theme remains forced.
- project.yml uses Swift language mode 5.0; the baseline value 5.10 was a compiler release rather than a supported language-mode argument. This correction was identified by static review, not a run compiler diagnostic.
- Info.plist now includes explicit bundle identity/executable/version/package keys for generated-project install metadata. The original location purpose is retained. README generation instructions now point to repository root.

## Changed files
New:
- docs/BASELINE_AUDIT.md, docs/F1_IMPLEMENTATION.md
- ParkSlate/Core/Location/LocationStatusView.swift
- ParkSlate/Features/Discovery/DiscoveryDetailView.swift
- ParkSlate/Features/Compendium/CompendiumView.swift
- ParkSlateTests/FoundationTests.swift
- ParkSlateUITests/NavigationTests.swift

Modified:
- README.md, project.yml
- ParkSlate/App/ParkSlateApp.swift, ParkSlate/App/RootView.swift
- ParkSlate/Models/SlateState.swift, ParkSlate/Models/Discovery.swift
- ParkSlate/Core/Location/LocationService.swift
- ParkSlate/Core/Design/SlateTypography.swift
- ParkSlate/Core/Map/TopographicOverlayView.swift
- ParkSlate/Features/Awakening/AwakeningView.swift, TreeGlyphView.swift
- ParkSlate/Features/Map/ParkMapView.swift
- ParkSlate/Features/Compendium/CompendiumEntryView.swift
- ParkSlate/Resources/Info.plist

## Commands and actual results
Run from repository root on a Mac with Xcode supporting Swift 5.10 and XcodeGen installed:

```sh
xcodegen generate
xcodebuild -list -project ParkSlate.xcodeproj
xcodebuild -project ParkSlate.xcodeproj -scheme ParkSlate -sdk iphonesimulator \
  -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build
xcodebuild -project ParkSlate.xcodeproj -scheme ParkSlate \
  -destination 'platform=iOS Simulator,name=iPhone 16' CODE_SIGNING_ALLOWED=NO test
```

All four commands were attempted before and after implementation in this environment and each failed with exit 127: command not found. **No Swift compile, XcodeGen generation, simulator build/launch, unit test or UI test has passed or run.** Select an installed simulator using `xcrun simctl list devices available` if iPhone 16 is unavailable. Physical signing needs a development team and provisioning; simulator commands disable signing.

Checks actually run successfully: `git diff --check`; Python JSON/plist parsing and location/bundle-key checks; PyYAML parsing of project.yml and checking app/unit/UI target source directories and scheme test references. These are static file checks, not XcodeGen or Swift validation.

Added XCTest coverage (execution pending):
- 10 unit methods: permission mapping, fix validity, foreground clearing/late callbacks, demo fix isolation, denied/restricted/disabled rejection, approximate park membership, completion persistence, demo non-persistence, existing completion after demo, prototype boundary/sample IDs.
- 4 UI methods: denied launch/Atlas/relaunch, demo/detail/Compendium/back/tab/exit/relaunch, approximate notice/catalog, largest text with Reduce Motion navigation. UI fixtures are DEBUG-only and use an isolated UserDefaults suite. They verify app UX with fixtures, not actual OS permission dialogs or hardware tracking.

## Remaining placeholders and blockers
- Four-point park polygon, three sample coordinates/summaries without provenance, procedural decorative contours, SF Symbol tree and empty app icon remain. No verified world facts, true elevation geometry or final two-spark/vector animation.
- No accuracy/proximity/dwell/confirmation discovery engine, awards, explored cells, SwiftData records, observations, photos, journal, quests, stamps, offline map cache or record recovery. MapKit tiles may be unavailable offline. Only onboarding completion survives relaunch.
- AI placeholder UI copy was removed from the active flow; AI, CloudKit and AR remain deferred.
- Mac/Xcode build and simulator verification are blocking acceptance. UI layout, VoiceOver ordering, font rendering, pulse interpolation and navigation gesture behavior need runtime review. F1 is not certified as production-ready.

## Required physical-iPhone checks (not performed)
1. Provision/sign on an iOS 17+ iPhone. Clean install: confirm purpose string; choose Don't Allow, Allow Once and While Using separately. Ensure denied/not-determined users can awaken or enter demo without a fix or crash. Cancel/repeat requests; verify no Always prompt.
2. Disable global Location Services; test device restriction via Screen Time/managed policy if available. Verify distinct guidance and continued Atlas/Compendium access. Open Settings, change authorization, return; check status refresh and cleared old fixes.
3. Turn Precise Location off/on in Settings; verify approximate notice, no park-membership claim and no awards. Test poor/absent fixes, recenter disabling, foreground/background/lock/resume and authorization revocation. Confirm the location indicator stops on background and in demo.
4. Complete Awakening, force quit/relaunch and verify it does not replay. Enter demo from clean onboarding and from completed Atlas; browse all sample landmarks, go Back, dismiss the list, switch tabs, exit demo and relaunch. Verify only real onboarding completion persists and no discovery is awarded.
5. Test VoiceOver labels, state announcements and focus order through both annotation and landmark-list routes. Use the largest accessibility text size, landscape, a small iPhone and Increase Contrast; verify scrolling, touch targets and no clipped controls. Toggle Reduce Motion before and during Awakening and on Atlas; verify static readiness/no repeating pulse while normal settings retain animation and haptics.
6. Use airplane mode/offline relaunch: completion and sample catalog must remain, with no fabricated map/location data or discovery awards. Confirm expected map tile limitations.
7. Inspect sample geometry inside/outside Central Park strictly as prototype information. Do not use it to certify geographic discovery or production boundary accuracy.
