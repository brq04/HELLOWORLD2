import Foundation
import Combine

struct WeekDay: Identifiable {
    let date: Date
    let status: DayStatus?
    let isToday: Bool

    var id: Date { date }
}

final class ActivityViewModel: ObservableObject {
    private let store: LearningStore
    private var cancellables = Set<AnyCancellable>()

    init(store: LearningStore) {
        self.store = store
        store.objectWillChange
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }

    // Header
    var dateText: String { Formats.header.string(from: store.now) }

    // Stat cards
    var learnedText: String { Strings.days(store.learnedCount) }
    var freezedText: String { Strings.days(store.frozenCount) }

    // Buttons
    var logTitle: String {
        store.todayStatus == .learned ? Strings.loggedAsLearned : Strings.logAsLearned
    }
    var freezeTitle: String {
        store.todayStatus == .frozen ? Strings.freezedForADay : Strings.freezeForADay
    }
    var freezeCaption: String { Strings.freezesUsed(store.frozenCount, of: store.maxFreezes) }
    var isLogEnabled: Bool { store.canLog }
    var isFreezeEnabled: Bool { store.canFreeze }

    var goalState: GoalState { store.goalState }

    // Week strip (Sunday first)
    var weekDays: [WeekDay] {
        let calendar = Calendar.app
        guard let start = calendar.dateInterval(of: .weekOfYear, for: store.now)?.start else { return [] }
        return (0..<7).compactMap { offset -> WeekDay? in
            guard let date = calendar.date(byAdding: .day, value: offset, to: start) else { return nil }
            return WeekDay(date: date,
                           status: store.status(on: date),
                           isToday: calendar.isDate(date, inSameDayAs: store.now))
        }
    }

    func logTapped() { store.logToday() }
    func freezeTapped() { store.freezeToday() }
#if DEBUG
func debugAdvance(hours: Double) { store.debugAdvance(hours: hours) }
func debugReset() { store.debugReset() }
#endif
}
