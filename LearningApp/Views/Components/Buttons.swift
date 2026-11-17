import SwiftUI

/// Round glass icon (header buttons). Use as a label.
struct CircleIcon: View {
    let systemName: String
    var tint: Color = .white
    var background: Color? = nil      // glass tint

    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: 17, weight: .semibold))
            .foregroundStyle(tint)
            .frame(width: 44, height: 44)
            .glassBackground(Circle(), tint: background, interactive: true)
    }
}

/// Orange glass capsule (Start Learning, Set a goal). Use as a label.
struct CapsuleLabel: View {
    let title: String
    var systemImage: String? = nil

    var body: some View {
        HStack(spacing: 8) {
            if let systemImage = systemImage {
                Image(systemName: systemImage)
            }
            Text(title)
        }
        .font(.system(size: 17, weight: .medium))
        .foregroundStyle(Color.white)
        .padding(.horizontal, 28)
        .padding(.vertical, 14)
        .glassBackground(Capsule(), tint: Theme.orange, interactive: true)
    }
}

/// The big circle: "Log as Learned" / "Logged as Learned".
struct BigCircleButton: View {
    let title: String
    let isEnabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(isEnabled ? Color.white : Theme.disabledText)
                .frame(width: 272, height: 272)
                .background(Circle().fill(isEnabled ? Color.clear : Theme.disabled))
                .glassBackground(Circle(),
                                 tint: isEnabled ? Theme.orange : nil,
                                 interactive: isEnabled)
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
    }
}

/// "Freeze for a day" / "Freezed for a day".
struct FreezeButton: View {
    let title: String
    let isEnabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(isEnabled ? Color.white : Theme.disabledText)
                .frame(width: 272, height: 46)
                .background(Capsule().fill(isEnabled ? Color.clear : Theme.disabled))
                .glassBackground(Capsule(),
                                 tint: isEnabled ? Theme.blue : nil,
                                 interactive: isEnabled)
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
    }
}
