import SwiftUI

struct CategoriesView: View {
    var body: some View {
        NavigationStack {
            List(ScorecardCategory.all) { category in
                NavigationLink(value: category) {
                    Label(category.title, systemImage: category.systemImage)
                        .padding(.vertical, 6)
                }
            }
            .navigationTitle("Scorecards")
            .navigationDestination(for: ScorecardCategory.self) { category in
                CategoryDetailView(category: category)
            }
        }
    }
}

#Preview {
    CategoriesView()
}
