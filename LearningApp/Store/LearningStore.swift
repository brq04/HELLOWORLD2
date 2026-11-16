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
    @Published private(set) var isGoalFailed: Bool = false
    @Published private(set) var now: Date = Date()

    private let storage: StorageServiceProtocol
    private let calendar: Calendar = Calendar.app
    private let streakTimeout: TimeInterval = 32 * 60 * 60   // 32 hours

    // Used only by the debug buttons to fake time passing.
    private var timeOffset: TimeInterval = 0
    private var currentDate: Date { Date().addingTimeInterval(timeOffset) }

    init(storage: StorageServiceProtocol = StorageService()) {
        self.storage = storage
        if let saved = storage.load() {
            self.goal = saved.goal
            self.logs = saved.logs
            self.runStart = saved.runStart
            self.lastActivity = saved.lastActivity
            self.isGoalFailed = saved.goalFailed ?? false
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

    /// Learned + Frozen days both count toward the goal.
    var progressDays: Int { learnedCount + frozenCount }

    var goalState: GoalState {
        guard let goal = goal else { return .active }

        // 1) Reached the goal (frozen days count too).
        if progressDays >= goal.duration.days { return .completed }

        // 2) Missed a day without a freeze (32h passed).
        if isGoalFailed { return .failed }

        // 3) The goal period ended without reaching it.
        if let end = calendar.date(byAdding: .day, value: goal.duration.days, to: goal.startDate),
           now >= end {
            return .failed
        }
        return .active
    }

    /// Circle button: enabled only while the goal is active and today has no log yet.
    /// (After Freeze or Log it becomes gray. It is enabled again at 12AM.)
    var canLog: Bool {
        goalState == .active && todayStatus == nil
    }

    /// Freeze button: disabled if today is logged/frozen, or all freezes are used.
    var canFreeze: Bool {
        goalState == .active && todayStatus == nil && frozenCount < maxFreezes
    }

    // MARK: Actions

    func logToday() {
        refresh()
        guard canLog else { return }
        record(.learned)
    }

    func freezeToday() {
        refresh()
        guard canFreeze else { return }
        record(.frozen)
    }

    func startGoal(subject: String, duration: GoalDuration) {
        now = currentDate
        goal = LearningGoal(subject: subject, duration: duration, startDate: today)
        runStart = today
        lastActivity = now
        isGoalFailed = false
        persist()
    }

    /// Updating the goal restarts the streak.
    func updateGoal(subject: String, duration: GoalDuration) {
        startGoal(subject: subject, duration: duration)
    }

    /// Call on launch, when the app becomes active, and when the day changes.
    func refresh() {
        now = currentDate
        guard goalState == .active,
              let last = lastActivity,
              now.timeIntervalSince(last) > streakTimeout else { return }

        // More than 32 hours without Learned or Freeze: goal failed.
        isGoalFailed = true
        persist()
    }

    // MARK: Private

    private func record(_ status: DayStatus) {
        let day = today
        logs.removeAll(where: { $0.date == day })
        logs.append(DayLog(date: day, status: status))
        lastActivity = now
        persist()
    }

    private func persist() {
        storage.save(LearningSnapshot(goal: goal,
                                      logs: logs,
                                      runStart: runStart,
                                      lastActivity: lastActivity,
                                      goalFailed: isGoalFailed))
    }

    // MARK: Debug (testing only)

    #if DEBUG
    func debugAdvance(hours: Double) {
        timeOffset += hours * 3600
        refresh()
    }

    func debugReset() {
        timeOffset = 0
        goal = nil
        logs = []
        lastActivity = nil
        isGoalFailed = false
        now = Date()
        runStart = today
        persist()
    }
    #endif
}
