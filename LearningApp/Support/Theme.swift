import SwiftUI

enum Theme {
    static let orange       = Color(red: 0.96, green: 0.54, blue: 0.16)
    static let orangeLight  = Color(red: 1.00, green: 0.63, blue: 0.28)
    static let orangeDim    = Color(red: 0.17, green: 0.09, blue: 0.03)
    static let blue         = Color(red: 0.18, green: 0.78, blue: 0.96)
    static let blueDim      = Color(red: 0.03, green: 0.12, blue: 0.16)
    static let card         = Color(white: 0.07)
    static let disabled     = Color(white: 0.13)
    static let disabledText = Color(white: 0.42)
    static let secondary    = Color(white: 0.55)
}

enum Formats {
    private static func make(_ format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.calendar = Calendar.app
        formatter.dateFormat = format
        return formatter
    }

    static let weekdayLetter = make("EEEEE")         // S M T W T F S
    static let header        = make("EEEE, d MMMM")  // Thursday, 24 October
    static let month         = make("MMMM yyyy")     // January 2026
    static let weekdayHeaders = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
}
