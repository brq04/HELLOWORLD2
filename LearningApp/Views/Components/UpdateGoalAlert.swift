import SwiftUI

/// "Update goal" popup: Dismiss / Update.
struct UpdateGoalAlert: View {
    let onDismiss: () -> Void
    let onUpdate: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.55)
                .ignoresSafeArea()
                .onTapGesture { onDismiss() }

            VStack(alignment: .leading, spacing: 8) {
                Text(Strings.updateTitle)
                    .font(.system(size: 17, weight: .semibold))

                Text(Strings.updateMessage)
                    .font(.system(size: 15))
                    .foregroundStyle(Color(white: 0.75))

                HStack(spacing: 12) {
                    Button(action: onDismiss) {
                        Text(Strings.dismiss)
                            .font(.system(size: 17, weight: .medium))
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Capsule().fill(Color(white: 0.22)))
                    }
                    Button(action: onUpdate) {
                        Text(Strings.update)
                            .font(.system(size: 17, weight: .medium))
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Capsule().fill(Theme.orange))
                    }
                }
                .buttonStyle(.plain)
                .padding(.top, 12)
            }
            .foregroundStyle(Color.white)
            .padding(20)
            .frame(width: 300)
            .background(
                RoundedRectangle(cornerRadius: 32, style: .continuous).fill(Color(white: 0.12))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
        }
    }
}
