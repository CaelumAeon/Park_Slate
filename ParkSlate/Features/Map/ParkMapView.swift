import SwiftUI
import MapKit

struct ParkMapView: View {
    @Environment(LocationService.self) private var locationService
    @Environment(SlateState.self) private var slateState

    @State private var camera: MapCameraPosition = .region(CentralParkRegion.cameraRegion)
    @State private var discoveries = Discovery.starter
    @State private var pulse: CGFloat = -0.2

    var body: some View {
        ZStack {
            Map(position: $camera, interactionModes: [.pan, .zoom, .rotate]) {
                UserAnnotation()

                ForEach(discoveries) { discovery in
                    Annotation(discovery.name, coordinate: discovery.coordinate) {
                        Button {
                            slateState.selectedDiscovery = discovery
                        } label: {
                            DiscoveryMarkerView(discovery: discovery)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .mapStyle(.standard(elevation: .realistic, pointsOfInterest: .excludingAll, showsTraffic: false))
            .colorScheme(.dark)

            // Visual placeholder until true geolocal contour data is wired in.
            TopographicOverlayView(pulse: pulse)
                .opacity(0.62)

            VStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("PARK//SLATE")
                            .font(SlateTypography.display(19))
                            .tracking(3)
                        Text(locationService.isInsideCentralPark ? "CENTRAL PARK // ACTIVE" : "FIELD MODE")
                            .font(SlateTypography.data(8))
                            .tracking(1.5)
                            .foregroundStyle(SlateColors.teal)
                    }
                    Spacer()
                    Button {
                        if let location = locationService.location {
                            camera = .camera(
                                MapCamera(centerCoordinate: location.coordinate, distance: 900, heading: 0, pitch: 45)
                            )
                        }
                    } label: {
                        Image(systemName: "location.fill")
                            .foregroundStyle(SlateColors.teal)
                            .padding(12)
                            .background(.ultraThinMaterial, in: Circle())
                    }
                }
                .foregroundStyle(SlateColors.warmIvory)
                .padding(.horizontal, 18)
                .padding(.top, 10)

                Spacer()

                HStack(spacing: 28) {
                    Label("MAP", systemImage: "map")
                    Label("ECHO", systemImage: "dot.radiowaves.left.and.right")
                    Label("ARCHIVE", systemImage: "books.vertical")
                }
                .labelStyle(.iconOnly)
                .font(.system(size: 18, weight: .light))
                .foregroundStyle(SlateColors.teal)
                .padding(.horizontal, 26)
                .padding(.vertical, 14)
                .background(.ultraThinMaterial, in: Capsule())
                .padding(.bottom, 16)
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .sheet(item: $slateState.selectedDiscovery) { discovery in
            CompendiumEntryView(discovery: discovery)
                .presentationDetents([.medium, .large])
                .presentationBackground(SlateColors.deepNavy)
        }
        .task {
            locationService.requestAccessAndStart()
            withAnimation(.linear(duration: 2.2).repeatForever(autoreverses: false)) {
                pulse = 1.2
            }
        }
    }
}
