import Combine
import CoreData

final class HomeViewModel {
    @Published var habits: [Habit] = []
    @Published var todayCompletions: Set<UUID> = []
    private let context = Persistence.shared.context
    var cancellables = Set<AnyCancellable>()

    func fetchHabits() {
        let request: NSFetchRequest<Habit> = Habit.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "sortOrder", ascending: true)]
        request.predicate = NSPredicate(format: "TRUEPREDICATE")
        if let results = try? context.fetch(request) {
            habits = results
        }
        updateTodayCompletions()
    }

    private func updateTodayCompletions() {
        let today = Date().startOfDay
        let completions = Set(habits.filter { h in
            h.completionDates.contains { Calendar.current.isDate($0, inSameDayAs: today) }
        }.map { $0.id })
        todayCompletions = completions
    }

    func toggleCompletion(for habit: Habit) {
        let today = Date().startOfDay
        if todayCompletions.contains(habit.id) {
            if let comp = (habit.completions?.allObjects as? [HabitCompletion])?.first(where: {
                Calendar.current.isDate($0.date, inSameDayAs: today)
            }) {
                context.delete(comp)
            }
        } else {
            let comp = HabitCompletion(context: context)
            comp.date = today
            comp.habit = habit
        }
        Persistence.shared.saveContext()
        fetchHabits()
    }

    func deleteHabit(_ habit: Habit) {
        NotificationManager.shared.cancelReminder(for: habit)
        context.delete(habit)
        Persistence.shared.saveContext()
        fetchHabits()
    }

    func moveHabit(from source: Int, to dest: Int) {
        var list = habits
        let item = list.remove(at: source)
        list.insert(item, at: dest > source ? dest - 1 : dest)
        for (i, h) in list.enumerated() {
            h.sortOrder = Int16(i)
        }
        Persistence.shared.saveContext()
        fetchHabits()
    }

    func isCompletedToday(_ habit: Habit) -> Bool {
        todayCompletions.contains(habit.id)
    }

    func streak(for habit: Habit) -> Int {
        StreakCalculator.currentStreak(completionDates: habit.completionDates, frequency: habit.frequencyEnum)
    }
}
