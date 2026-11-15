import SwiftUI

struct OnboardingView: View {
    @StateObject private var vm: OnboardingViewModel

    init(store: LearningStore) {
        _vm = StateObject(wrappedValue: OnboardingViewModel(store: store))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(systemName: "flame.fill")
                .font(.system(size: 44))
                .foregroundStyle(Theme.orange)
                .frame(maxWidth: .infinity)
                .padding(.top, 60)

            VStack(alignment: .leading, spacing: 4) {
                titleText
                Text(Strings.onboardingSubtitle)
                    .font(.system(size: 17))
                    .foregroundStyle(Theme.secondary)
            }
            .padding(.top, 70)

            GoalFormFields(subject: $vm.subject, duration: $vm.duration)
                .padding(.top, 40)

            Spacer()

            VStack(spacing: 12) {
                Button {
                    vm.start()
                } label: {
                    CapsuleLabel(title: Strings.startLearning)
                }
                .buttonStyle(.plain)
                .disabled(!vm.canStart)
                .opacity(vm.canStart ? 1 : 0.4)

                Text(Strings.editLater)
                    .font(.system(size: 12))
                    .foregroundStyle(Theme.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 24)
        }
        .foregroundStyle(Color.white)
        .padding(.horizontal, 20)
        .background(Color.black.ignoresSafeArea())
    }

    private var titleText: some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            Text(Strings.hello).font(.system(size: 40, weight: .light))
            Text(Strings.learner).font(.system(size: 40, weight: .bold))
        }
    }
   
}
#Preview {
    OnboardingView(store: PreviewStore.empty())
        .preferredColorScheme(.dark)
}
