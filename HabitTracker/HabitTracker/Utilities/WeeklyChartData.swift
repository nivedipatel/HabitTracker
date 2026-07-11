import Foundation

struct WeeklyChartData {
    let weekStart: Date
    let count: Int
    var label: String {
        let f = DateFormatter()
        f.dateFormat = "M/d"
        return f.string(from: weekStart)
    }
}
