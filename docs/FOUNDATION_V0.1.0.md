# PARK//SLATE · Foundation v0.1.0

Status: implementation plan, not certification of completed functionality.
Baseline: existing v0.0.1 SwiftUI starter on main.

## Product boundaries
- Native iOS 17+ exploration companion; Central Park is the first supported world.
- Original tree, contour, rune-inspired design; no Zelda/Sheikah assets or copied interface.
- Location permission only while using app; no background tracking in MVP.
- All location-derived discoveries must be explicitly verified with horizontal accuracy, proximity, dwell time, and user action.
- Authoritative park geography and curated landmark facts must replace prototype geometry before production.

## Architecture
- App: composition root, scene lifecycle, dependency injection.
- Core/Design: color, typography, motion, accessibility and original tree vector.
- Core/Location: permission state, accuracy and foreground updates; protocol for simulation.
- Core/Map: map camera, park boundary polygon, contours and offline behavior.
- Features/Awakening: one-time entry experience and persisted completion state.
- Features/Discovery: proximity state machine, landmark catalog, validation, haptics.
- Features/Compendium: detail, journal, observation and progression.
- Persistence: SwiftData repository abstractions, migration and CloudKit optional later.

## Milestone gates
### F0: Baseline audit
- Inspect every tracked source and project.yml; verify XcodeGen generation and iOS simulator build.
- Record build errors, signing needs, tests and placeholder behavior.
- Do not rewrite working components solely for style.

### F1: Reliable app shell
- App navigation: Awakening -> Atlas -> Discovery detail -> Compendium.
- Foreground location permission UX with denied/restricted/approximate states.
- Preview/demo mode that never records real discoveries.
- Accessibility labels, reduced motion, dynamic type and dark theme.

### F2: World data
- Obtain and license reliable Central Park polygon, path and landmark sources.
- Record provenance, coordinates, last verified date, attribution and version.
- Use actual contours tied to camera bounds; do not mislabel procedural graphics as terrain.

### F3: Discovery and persistence
- Landmark schema: stable ID, type, title, location, radius, evidence, status, attribution.
- SwiftData records: discovery, explored cell, observation, photo reference, quest progress, awakening state.
- Location validation: require precise-enough accuracy, multiple stable fixes and user confirmation.
- Deduplicate discovery stamps and make persistence resilient to relaunch/offline mode.

### F4: Quality and delivery
- Unit tests: boundary, permissions, proximity, persistence, dedupe, first-awakening.
- UI tests: initial launch, permission denial, discovery demo, Compendium.
- CI: lint, simulator build/test when macOS runner available; protect main.
- No CloudKit/AI/AR dependencies in the critical path.

## Codex execution order
1. Audit repository tree and README; produce baseline report with concrete file paths.
2. Run xcodegen generate, xcodebuild -list, simulator build and available tests.
3. Implement F1 in small commits with tests; do not silently modify unrelated files.
4. Implement F2 and F3 after reviewing data source provenance.
5. Summarize changed files, tests run, blockers and exact manual device verification.

## Acceptance criteria
- Clean simulator build and launch.
- Functional Atlas and Compendium navigation.
- No location permission crash; denied and approximate cases handled.
- No real discovery granted from demo/mock location.
- Awakening plays once per installation/profile as specified and survives relaunch.
- Offline records survive app restart.
- Visual identity remains dark navy/slate, ivory, orange unknown and teal known.
