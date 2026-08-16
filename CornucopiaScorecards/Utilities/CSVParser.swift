import Foundation

enum CSVParser {
    static func parse(_ text: String) -> [[String]] {
        var rows: [[String]] = []
        var currentRow: [String] = []
        var currentField = ""
        var inQuotes = false

        // Swift collapses "\r\n" into a single Character (grapheme cluster), so
        // normalize line endings to "\n" up front rather than trying to match
        // "\r", "\n", and the combined "\r\n" grapheme separately below.
        let normalized = text
            .replacingOccurrences(of: "\r\n", with: "\n")
            .replacingOccurrences(of: "\r", with: "\n")
        let chars = Array(normalized)
        var i = 0
        while i < chars.count {
            let c = chars[i]
            if inQuotes {
                if c == "\"" {
                    if i + 1 < chars.count, chars[i + 1] == "\"" {
                        currentField.append("\"")
                        i += 2
                    } else {
                        inQuotes = false
                        i += 1
                    }
                } else {
                    currentField.append(c)
                    i += 1
                }
            } else if c == "\"" {
                inQuotes = true
                i += 1
            } else if c == "," {
                currentRow.append(currentField)
                currentField = ""
                i += 1
            } else if c == "\n" {
                currentRow.append(currentField)
                rows.append(currentRow)
                currentRow = []
                currentField = ""
                i += 1
            } else {
                currentField.append(c)
                i += 1
            }
        }

        if !currentField.isEmpty || !currentRow.isEmpty {
            currentRow.append(currentField)
            rows.append(currentRow)
        }

        return rows.filter { !($0.count == 1 && $0[0].isEmpty) }
    }
}
