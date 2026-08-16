import SwiftUI

struct StarRatingView: View {
    let count: Int
    var font: Font = .caption2

    var body: some View {
        HStack(spacing: 1) {
            ForEach(0..<5, id: \.self) { i in
                Image(systemName: i < count ? "star.fill" : "star")
                    .font(font)
                    .foregroundStyle(.yellow)
            }
        }
    }
}
