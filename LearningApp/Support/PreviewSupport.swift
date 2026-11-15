//
//  PreviewSupport.swift
//  MyApp
//
//  Created by malhajri on 02/06/1448 AH.
//
import Foundation

/// Fake storage so previews never touch real saved data.
final class InMemoryStorage: StorageServiceProtocol {
    private var snapshot: LearningSnapshot?

    init(snapshot: LearningSnapshot? = nil) {
        self.snapshot = snapshot
    }

    func load() -> LearningSnapshot? { snapshot }
    func save(_ snapshot: LearningSnapshot) { self.snapshot = snapshot }
}

enum PreviewStore {
    /// No goal yet (Onboarding).
    static func empty() -> LearningStore {
        LearningStore(storage: InMemoryStorage())
    }

    /// A weekly goal with a few learned and frozen days (Activity, Goal, Calendar).
    static func sample() -> LearningStore {
        let calendar = Calendar.app
        let today = calendar.startOfDay(for: Date())
        let start = calendar.date(byAdding: .day, value: -4, to: today) ?? today

        var logs: [DayLog] = []
        for offset in 1...4 {
            if let day = calendar.date(byAdding: .day, value: -offset, to: today) {
                logs.append(DayLog(date: day, status: offset == 2 ? .frozen : .learned))
            }
        }

        let goal = LearningGoal(subject: "Swift", duration: .week, startDate: start)
        let snapshot = LearningSnapshot(goal: goal, logs: logs, runStart: start, lastActivity: Date())
        return LearningStore(storage: InMemoryStorage(snapshot: snapshot))
    }
}
