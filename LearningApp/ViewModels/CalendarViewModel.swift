import Foundation

import Combine
final class CalendarViewModel: ObservableObject {
    private let store: LearningStore

    init(store: LearningStore) {
        self.store = store
    }

    /// First day of each month, from the earliest activity (or goal start) to the current month.
    var months: [Date] {
        let calendar = Calendar.app
        var start = store.goal?.startDate ?? store.now
        if let firstLog = store.logs.map({ $0.date }).min(), firstLog < start {
            start = firstLog
        }
        guard var cursor = calendar.dateInterval(of: .month, for: start)?.start else { return [] }

        var result: [Date] = []
        while cursor <= store.now {
            result.append(cursor)
            guard let next = calendar.date(byAdding: .month, value: 1, to: cursor) else { break }
            cursor = next
        }
        return result
    }

    func status(on date: Date) -> DayStatus? {
        store.status(on: date)
    }
}
