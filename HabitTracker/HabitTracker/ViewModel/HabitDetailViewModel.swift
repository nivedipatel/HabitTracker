import Foundation

final class HabitDetailViewModel {
    let habit: Habit

    init(habit: Habit) {
        self.habit = habit
    }

    var currentStreak: Int {
        StreakCalculator.currentStreak(completionDates: habit.completionDates, frequency: habit.frequencyEnum)
    }

    var longestStreak: Int {
        StreakCalculator.longestStreak(completionDates: habit.completionDates, frequency: habit.frequencyEnum)
    }

    var weeklyData: [WeeklyChartData] {
        let c = Calendar.current
        let t = Date()
        guard let s = c.date(byAdding: .month, value: -3, to: t) else { return [] }
        var r: [WeeklyChartData] = []
        var w = c.date(from: c.dateComponents([.yearForWeekOfYear, .weekOfYear], from: s))!
        while w <= t {
            guard let we = c.date(byAdding: .day, value: 7, to: w) else { break }
            r.append(WeeklyChartData(weekStart: w, count: habit.completionDates.filter { $0 >= w && $0 < we }.count))
            w = we
        }
        return r
    }

    var heatmapDays: [[HeatmapDay]] {
        let c = Calendar.current
        let t = c.startOfDay(for: Date())
        guard let s = c.date(byAdding: .day, value: -90, to: t) else { return [] }
        var g: [[HeatmapDay]] = []
        var cd = s
        while cd <= t {
            var wk: [HeatmapDay] = []
            for _ in 0..<7 {
                let dd = c.date(from: c.dateComponents([.year, .month, .day], from: cd)) ?? cd
                let f = dd > t
                wk.append(HeatmapDay(date: dd, completed: !f && habit.completionDates.contains(where: { c.isDate($0, inSameDayAs: dd) }), isFuture: f))
                guard let n = c.date(byAdding: .day, value: 1, to: cd) else { break }
                cd = n
            }
            g.append(wk)
        }
        return g
    }
}
