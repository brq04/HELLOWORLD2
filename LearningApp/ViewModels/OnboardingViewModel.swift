import Foundation

import Combine
final class OnboardingViewModel: ObservableObject {
    @Published var subject: String = ""
    @Published var duration: GoalDuration = .week

    private let store: LearningStore

    init(store: LearningStore) {
        self.store = store
    }

    private var trimmed: String {
        subject.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var canStart: Bool { !trimmed.isEmpty }

    func start() {
        guard canStart else { return }
        store.startGoal(subject: trimmed, duration: duration)
    }
}
