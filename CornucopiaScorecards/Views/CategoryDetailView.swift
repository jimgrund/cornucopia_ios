import SwiftUI

struct CategoryDetailView: View {
    let category: ScorecardCategory

    @State private var table: ScorecardTable = .empty
    @State private var searchText = ""
    @State private var sortColumnIndex = 0
    @State private var sortAscending = true

    private let nameColumnIndex = 0

    private var searchPlaceholder: String {
        table.headers[safe: nameColumnIndex] ?? "name"
    }

    private var filteredSortedRows: [ScorecardRow] {
        var rows = table.rows

        if !searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            rows = rows.filter { row in
                guard let name = row.values[safe: nameColumnIndex] else { return false }
                return name.localizedCaseInsensitiveContains(searchText)
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
            ToolbarItem(placement: .navigationBarTrailing) {
                sortMenu
            }
        }
        .navigationDestination(for: BrandNavigationTarget.self) { target in
            BrandDetailView(target: target)
        }
        .onAppear {
            if table.headers.isEmpty {
                table = CSVLoader.loadTable(named: category.csvFileName)
            }
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
