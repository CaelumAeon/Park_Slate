import SwiftUI

struct DiscoveryDetailView: View {
    let discovery: Discovery
    @Environment(SlateState.self) private var slate

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(discovery.name)
                    .font(SlateTypography.display(28))
                    .accessibilityAddTraits(.isHeader)
                Label("Not discovered", systemImage: "questionmark.diamond")
                    .foregroundStyle(SlateColors.electricOrange)
                Text(discovery.summary)
                    .font(.body)
                Text(slate.isDemo
                     ? "Demo preview only. Nothing is recorded or awarded."
                     : "Sample landmark. Verified discovery awards will be available after world-data and location-validation milestones.")
                    .font(.callout)
                    .accessibilityIdentifier("discoveryNotice")
                NavigationLink {
                    CompendiumEntryView(discovery: discovery)
                } label: {
                    Label("Read in Compendium", systemImage: "books.vertical")
                }
                .accessibilityIdentifier("readCompendium")
            }
            .padding(24)
        }
        .foregroundStyle(SlateColors.warmIvory)
        .background(SlateColors.deepNavy)
        .tint(SlateColors.teal)
        .navigationTitle("Discovery Preview")
        .navigationBarTitleDisplayMode(.inline)
    }
}
