import SwiftUI

struct CategoryDetailView: View {
    let category: ScorecardCategory

    @State private var table: ScorecardTable = .empty
    @State private var searchText = ""
    @State private var sortColumnIndex = 0
    @State private var sortAscending = true
    @State private var selectedProductFilters: Set<String> = []
    @State private var isShowingFilterSheet = false

    private let nameColumnIndex = 0

    private var searchPlaceholder: String {
        table.headers[safe: nameColumnIndex] ?? "name"
    }

    private var filterColumnIndex: Int? {
        guard let name = category.filterColumnName else { return nil }
        return table.headers.firstIndex(of: name)
    }

    private var filterOptions: [String] {
        guard let filterColumnIndex else { return [] }
        var displayByKey: [String: String] = [:]
        for row in table.rows {
            guard let raw = row.values[safe: filterColumnIndex] else { continue }
            for token in productTokens(from: raw) {
                let key = token.lowercased()
                if displayByKey[key] == nil {
                    displayByKey[key] = token
                }
            }
        }
        return displayByKey.values.sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }
    }

    private func productTokens(from rawValue: String) -> [String] {
        rawValue
            .components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    private var filteredSortedRows: [ScorecardRow] {
        var rows = table.rows

        if !searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            rows = rows.filter { row in
                guard let name = row.values[safe: nameColumnIndex] else { return false }
                return name.localizedCaseInsensitiveContains(searchText)
            }
        }

        if let filterColumnIndex, !selectedProductFilters.isEmpty {
            rows = rows.filter { row in
                guard let raw = row.values[safe: filterColumnIndex] else { return false }
                let rowKeys = Set(productTokens(from: raw).map { $0.lowercased() })
                return !rowKeys.isDisjoint(with: selectedProductFilters)
            }
        }

        rows.sort { lhs, rhs in
            let l = lhs.values[safe: sortColumnIndex] ?? ""
            let r = rhs.values[safe: sortColumnIndex] ?? ""

            let ascendingResult: Bool
            if let ln = Double(l), let rn = Double(r) {
                ascendingResult = ln < rn
            } else {
                ascendingResult = l.localizedCaseInsensitiveCompare(r) == .orderedAscending
            }
            return sortAscending ? ascendingResult : !ascendingResult
        }

        return rows
    }

    var body: some View {
        Group {
            if table.headers.isEmpty {
                ProgressView()
            } else if filteredSortedRows.isEmpty {
                NoResultsView(searchText: searchText)
            } else {
                List(filteredSortedRows) { row in
                    NavigationLink(value: BrandNavigationTarget(category: category, row: row, headers: table.headers)) {
                        ScorecardRowView(headers: table.headers, values: row.values)
                    }
                }
                .listStyle(.plain)
            }
        }
        .searchable(text: $searchText, prompt: "Search \(searchPlaceholder)")
        .navigationTitle(category.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if category.filterColumnName != nil {
                ToolbarItem(placement: .navigationBarTrailing) {
                    filterButton
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                sortMenu
            }
        }
        .navigationDestination(for: BrandNavigationTarget.self) { target in
            BrandDetailView(target: target)
        }
        .sheet(isPresented: $isShowingFilterSheet) {
            ProductFilterSheet(
                columnLabel: category.filterColumnName ?? "Product",
                options: filterOptions,
                selected: $selectedProductFilters
            )
        }
        .onAppear {
            if table.headers.isEmpty {
                table = CSVLoader.loadTable(named: category.csvFileName)
                if let ratingIndex = table.headers.firstIndex(where: { $0.lowercased() == "rating" }) {
                    sortColumnIndex = ratingIndex
                }
                sortAscending = false
            }
        }
    }

    private var filterButton: some View {
        Button {
            isShowingFilterSheet = true
        } label: {
            Image(systemName: selectedProductFilters.isEmpty ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
        }
    }

    private var sortMenu: some View {
        Menu {
            ForEach(Array(table.headers.enumerated()), id: \.offset) { index, header in
                Button {
                    if sortColumnIndex == index {
                        sortAscending.toggle()
                    } else {
                        sortColumnIndex = index
                        sortAscending = true
                    }
                } label: {
                    HStack {
                        Text(header)
                        if sortColumnIndex == index {
                            Spacer()
                            Image(systemName: sortAscending ? "arrow.up" : "arrow.down")
                        }
                    }
                }
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down.circle")
        }
    }
}

#Preview {
    NavigationStack {
        CategoryDetailView(category: ScorecardCategory.all[0])
    }
}
