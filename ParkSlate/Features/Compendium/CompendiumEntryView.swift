import SwiftUI

struct CompendiumEntryView: View {
    let discovery: Discovery

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(discovery.kind.rawValue.uppercased())
                            .font(SlateTypography.data(9))
                            .tracking(2)
                            .foregroundStyle(SlateColors.teal)
                        Text(discovery.name)
                            .font(SlateTypography.display(28))
                            .foregroundStyle(SlateColors.warmIvory)
                    }
                    Spacer()
                    Image(systemName: discovery.state == .unknown ? "questionmark.diamond" : "checkmark.seal")
                        .font(.system(size: 26, weight: .light))
                        .foregroundStyle(discovery.state == .unknown ? SlateColors.electricOrange : SlateColors.teal)
                }

                Divider().overlay(SlateColors.darkTeal)

                Text(discovery.summary)
                    .font(.body)
                    .foregroundStyle(SlateColors.warmIvory.opacity(0.82))

                Text("AI FIELD NOTES")
                    .font(SlateTypography.data(10))
                    .tracking(2)
                    .foregroundStyle(SlateColors.electricOrange)

                Text("Reserved for the future Compendium intelligence layer. Curated park data stays authoritative; AI will identify, explain, compare, and personalize discoveries.")
                    .font(.callout)
                    .foregroundStyle(SlateColors.warmIvory.opacity(0.65))
            }
            .padding(24)
        }
    }
}
