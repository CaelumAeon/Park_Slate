import SwiftUI

struct CompendiumEntryView: View {
    let discovery: Discovery

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text(discovery.kind.rawValue.uppercased())
                    .font(SlateTypography.data(12))
                    .tracking(2)
                    .foregroundStyle(SlateColors.teal)
                Text(discovery.name)
                    .font(SlateTypography.display(28))
                    .accessibilityAddTraits(.isHeader)
                Label("Preview · Not discovered", systemImage: "questionmark.diamond")
                    .foregroundStyle(SlateColors.electricOrange)
                Divider().overlay(SlateColors.darkTeal)
                Text(discovery.summary).font(.body)
                Text("Sample catalog content; source attribution and verification are pending. No discovery, note or progression record is saved.")
                    .font(.callout)
            }
            .padding(24)
        }
        .foregroundStyle(SlateColors.warmIvory)
        .background(SlateColors.deepNavy)
        .navigationTitle("Compendium Entry")
        .navigationBarTitleDisplayMode(.inline)
    }
}
