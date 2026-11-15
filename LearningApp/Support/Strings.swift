import Foundation

enum Strings {
    // Screens
    static let hello = "Hello "
    static let learner = "Learner"
    static let onboardingSubtitle = "This app will help you learn everyday!"
    static let iWantToLearn = "I want to learn"
    static let iWantToLearnItInA = "I want to learn it in a"
    static let placeholder = "Swift"
    static let startLearning = "Start Learning"
    static let editLater = "You can edit your desire later"
    static let activity = "Activity"
    static let learningGoal = "Learning Goal"
    static let activities = "Activities"

    // Streak / freeze
    static func days(_ count: Int) -> String { "\(count) \(count == 1 ? "Day" : "Days")" }
    static let learned = "Learned"
    static let freezed = "Freezed"

    static let logAsLearned = "Log as Learned"
    static let loggedAsLearned = "Logged as Learned"
    static let freezeForADay = "Freeze for a day"
    static let freezedForADay = "Freezed for a day"
    static func freezesUsed(_ used: Int, of max: Int) -> String {
        "\(used) out of \(max) Freezes used"
    }

    // Goal finished
    static let wellDone = "Well done!"
    static let nextGoal = "Ready for your next goal?"
    static let goalFailed = "You didn't reach your goal this time."
    static let setAnother = "Want to set another goal?"
    static let setAGoal = "Set a goal"

    // Update alert
    static let updateTitle = "Update goal"
    static let updateMessage = "If you update now, your streak will start over."
    static let dismiss = "Dismiss"
    static let update = "Update"
}
