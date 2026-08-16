import SwiftUI

struct BrandDetailView: View {
    let target: BrandNavigationTarget

    private var brandName: String {
        target.row.values.first ?? ""
    }

    private var detail: BrandDetail? {
        BrandDetailLoader.detail(for: brandName, in: target.category)
    }

    private var displayFields: [BrandDetailField] {
        (detail?.fields ?? []).filter { !["Total Score", "Rating"].contains($0.label) }
    }

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text(brandName)
                        .font(.title2.bold())

                    if let ratingValue = detail?.fields.first(where: { $0.label.lowercased() == "rating" })?.value,
                       let rating = Int(ratingValue) {
                        StarRatingView(count: rating, font: .body)
                    }

                    if let total = detail?.totalScore {
                        Text(scoreSummary(total: total))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }

            if !displayFields.isEmpty {
                Section("Details") {
                    ForEach(displayFields) { field in
                        fieldRow(field)
                    }
                }
            }

            if let summary = detail?.summary, !summary.isEmpty {
                Section("Summary") {
                    Text(summary)
                        .font(.subheadline)
                }
            }

            if let criteria = detail?.criteria, !criteria.isEmpty {
                Section("Scoring Criteria") {
                    ForEach(criteria) { item in
                        CriterionRow(item: item)
                    }
                }
            }

            if detail == nil {
                Section {
                    Text("Additional scoring details aren't available for this brand.")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle(brandName)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func websiteURL(from value: String) -> URL? {
        let trimmed = value.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return nil }
        if trimmed.lowercased().hasPrefix("http://") || trimmed.lowercased().hasPrefix("https://") {
            return URL(string: trimmed)
        }
        return URL(string: "https://\(trimmed)")
    }

    private func scoreSummary(total: String) -> String {
        if let possible = detail?.possibleScore {
            return "Score: \(total) of \(possible) possible"
        }
        return "Score: \(total)"
    }

    @ViewBuilder
    private func fieldRow(_ field: BrandDetailField) -> some View {
        if field.label == "Website", let url = websiteURL(from: field.value) {
            Link(destination: url) {
                HStack {
                    Text(field.label)
                        .foregroundStyle(.primary)
                    Spacer()
                    Text(field.value)
                        .lineLimit(1)
                        .truncationMode(.middle)
                }
            }
        } else {
            HStack(alignment: .firstTextBaseline) {
                Text(field.label)
                Spacer()
                Text(field.value)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.trailing)
            }
        }
    }
}

private struct CriterionRow: View {
    let item: BrandCriterion
    @State private var showDescription = false

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .firstTextBaseline) {
                Text(item.criteria)
                    .font(.subheadline.bold())
                Spacer()
                if !item.points.isEmpty {
                    Text(item.points)
                        .font(.subheadline.monospacedDigit())
                        .foregroundStyle(.secondary)
                }
            }

            if !item.comment.isEmpty {
                Text(item.comment)
                    .font(.caption)
                    .foregroundStyle(.primary)
            }

            if !item.description.isEmpty {
                Button {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        showDescription.toggle()
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(showDescription ? "Hide why this matters" : "Why this matters")
                        Image(systemName: showDescription ? "chevron.up" : "chevron.down")
                    }
                    .font(.caption2)
                }
                .buttonStyle(.plain)
                .foregroundStyle(.blue)

                if showDescription {
                    Text(item.description)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 2)
    }
}
