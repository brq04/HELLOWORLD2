import SwiftUI

struct DurationChips: View {
    @Binding var selection: GoalDuration

    var body: some View {
        HStack(spacing: 12) {
            ForEach(GoalDuration.allCases, id: \.self) { duration in
                chip(for: duration)
            }
        }
    }

    private func chip(for duration: GoalDuration) -> some View {
        let isSelected = (duration == selection)
        return Button {
            selection = duration
        } label: {
            Text(duration.title)
                .font(.system(size: 17))
                .foregroundStyle(isSelected ? Color.white : Theme.disabledText)
                .frame(width: 84, height: 44)
                .background(chipBackground(isSelected: isSelected))
                .overlay(
                    Capsule().stroke(Color.white.opacity(isSelected ? 0.35 : 0.08), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func chipBackground(isSelected: Bool) -> some View {
        if isSelected {
            Capsule().fill(
                LinearGradient(colors: [Theme.orangeLight, Theme.orange],
                               startPoint: .top, endPoint: .bottom)
            )
        } else {
            Capsule().fill(Color.white.opacity(0.08))
        }
    }
}

/// Used by both the Onboarding and Learning Goal screens.
struct GoalFormFields: View {
    @Binding var subject: String
    @Binding var duration: GoalDuration

    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            VStack(alignment: .leading, spacing: 10) {
                Text(Strings.iWantToLearn)
                    .font(.system(size: 17))

                TextField(Strings.placeholder, text: $subject)
                    .font(.system(size: 17))
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()

                Divider().overlay(Color.white.opacity(0.15))
            }

            VStack(alignment: .leading, spacing: 14) {
                Text(Strings.iWantToLearnItInA)
                    .font(.system(size: 17))
                DurationChips(selection: $duration)
            }
        }
    }
}
