import SwiftUI
import UIKit

struct AwakeningView: View {
    @Environment(LocationService.self) private var locationService
    @Environment(SlateState.self) private var slateState

    @State private var traceProgress: CGFloat = 0
    @State private var ringProgress: CGFloat = 0
    @State private var pulse: CGFloat = -0.2
    @State private var isReady = false

    var body: some View {
        ZStack {
            SlateColors.deepNavy.ignoresSafeArea()
            TopographicOverlayView(pulse: pulse)
                .opacity(locationService.location == nil ? 0.4 : 1)

            VStack(spacing: 0) {
                Text("PARK//SLATE")
                    .font(SlateTypography.display(30))
                    .tracking(6)
                    .foregroundStyle(SlateColors.warmIvory)
                    .opacity(isReady ? 1 : 0)
                    .padding(.top, 48)

                Text(locationService.isInsideCentralPark ? "CENTRAL PARK FIELD NAVIGATOR" : "FIELD NAVIGATOR")
                    .font(SlateTypography.data(9))
                    .tracking(2.2)
                    .foregroundStyle(SlateColors.teal.opacity(0.8))
                    .opacity(isReady ? 1 : 0)
                    .padding(.top, 8)

                Spacer()

                Button {
                    if locationService.location == nil {
                        locationService.requestAccessAndStart()
                    } else if isReady {
                        awaken()
                    }
                } label: {
                    ZStack {
                        TreeGlyphView(
                            traceProgress: traceProgress,
                            color: ringProgress >= 1 ? SlateColors.teal : SlateColors.electricOrange
                        )

                        Circle()
                            .trim(from: 0, to: ringProgress)
                            .stroke(
                                ringProgress >= 1 ? SlateColors.teal : SlateColors.electricOrange,
                                style: StrokeStyle(lineWidth: 2, lineCap: .round)
                            )
                            .rotationEffect(.degrees(-45))
                            .frame(width: 178, height: 178)
                            .shadow(color: ringProgress >= 1 ? SlateColors.teal.opacity(0.7) : SlateColors.electricOrange.opacity(0.7), radius: 7)
                    }
                }
                .buttonStyle(.plain)

                Text(statusText)
                    .font(SlateTypography.data(10))
                    .tracking(1.7)
                    .foregroundStyle(locationService.location == nil ? SlateColors.electricOrange : SlateColors.teal)
                    .padding(.top, 34)

                Spacer()

                if isReady {
                    Button("AWAKEN") { awaken() }
                        .font(SlateTypography.data(14))
                        .tracking(5)
                        .foregroundStyle(SlateColors.electricOrange)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .overlay {
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(SlateColors.electricOrange.opacity(0.9), lineWidth: 1)
                        }
                        .padding(.horizontal, 52)
                        .transition(.opacity.combined(with: .scale(x: 0.5, y: 1)))
                } else {
                    Button("ENABLE LOCATION") {
                        locationService.requestAccessAndStart()
                    }
                    .font(SlateTypography.data(12))
                    .tracking(2)
                    .foregroundStyle(SlateColors.teal)
                }

                if let error = locationService.lastError {
                    Text(error)
                        .font(.caption2)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(SlateColors.warmIvory.opacity(0.7))
                        .padding(.horizontal, 32)
                        .padding(.top, 14)
                }

                Spacer().frame(height: 42)
            }
        }
        .onChange(of: locationService.location) { _, location in
            if location != nil && !isReady {
                runActivationSequence()
            }
        }
    }

    private var statusText: String {
        if locationService.location == nil { return "LOCATION SIGNAL REQUIRED" }
        if locationService.isInsideCentralPark { return "CENTRAL PARK SIGNAL LOCKED" }
        return "LOCAL TOPOGRAPHY ACQUIRED"
    }

    private func runActivationSequence() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        withAnimation(.easeInOut(duration: 1.0)) { traceProgress = 1 }
        withAnimation(.easeInOut(duration: 1.6).delay(0.65)) { ringProgress = 1 }
        withAnimation(.easeOut(duration: 1.1).delay(1.9)) { pulse = 1.15 }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            withAnimation(.easeOut(duration: 0.8)) { isReady = true }
        }
    }

    private func awaken() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        withAnimation(.easeInOut(duration: 0.7)) {
            slateState.awaken()
        }
    }
}
