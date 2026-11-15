import Foundation

import Combine
enum GoalState {
    case active
    case completed
    case failed
}

/// Single source of truth. All streak and freeze rules live here.
final class LearningStore: ObservableObject {
    @Published private(set) var goal: LearningGoal? = nil
    @Published private(set) var logs: [DayLog] = []
    @Published private(set) var runStart: Date = Date()
    @Published private(set) var lastActivity: Date? = nil
    @Published private(set) var now: Date = Date()

    private let storage: StorageServiceProtocol
    private let calendar: Calendar = Calendar.app
    private let streakTimeout: TimeInterval = 32 * 60 * 60   // 32 hours

    //private var timeOffset: TimeInterval = 0
    //private var currentDate: Date { Date().addingTimeInterval(timeOffset) }

    init(storage: StorageServiceProtocol = StorageService()) {
        self.storage = storage
        if let saved = storage.load() {
            self.goal = saved.goal
            self.logs = saved.logs
            self.runStart = saved.runStart
            self.lastActivity = saved.lastActivity
        }
        refresh()
    }

    // MARK: Derived state

    var today: Date { calendar.startOfDay(for: now) }

    var todayStatus: DayStatus? { status(on: now) }

    func status(on date: Date) -> DayStatus? {
        let day = calendar.startOfDay(for: date)
        return logs.first(where: { $0.date == day })?.status
    }

    private var runLogs: [DayLog] {
        logs.filter { $0.date >= runStart }
    }

    var learnedCount: Int { runLogs.filter { $0.status == .learned }.count }
    var frozenCount: Int { runLogs.filter { $0.status == .frozen }.count }
    var maxFreezes: Int { goal?.duration.maxFreezes ?? 0 }

    /// Log button is disabled once today is logged as learned.
    var canLog: Bool { todayStatus != .learned }

    /// Freeze button is disabled if a day is logged/frozen or all freezes are used.
    /// It becomes available again at 12AM because "today" changes.
    var canFreeze: Bool { todayStatus == nil && frozenCount < maxFreezes }

    var goalState: GoalState {
        guard let goal = goal,
              let end = calendar.date(byAdding: .day, value: goal.duration.days, to: goal.startDate),
              now >= end else { return .active }
        return learnedCount >= goal.duration.days ? .completed : .failed
    }

    // MARK: Actions

    func logToday() {
        record(.learned)
    }

    func freezeToday() {
        refresh()
        if canFreeze { record(.frozen) }
    }

    func startGoal(subject: String, duration: GoalDuration) {
        now = Data()
        goal = LearningGoal(subject: subject, duration: duration, startDate: today)
        resetStreak()
    }

    /// Updating the goal restarts the streak.
    func updateGoal(subject: String, duration: GoalDuration) {
        startGoal(subject: subject, duration: duration)
    }

    /// Call on launch, when the app becomes active, and when the day changes.
    func refresh() {
        now = Date()
        if let last = lastActivity, now.timeIntervalSince(last) > streakTimeout {
            resetStreak()
        }
    }
//#if DEBUG
//func debugAdvance(hours: Double) {
//    timeOffset += hours * 3600
//    refresh()
//}

//func debugReset() {
//    timeOffset = 0
//    goal = nil
//    logs = []
//    lastActivity = nil
//    now = Date()
//    runStart = today
//    persist()
//}
//#endif
    
    // MARK: Private

    private func record(_ status: DayStatus) {
        refresh()
        let day = today
        logs.removeAll(where: { $0.date == day })
        logs.append(DayLog(date: day, status: status))
        lastActivity = now
        persist()
    }

    private func resetStreak() {
        runStart = today
        lastActivity = now
        persist()
    }

    private func persist() {
        storage.save(LearningSnapshot(goal: goal, logs: logs, runStart: runStart, lastActivity: lastActivity))
    }
}
