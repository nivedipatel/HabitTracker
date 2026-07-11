import Foundation
import CoreData

extension HabitCompletion {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<HabitCompletion> {
        NSFetchRequest<HabitCompletion>(entityName: "HabitCompletion")
    }

    @NSManaged public var date: Date
    @NSManaged public var habit: Habit?
}
