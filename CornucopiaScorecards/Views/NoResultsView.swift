import SwiftUI

struct NoResultsView: View {
    let searchText: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
            Text("No Results")
                .font(.headline)
            if !searchText.isEmpty {
                Text("No matches for \u{201C}\(searchText)\u{201D}")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
