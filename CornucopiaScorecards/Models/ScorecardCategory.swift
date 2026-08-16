import Foundation

struct ScorecardCategory: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let csvFileName: String
    let systemImage: String

    /// Name of the column (if any) holding a comma-separated list of product
    /// types for this category, e.g. "Fluid Milk, Cheese, Butter". When set,
    /// the category detail screen offers a multi-select filter built from the
    /// distinct values found in that column.
    let filterColumnName: String?

    var detailsFileName: String { csvFileName + "_details" }

    static let all: [ScorecardCategory] = [
        ScorecardCategory(title: "Organic Eggs", csvFileName: "cornucopia_organic_eggs", systemImage: "circle.grid.2x2.fill", filterColumnName: nil),
        ScorecardCategory(title: "Organic Dairy", csvFileName: "cornucopia_organic_dairy", systemImage: "drop.fill", filterColumnName: "Products"),
        ScorecardCategory(title: "Organic Beef", csvFileName: "cornucopia_organic_beef", systemImage: "flame.fill", filterColumnName: "Product offerings"),
        ScorecardCategory(title: "Organic Poultry", csvFileName: "cornucopia_organic_poultry", systemImage: "bird.fill", filterColumnName: "Products"),
        ScorecardCategory(title: "Organic Soy Food", csvFileName: "cornucopia_organic_soy_food", systemImage: "leaf.fill", filterColumnName: "Products"),
        ScorecardCategory(title: "Plant-Based Beverages", csvFileName: "cornucopia_plant_based_beverages", systemImage: "cup.and.saucer.fill", filterColumnName: "Plant Base")
    ]
}
