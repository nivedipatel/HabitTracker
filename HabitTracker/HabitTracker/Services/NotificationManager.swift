import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    func scheduleReminder(for habit: Habit) {
        guard let time = habit.reminderTime else { return }
        let content = UNMutableNotificationContent()
        content.title = "Streaks"
        content.body = "Don't forget: \(habit.name)"
        content.sound = .default

        var dc = DateComponents()
        dc.hour = Calendar.current.component(.hour, from: time)
        dc.minute = Calendar.current.component(.minute, from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dc, repeats: true)
        let request = UNNotificationRequest(identifier: habit.id.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    func cancelReminder(for habit: Habit) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [habit.id.uuidString])
    }
}
