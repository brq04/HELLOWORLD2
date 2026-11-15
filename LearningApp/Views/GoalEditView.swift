import SwiftUI

struct GoalEditView: View {
    @StateObject private var vm: GoalEditViewModel
    @Environment(\.dismiss) private var dismiss

    init(store: LearningStore) {
        _vm = StateObject(wrappedValue: GoalEditViewModel(store: store))
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(alignment: .leading) {
                GoalFormFields(subject: $vm.subject, duration: $vm.duration)
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                Spacer()
            }
            .foregroundStyle(Color.white)

            if vm.showUpdateAlert {
                UpdateGoalAlert(
                    onDismiss: { vm.showUpdateAlert = false },
                    onUpdate: {
                        vm.confirmUpdate()
                        dismiss()
                    }
                )
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: vm.showUpdateAlert)
        .navigationTitle(Strings.learningGoal)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    CircleIcon(systemName: "chevron.left")
                }
                .disabled(vm.showUpdateAlert)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    vm.checkmarkTapped()
                } label: {
                    CircleIcon(systemName: "checkmark", background: Theme.orange)
                }
                .disabled(!vm.canSave || vm.showUpdateAlert)
                .opacity(vm.canSave ? 1 : 0.4)
            }
        }
    }
    
}
#Preview {
    NavigationStack {
        GoalEditView(store: PreviewStore.sample())
    }
    .preferredColorScheme(.dark)
}
