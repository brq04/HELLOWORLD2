import SwiftUI

struct ActivityView: View {
    let store: LearningStore
    @StateObject private var vm: ActivityViewModel

    init(store: LearningStore) {
        self.store = store
        _vm = StateObject(wrappedValue: ActivityViewModel(store: store))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            header

            WeekStrip(days: vm.weekDays)

            HStack(spacing: 12) {
                StatCard(systemImage: "flame.fill", tint: Theme.orange,
                         value: vm.learnedText, caption: Strings.learned)
                StatCard(systemImage: "snowflake", tint: Theme.blue,
                         value: vm.freezedText, caption: Strings.freezed)
            }

            Spacer(minLength: 0)
            content.frame(maxWidth: .infinity)
            Spacer(minLength: 0)

//            #if DEBUG
//            debugBar
//            #endif
        }
        .foregroundStyle(Color.white)
        .padding(.horizontal, 16)
        .background(Color.black.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
    }
//#if DEBUG
//private var debugBar: some View {
//    HStack(spacing: 8) {
//        debugButton("+1 Day") { vm.debugAdvance(hours: 24) }
//        debugButton("+33 Hours") { vm.debugAdvance(hours: 33) }
//        debugButton("Reset") { vm.debugReset() }
//    }
//    .padding(.bottom, 8)
//}
//
//private func debugButton(_ title: String, action: @escaping () -> Void) -> some View {
//    Button(title, action: action)
//        .font(.system(size: 13, weight: .medium))
//        .foregroundStyle(Color.white)
//        .padding(.horizontal, 12)
//        .padding(.vertical, 8)
//        .background(Capsule().fill(Color.red.opacity(0.7)))
//}
//#endif
    
    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(Strings.activity)
                    .font(.system(size: 34, weight: .bold))
                Text(vm.dateText)
                    .font(.system(size: 17))
                    .foregroundStyle(Theme.secondary)
            }
            Spacer()
            NavigationLink {
                CalendarView(store: store)
            } label: {
                CircleIcon(systemName: "calendar")
            }
            NavigationLink {
                GoalEditView(store: store)
            } label: {
                CircleIcon(systemName: "pencil.and.outline")
            }
        }
        .padding(.top, 8)
    }

    @ViewBuilder
    private var content: some View {
        switch vm.goalState {
        case .active:
            VStack(spacing: 48) {
                BigCircleButton(title: vm.logTitle,
                                isEnabled: vm.isLogEnabled,
                                action: { vm.logTapped() })
                VStack(spacing: 14) {
                    FreezeButton(title: vm.freezeTitle,
                                 isEnabled: vm.isFreezeEnabled,
                                 action: { vm.freezeTapped() })
                    Text(vm.freezeCaption)
                        .font(.system(size: 14))
                        .foregroundStyle(Theme.secondary)
                }
            }
        case .completed:
            finished(icon: "hands.clap.fill", title: Strings.wellDone, subtitle: Strings.nextGoal)
        case .failed:
            finished(icon: "xmark.seal", title: Strings.goalFailed, subtitle: Strings.setAnother)
        }
    }

    private func finished(icon: String, title: String, subtitle: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundStyle(Theme.orange)
                .padding(.bottom, 8)
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .multilineTextAlignment(.center)
            Text(subtitle)
                .font(.system(size: 15))
                .foregroundStyle(Theme.secondary)
            NavigationLink {
                GoalEditView(store: store)
            } label: {
                CapsuleLabel(title: Strings.setAGoal, systemImage: "pencil.and.outline")
            }
            .buttonStyle(.plain)
            .padding(.top, 48)
        }
    }
   
}
#Preview {
    NavigationStack {
        ActivityView(store: PreviewStore.sample())
    }
    .preferredColorScheme(.dark)
}
