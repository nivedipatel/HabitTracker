import Combine
import CoreData

final class AddEditHabitViewModel {
    let habit: Habit?

    @Published var name = ""
    @Published var iconName = "star"
    @Published var colorHex = "#4CAF50"
    @Published var frequency: HabitFrequency = .daily
    @Published var reminderDate: Date?

    var title: String { habit == nil ? "New Habit" : "Edit Habit" }

    init(habit: Habit? = nil) {
        self.habit = habit
        if let h = habit {
            name = h.name
            iconName = h.iconName
            colorHex = h.colorHex
            frequency = h.frequencyEnum
            reminderDate = h.reminderTime
        }
    }

    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    func save() -> Bool {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return false }

        let context = Persistence.shared.context
        let h: Habit
        if let existing = habit {
            h = existing
        } else {
            h = Habit(context: context)
            h.id = UUID()
            h.createdAt = Date()
            h.sortOrder = Int16((try? context.count(for: Habit.fetchRequest())) ?? 0)
        }
        h.name = trimmed
        h.iconName = iconName
        h.colorHex = colorHex
        h.frequency = frequency.rawValue
        h.reminderTime = reminderDate

        Persistence.shared.saveContext()
        if let t = reminderDate { NotificationManager.shared.scheduleReminder(for: h) }
        else { NotificationManager.shared.cancelReminder(for: h) }
        return true
    }
}
