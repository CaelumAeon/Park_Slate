import SwiftUI
import UIKit

struct AwakeningView: View {
    @Environment(LocationService.self) private var location
    @Environment(SlateState.self) private var slate
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.scenePhase) private var phase
    @State private var traceProgress: CGFloat = 0
    @State private var ringProgress: CGFloat = 0
    @State private var pulse: CGFloat = -0.2
    @State private var isReady = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                SlateColors.deepNavy.ignoresSafeArea()
                TopographicOverlayView(pulse: pulse).opacity(0.6)
                ScrollView {
                    VStack(spacing: 24) {
                        Text("PARK//SLATE")
                            .font(SlateTypography.display(30))
                            .tracking(6)
                            .multilineTextAlignment(.center)
                            .accessibilityAddTraits(.isHeader)
                        Text("CENTRAL PARK FIELD NAVIGATOR")
                            .font(SlateTypography.data(12))
                            .tracking(2)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(SlateColors.teal)
                        Spacer(minLength: 20)
                        Button { awaken() } label: {
                            ZStack {
                                TreeGlyphView(traceProgress: traceProgress,
                                              color: ringProgress >= 1 ? SlateColors.teal : SlateColors.electricOrange)
                                Circle()
                                    .trim(from: 0, to: ringProgress)
                                    .stroke(ringProgress >= 1 ? SlateColors.teal : SlateColors.electricOrange,
                                            style: StrokeStyle(lineWidth: 2, lineCap: .round))
                                    .rotationEffect(.degrees(-45))
                                    .frame(width: 178, height: 178)
                                    .shadow(color: ringProgress >= 1 ? SlateColors.teal.opacity(0.7) : SlateColors.electricOrange.opacity(0.7), radius: 7)
                            }
                        }
                        .buttonStyle(.plain)
                        .disabled(!isReady)
                        .accessibilityLabel("Awaken and open Atlas")
                        .accessibilityHint("Location is optional")
                        Text(isReady ? "SLATE READY" : "AWAKENING")
                            .font(SlateTypography.data(12))
                            .foregroundStyle(SlateColors.teal)
                        LocationStatusView()
                        Spacer(minLength: 20)
                        Button("AWAKEN") { awaken() }
                            .font(SlateTypography.data(14))
                            .tracking(5)
                            .frame(maxWidth: .infinity, minHeight: 52)
                            .overlay {
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(SlateColors.electricOrange, lineWidth: 1)
                            }
                            .foregroundStyle(SlateColors.electricOrange)
                            .disabled(!isReady)
                            .accessibilityIdentifier("awaken")
                        Button("Explore Demo") {
                            location.setContext(foreground: phase == .active, demo: true)
                            slate.enterDemo()
                        }
                        .frame(minHeight: 44)
                        .foregroundStyle(SlateColors.teal)
                        .accessibilityIdentifier("exploreDemo")
                    }
                    .foregroundStyle(SlateColors.warmIvory)
                    .padding(28)
                    .frame(minHeight: geometry.size.height)
                }
            }
        }
        // SwiftUI cancels this task on disappearance, suspension or motion-setting change.
        .task(id: "\(phase)-\(reduceMotion)") {
            guard phase == .active, !isReady else { return }
            await runActivationSequence()
        }
    }

    @MainActor
    private func runActivationSequence() async {
        if reduceMotion {
            traceProgress = 1
            ringProgress = 1
            pulse = 0
            isReady = true
            return
        }
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        withAnimation(.easeInOut(duration: 1.0)) { traceProgress = 1 }
        withAnimation(.easeInOut(duration: 1.6).delay(0.65)) { ringProgress = 1 }
        withAnimation(.easeOut(duration: 1.1).delay(1.9)) { pulse = 1.15 }
        do { try await Task.sleep(for: .seconds(2.2)) } catch { return }
        guard !Task.isCancelled else { return }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        withAnimation(.easeOut(duration: 0.8)) { isReady = true }
    }

    private func awaken() {
        guard isReady else { return }
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        slate.awaken()
    }
}
