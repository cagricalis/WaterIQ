import WidgetKit
import SwiftUI

// MARK: - Entry
struct HydrationEntry: TimelineEntry {
    let date: Date
    let percent: Double
}

// MARK: - Provider
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> HydrationEntry {
        HydrationEntry(date: Date(), percent: 0.6)
    }

    func getSnapshot(in context: Context, completion: @escaping (HydrationEntry) -> Void) {
        completion(HydrationEntry(date: Date(), percent: 0.6))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<HydrationEntry>) -> Void) {
        let currentDate = Date()
        let entries = (0..<5).map { offset -> HydrationEntry in
            let entryDate = Calendar.current.date(byAdding: .hour, value: offset, to: currentDate)!
            let percent = Double.random(in: 0.3...1.0)
            return HydrationEntry(date: entryDate, percent: percent)
        }
        completion(Timeline(entries: entries, policy: .atEnd))
    }
}

// MARK: - Widget View
struct HydrationWidgetEntryView: View {
    var entry: HydrationEntry

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 8)
                .opacity(0.2)
                .foregroundColor(.blue)
            Circle()
                .trim(from: 0, to: entry.percent)
                .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .foregroundColor(.teal)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.6), value: entry.percent)
            VStack {
                Text("\(Int(entry.percent * 100))%")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                Text("Hedef")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding()
        .background(
            LinearGradient(colors: [.blue.opacity(0.4), .teal.opacity(0.3)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
        )
    }
}

// MARK: - Widget Configuration
@main
struct HydrationWidget: Widget {
    let kind: String = "HydrationWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            HydrationWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Hydration Progress")
        .description("Günlük su tüketim ilerlemen.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
