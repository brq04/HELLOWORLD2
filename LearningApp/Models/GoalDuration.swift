import Foundation

enum GoalDuration: String, Codable, CaseIterable {
    case week, month, year

    var title: String {
        switch self {
        case .week:  return "Week"
        case .month: return "Month"
        case .year:  return "Year"
        }
    }

    /// Freezes allowed: 2 per week, 8 per month, 96 per year.
    var maxFreezes: Int {
        switch self {
        case .week:  return 2
        case .month: return 8
        case .year:  return 96
        }
    }

    /// Days needed to complete the goal.
    var days: Int {
        switch self {
        case .week:  return 7
        case .month: return 30
        case .year:  return 365
        }
    }
}
