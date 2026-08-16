import SwiftUI

struct ProductFilterSheet: View {
    let columnLabel: String
    let options: [String]
    @Binding var selected: Set<String>

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List(options, id: \.self) { option in
                Button {
                    toggle(option)
                } label: {
                    HStack {
                        Text(option)
                            .foregroundStyle(.primary)
                        Spacer()
                        if selected.contains(option.lowercased()) {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Filter by \(columnLabel)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Clear") {
                        selected.removeAll()
                    }
                    .disabled(selected.isEmpty)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }

    private func toggle(_ option: String) {
        let key = option.lowercased()
        if selected.contains(key) {
            selected.remove(key)
        } else {
            selected.insert(key)
        }
    }
}
