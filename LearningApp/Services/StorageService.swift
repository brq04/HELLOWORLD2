import Foundation

struct LearningSnapshot: Codable {
    var goal: LearningGoal?
    var logs: [DayLog]
    var runStart: Date
    var lastActivity: Date?
    var goalFailed: Bool? 
}

protocol StorageServiceProtocol {
    func load() -> LearningSnapshot?
    func save(_ snapshot: LearningSnapshot)
}

final class StorageService: StorageServiceProtocol {
    private let key = "learning.snapshot"

    func load() -> LearningSnapshot? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(LearningSnapshot.self, from: data)
    }

    func save(_ snapshot: LearningSnapshot) {
        guard let data = try? JSONEncoder().encode(snapshot) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}
