# 🔥 Streaks — Habit Tracker for iOS

A native iOS habit tracker built with SwiftUI and SwiftData, featuring home screen widgets, Live Activities, and Swift Charts for visualizing progress. Built as a portfolio project to demonstrate modern Apple frameworks beyond basic CRUD apps.

## ✨ Features

- **Create & track habits** with custom frequency (daily, specific weekdays, X times/week)
- **Streak tracking** with current streak, longest streak, and completion history
- **Home Screen Widgets** showing today's habits and current streaks at a glance
- **Live Activities** for habits with active timers (e.g., meditation, workout sessions)
- **Progress visualization** using Swift Charts (weekly/monthly completion trends, streak history)
- **Reminders** via local notifications
- **Fully offline** — all data stored locally with SwiftData, no account or backend required

## 🛠 Tech Stack

| Layer | Technology |
|---|---|
| UI | SwiftUI |
| Persistence | SwiftData |
| Widgets | WidgetKit |
| Real-time updates | ActivityKit (Live Activities) |
| Charts | Swift Charts |
| Notifications | UserNotifications |
| Architecture | MVVM |
| Min iOS Version | iOS 17+ |

## 🏗 Architecture

```
Streaks/
├── App/
│   └── StreaksApp.swift
├── Models/
│   ├── Habit.swift
│   └── HabitCompletion.swift
├── ViewModels/
│   ├── HabitListViewModel.swift
│   └── HabitDetailViewModel.swift
├── Views/
│   ├── HabitListView.swift
│   ├── HabitDetailView.swift
│   ├── AddHabitView.swift
│   └── StatsView.swift
├── Widgets/
│   └── StreaksWidget/
├── LiveActivities/
│   └── HabitTimerActivity.swift
└── Utilities/
    ├── StreakCalculator.swift
    └── NotificationManager.swift
```

The app follows **MVVM**: SwiftData models hold the source of truth, ViewModels expose observable state and business logic (e.g. streak calculation), and SwiftUI Views stay declarative and dumb.

## 🚀 Getting Started

### Requirements
- Xcode 16+
- iOS 17+ simulator or device
- Free Apple Developer account (for running on a physical device / widgets / Live Activities testing)

### Setup
```bash
git clone https://github.com/yourusername/streaks-ios.git
cd streaks-ios
open Streaks.xcodeproj
```
Select a simulator or your device, then hit **Run** (`Cmd + R`).

> Widgets and Live Activities are best tested on a physical device, as the simulator support for Live Activities is limited.

## 🧠 What I Learned / Engineering Notes

- Implementing **streak logic** correctly (handling timezones, "did I complete it today vs yesterday", grace periods) was more subtle than expected — see `StreakCalculator.swift` for the approach and edge cases handled.
- Sharing data between the main app and the widget extension required structuring SwiftData models in a shared App Group container.
- Live Activities required modeling habit "sessions" as a separate, time-bound entity from the habit itself.

## 🗺 Roadmap

- [ ] iCloud sync across devices
- [ ] Habit categories/tags
- [ ] Apple Watch companion app
- [ ] Customizable widget sizes (small/medium/large)
- [ ] Unit tests for streak calculation edge cases

## 📄 License

MIT License — feel free to fork and learn from this project.

## 📬 Contact

**Your Name** — [your.email@example.com](mailto:your.email@example.com) — [LinkedIn](https://linkedin.com) — [Portfolio](https://yourportfolio.com)
