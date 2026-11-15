import Foundation

enum DayStatus: String, Codable {
    case learned
    case frozen
}

struct DayLog: Codable, Identifiable {
    let date: Date          // always start of day
    var status: DayStatus

    var id: Date { date }
}
