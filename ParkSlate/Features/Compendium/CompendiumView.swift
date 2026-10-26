import SwiftUI

struct CompendiumView: View {
    @Environment(SlateState.self) private var slate

    var body: some View {
        List {
            Section {
                Text(slate.isDemo ? "Demo · No discoveries recorded" : "No discoveries recorded")
                    .accessibilityIdentifier("compendiumEmpty")
                Text("Browse the sample catalog. Entries are unverified previews, not earned discoveries.")
                    .font(.callout)
            }
            .listRowBackground(SlateColors.navy)
            Section("Sample Catalog") {
                ForEach(Discovery.starter) { discovery in
                    NavigationLink {
                        CompendiumEntryView(discovery: discovery)
                    } label: {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(discovery.name)
                            Text("Not discovered · Preview")
                                .font(.caption)
                                .foregroundStyle(SlateColors.electricOrange)
                        }
                    }
                    .accessibilityLabel(discovery.name)
                    .accessibilityValue("Not discovered · Preview")
                }
                .listRowBackground(SlateColors.navy)
            }
        }
        .foregroundStyle(SlateColors.warmIvory)
        .scrollContentBackground(.hidden)
        .background(SlateColors.deepNavy)
        .navigationTitle("Compendium")
    }
}
