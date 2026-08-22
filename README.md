# PARK//SLATE

A native iOS field navigator built around exploration of Central Park, New York.

## Current milestone: v0.0.1

This starter establishes:

- SwiftUI app shell
- PARK//SLATE design tokens
- Core Location service and When-In-Use authorization
- Approximate Central Park boundary detection
- Awakening flow with haptics, orange-to-teal ring transition, and topo pulse
- MapKit map with user location and starter discovery markers
- Discovery / Compendium data model
- Placeholder Compendium entry view ready for a future AI layer
- Procedural topo overlay placeholder ready to be replaced with real geolocal elevation contours

## Requirements

- macOS with current Xcode
- iOS 17+
- XcodeGen (`brew install xcodegen`)
- An Apple development team for deployment to a physical iPhone

## Open the project

```bash
cd ParkSlate
xcodegen generate
open ParkSlate.xcodeproj
```

In Xcode:

1. Select the **ParkSlate** target.
2. Under **Signing & Capabilities**, choose your development team.
3. Change the bundle identifier if needed.
4. Connect an iPhone and run the app.
5. Grant **While Using the App** location access when prompted.

## Repository structure

```text
ParkSlate/
├── App/
├── Core/
│   ├── Design/
│   ├── Location/
│   └── Map/
├── Features/
│   ├── Awakening/
│   ├── Compendium/
│   └── Map/
├── Models/
└── Resources/
```

## Design language

- Deep navy: background / negative space
- Dark teal: dormant topographical lines
- Bright teal: known / acquired / active Slate state
- Electric orange: unknown / tracing / discovery state
- Warm ivory: text and historical information

## Important TODOs

### 1. Final tree asset
`TreeGlyphView` currently uses an SF Symbol placeholder. Replace this with the final vector tree once its SVG paths are locked.

### 2. True geolocal topography
`TopographicOverlayView` is intentionally procedural. The production implementation should generate or fetch contour geometry for the current camera region from elevation data, clip it to the visible map, then animate illumination through those actual contour paths.

### 3. Central Park polygon
The current park boundary is a rough four-point approximation for prototyping. Replace it with an authoritative park boundary polygon before using it for real discovery/entry triggers.

### 4. Persistent exploration
Add SwiftData models for:
- explored map cells
- discoveries
- field observations
- photographs
- quest progress
- marker stamps

### 5. Compendium intelligence
Keep authoritative facts in curated data. Use AI as an interpretation layer for:
- camera-assisted identification
- conversational Compendium search
- field notes
- comparison of sightings
- personalized quests and recommendations

## Suggested next milestone: v0.0.2

1. Replace procedural contours with real local contour geometry.
2. Implement the final PARK//SLATE tree SVG.
3. Build the exact two-spark clockwise ring animation: upper-right + lower-left → orange trace → teal connection.
4. Detect first Central Park entry and fire the awakening sequence once.
5. Persist that first-awakening state locally.
