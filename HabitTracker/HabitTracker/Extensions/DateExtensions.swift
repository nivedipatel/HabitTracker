import Foundation

extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }

    func daysFrom(_ other: Date) -> Int {
        Calendar.current.dateComponents([.day], from: other.startOfDay, to: startOfDay).day ?? 0
    }
}
