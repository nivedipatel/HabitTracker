import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry { SimpleEntry(date: Date(), streak: 0) }
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) { completion(SimpleEntry(date: Date(), streak: 0)) }
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let habits = (try? Persistence.shared.container.viewContext.fetch(Habit.fetchRequest())) as? [Habit] ?? []
        let streak = habits.map { StreakCalculator.currentStreak(completionDates: $0.completionDates, frequency: $0.frequencyEnum) }.max() ?? 0
        completion(Timeline(entries: [SimpleEntry(date: Date(), streak: streak)], policy: .after(Date().addingTimeInterval(3600))))
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let streak: Int
}

struct StreaksWidgetEntryView: View {
    var entry: SimpleEntry
    var body: some View {
        VStack { Text("Streak").font(.headline); Text("\\(entry.streak)").font(.system(size: 48, weight: .bold)).foregroundStyle(.green); Text("days").font(.caption) }
            .padding()
            .background(.background)
    }
}

struct StreaksWidget: Widget {
    let kind = "StreaksWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in StreaksWidgetEntryView(entry: entry) }
            .configurationDisplayName("Streak")
            .description("Your current streak.")
            .supportedFamilies([.systemSmall])
    }
}
