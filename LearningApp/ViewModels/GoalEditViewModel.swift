import Foundation

import Combine
final class GoalEditViewModel: ObservableObject {
    @Published var subject: String
    @Published var duration: GoalDuration
    @Published var showUpdateAlert: Bool = false

    private let store: LearningStore
    private let originalSubject: String
    private let originalDuration: GoalDuration

    init(store: LearningStore) {
        let startSubject = store.goal?.subject ?? ""
        let startDuration = store.goal?.duration ?? .week

        self.store = store
        self.originalSubject = startSubject
        self.originalDuration = startDuration
        self.subject = startSubject
        self.duration = startDuration
    }

    private var trimmed: String {
        subject.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var hasChanges: Bool {
        subject != originalSubject || duration != originalDuration
    }

    /// Saving is allowed when something changed, or when the old goal already ended
    /// (so she can start the same goal again).
    var canSave: Bool {
        !trimmed.isEmpty && (hasChanges || store.goalState != .active)
    }

    func checkmarkTapped() {
        if canSave { showUpdateAlert = true }
    }

    func confirmUpdate() {
        store.updateGoal(subject: trimmed, duration: duration)
    }
}
