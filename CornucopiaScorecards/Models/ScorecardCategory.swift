import Foundation

struct ScorecardCategory: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let csvFileName: String
    let systemImage: String

    var detailsFileName: String { csvFileName + "_details" }

    static let all: [ScorecardCategory] = [
        ScorecardCategory(title: "Organic Eggs", csvFileName: "cornucopia_organic_eggs", systemImage: "circle.grid.2x2.fill"),
        ScorecardCategory(title: "Organic Dairy", csvFileName: "cornucopia_organic_dairy", systemImage: "drop.fill"),
        ScorecardCategory(title: "Organic Milk", csvFileName: "cornucopia_organic_milk", systemImage: "mug.fill"),
        ScorecardCategory(title: "Organic Beef", csvFileName: "cornucopia_organic_beef", systemImage: "flame.fill"),
        ScorecardCategory(title: "Organic Poultry", csvFileName: "cornucopia_organic_poultry", systemImage: "bird.fill"),
        ScorecardCategory(title: "Organic Soy Food", csvFileName: "cornucopia_organic_soy_food", systemImage: "leaf.fill"),
        ScorecardCategory(title: "Cottage Cheese", csvFileName: "cornucopia_cottage_cheese", systemImage: "square.stack.3d.up.fill"),
        ScorecardCategory(title: "Plant-Based Beverages", csvFileName: "cornucopia_plant_based_beverages", systemImage: "cup.and.saucer.fill")
    ]
}
