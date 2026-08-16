import Foundation

struct ScorecardRow: Identifiable, Hashable {
    let id = UUID()
    let values: [String]
}

struct ScorecardTable {
    let headers: [String]
    let rows: [ScorecardRow]

    static let empty = ScorecardTable(headers: [], rows: [])
}
