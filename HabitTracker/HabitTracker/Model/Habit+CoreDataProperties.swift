import Foundation
import CoreData

extension Habit {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Habit> {
        NSFetchRequest<Habit>(entityName: "Habit")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var iconName: String
    @NSManaged public var colorHex: String
    @NSManaged public var frequency: String
    @NSManaged public var reminderTime: Date?
    @NSManaged public var sortOrder: Int16
    @NSManaged public var createdAt: Date
    @NSManaged public var completions: NSSet?

    var completionDates: [Date] {
        (completions?.allObjects as? [HabitCompletion])?
            .map { $0.date }
            .sorted() ?? []
    }

    var lastCompletedDate: Date? { completionDates.last }
}

extension Habit: Identifiable {}
