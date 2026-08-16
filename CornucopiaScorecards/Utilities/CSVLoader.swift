import Foundation

enum CSVLoader {
    static func loadTable(named name: String) -> ScorecardTable {
        guard let url = Bundle.main.url(forResource: name, withExtension: "csv"),
              let data = try? Data(contentsOf: url),
              let text = String(data: data, encoding: .utf8) else {
            return .empty
        }

        let parsed = CSVParser.parse(text)
        guard let headerRow = parsed.first else { return .empty }

        let rows = parsed.dropFirst().map { fields -> ScorecardRow in
            if fields.count < headerRow.count {
                return ScorecardRow(values: fields + Array(repeating: "", count: headerRow.count - fields.count))
            }
            return ScorecardRow(values: fields)
        }

        return ScorecardTable(headers: headerRow, rows: Array(rows))
    }
}
