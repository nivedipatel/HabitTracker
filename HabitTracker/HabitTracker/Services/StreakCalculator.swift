import Foundation

enum StreakCalculator {
    static func currentStreak(completionDates: [Date], frequency: HabitFrequency) -> Int {
        let cal = Calendar.current
        let sorted = completionDates.sorted(by: >)
        guard !sorted.isEmpty else { return 0 }

        var streak = 1
        let today = cal.startOfDay(for: Date())
        let mostRecent = cal.startOfDay(for: sorted[0])

        // only count streak if last completion is today or yesterday
        let diff = cal.dateComponents([.day], from: mostRecent, to: today).day ?? 0
        guard diff <= 1 else { return 0 }

        for i in 1..<sorted.count {
            let prev = cal.startOfDay(for: sorted[i - 1])
            let curr = cal.startOfDay(for: sorted[i])
            let expectedGap = gapDays(frequency)
            let actualGap = cal.dateComponents([.day], from: curr, to: prev).day ?? 0
            if actualGap == expectedGap {
                streak += 1
            } else {
                break
            }
        }
        return streak
    }

    static func longestStreak(completionDates: [Date], frequency: HabitFrequency) -> Int {
        let cal = Calendar.current
        let sorted = completionDates.sorted()
        guard !sorted.isEmpty else { return 0 }

        var longest = 1, current = 1
        for i in 1..<sorted.count {
            let prev = cal.startOfDay(for: sorted[i - 1])
            let curr = cal.startOfDay(for: sorted[i])
            let expectedGap = gapDays(frequency)
            let actualGap = cal.dateComponents([.day], from: prev, to: curr).day ?? 0
            if actualGap <= expectedGap {
                current += 1
            } else {
                longest = max(longest, current)
                current = 1
            }
        }
        return max(longest, current)
    }

    private static func gapDays(_ frequency: HabitFrequency) -> Int {
        switch frequency {
        case .daily: return 1
        case .weekly: return 7
        case .weekday: return 2
        case .weekend: return 2
        }
    }
}
