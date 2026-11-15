import Foundation

struct LearningGoal: Codable {
    var subject: String
    var duration: GoalDuration
    var startDate: Date
}
