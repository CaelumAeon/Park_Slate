import SwiftUI
import MapKit

struct ParkMapView: View {
    @Environment(LocationService.self) private var location
    @Environment(SlateState.self) private var slate
    @Environment(\.dynamicTypeSize) private var dynamicType
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var camera: MapCameraPosition = .region(CentralParkRegion.cameraRegion)
    @State private var pulse: CGFloat = -0.2
    @State private var showLandmarks = false

    var body: some View {
        ZStack {
            Map(position: $camera, interactionModes: [.pan, .zoom, .rotate]) {
                if !slate.isDemo && location.permission.canLocate { UserAnnotation() }
                ForEach(Discovery.starter) { discovery in
                    Annotation(discovery.name, coordinate: discovery.coordinate) {
                        NavigationLink {
                            DiscoveryDetailView(discovery: discovery)
                        } label: {
                            DiscoveryMarkerView(discovery: discovery)
                                .frame(minWidth: 44, minHeight: 44)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Preview \(discovery.name)")
                        .accessibilityValue("Not discovered")
                    }
                }
            }
            .mapStyle(.standard(elevation: .realistic, pointsOfInterest: .excludingAll, showsTraffic: false))
            .colorScheme(.dark)

            // Decorative only; not real elevation data.
            TopographicOverlayView(pulse: pulse).opacity(0.62)
        }
        .navigationTitle("Atlas")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .top) {
            if dynamicType.isAccessibilitySize {
                ScrollView { statusHeader }
                    .frame(maxHeight: 200)
                    .background(SlateColors.deepNavy.opacity(0.95))
            } else {
                statusHeader
            }
        }
        .safeAreaInset(edge: .bottom) {
            ViewThatFits(in: .horizontal) {
                HStack {
                    landmarkButton
                    Spacer()
                    recenterButton
                }
                VStack(alignment: .leading) {
                    landmarkButton
                    recenterButton
                }
            }
            .font(.body)
            .tint(SlateColors.teal)
            .padding(16)
            .background(SlateColors.deepNavy.opacity(0.95))
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(slate.isDemo ? "Exit Demo" : "Demo") {
                    if slate.isDemo {
                        slate.leaveDemo()
                    } else {
                        location.setContext(foreground: true, demo: true)
                        slate.enterDemo()
                    }
                }
                .accessibilityIdentifier("demoToggle")
            }
        }
        .sheet(isPresented: $showLandmarks) {
            NavigationStack {
                List(Discovery.starter) { discovery in
                    NavigationLink(discovery.name) { DiscoveryDetailView(discovery: discovery) }
                        .listRowBackground(SlateColors.navy)
                }
                .scrollContentBackground(.hidden)
                .background(SlateColors.deepNavy)
                .navigationTitle("Sample Landmarks")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") { showLandmarks = false }
                    }
                }
            }
            .tint(SlateColors.teal)
        }
        .onAppear { updatePulse() }
        .onChange(of: reduceMotion) { _, _ in updatePulse() }
    }

    private var statusHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            LocationStatusView()
            Text("Sample landmarks · decorative contours")
                .font(.caption)
                .foregroundStyle(SlateColors.warmIvory)
        }
        .padding(12)
        .background(SlateColors.deepNavy.opacity(0.95))
    }

    private var landmarkButton: some View {
        Button {
            showLandmarks = true
        } label: {
            Label("Landmarks", systemImage: "list.bullet")
        }
        .frame(minHeight: 44)
        .accessibilityIdentifier("landmarks")
    }

    private var recenterButton: some View {
        Button {
            if slate.isDemo {
                camera = .region(CentralParkRegion.cameraRegion)
            } else if let fix = location.location, LocationService.usable(fix) {
                camera = .camera(MapCamera(centerCoordinate: fix.coordinate,
                                          distance: 900, heading: 0,
                                          pitch: reduceMotion ? 0 : 45))
            }
        } label: {
            Label(slate.isDemo ? "Park" : "My Location", systemImage: "location.fill")
        }
        .frame(minHeight: 44)
        .disabled(!slate.isDemo && !hasUsableFix)
        .accessibilityHint(slate.isDemo ? "Centers the demo on Central Park" : "Centers on your latest position")
    }

    private var hasUsableFix: Bool {
        guard let fix = location.location else { return false }
        return LocationService.usable(fix)
    }

    private func updatePulse() {
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) { pulse = -0.2 }
        if !reduceMotion {
            withAnimation(.linear(duration: 2.2).repeatForever(autoreverses: false)) { pulse = 1.2 }
        }
    }
}
