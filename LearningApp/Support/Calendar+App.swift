import Foundation

extension Calendar {
    /// Always Gregorian, Sunday first (device calendar may be Islamic in Saudi region).
    static let app: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 1
        calendar.locale = Locale(identifier: "en_US")
        return calendar
    }()
}
