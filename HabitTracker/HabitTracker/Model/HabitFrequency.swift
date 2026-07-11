import Foundation

enum HabitFrequency: String, CaseIterable, Codable, Hashable {
    case daily = "Daily"
    case weekly = "Weekly"
    case weekday = "Weekdays"
    case weekend = "Weekends"
}

extension Habit {
    var frequencyEnum: HabitFrequency {
        HabitFrequency(rawValue: frequency) ?? .daily
    }
}
