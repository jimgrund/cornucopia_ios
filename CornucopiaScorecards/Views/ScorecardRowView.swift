import SwiftUI

struct ScorecardRowView: View {
    let headers: [String]
    let values: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(values.first ?? "")
                .font(.headline)

            ForEach(Array(headers.enumerated()).dropFirst(), id: \.offset) { index, header in
                if let value = values[safe: index], !value.isEmpty {
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(header):")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        if header.lowercased() == "rating", let stars = Int(value), stars >= 0, stars <= 5 {
                            StarRatingView(count: stars)
                        } else {
                            Text(value)
                                .font(.caption)
                                .foregroundStyle(.primary)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}
