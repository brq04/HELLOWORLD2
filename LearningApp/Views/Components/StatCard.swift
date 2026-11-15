import SwiftUI

struct StatCard: View {
    let systemImage: String
    let tint: Color
    let value: String      // "4 Days"
    let caption: String    // "Learned" / "Freezed"

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: systemImage)
                .font(.system(size: 22))
                .foregroundStyle(tint)
            Text(value)
                .font(.system(size: 17, weight: .semibold))
            Text(caption)
                .font(.system(size: 13))
                .foregroundStyle(Theme.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous).fill(Theme.card)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}
