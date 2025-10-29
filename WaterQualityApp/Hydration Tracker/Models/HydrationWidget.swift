//
//  HydrationWidget.swift
//  WaterQualityAppWidgetExtension
//
//  Created by Çağrı Mehmet Çalış on 29.10.2025.
//

import WidgetKit
import SwiftUI

// MARK: - Timeline Provider
struct HydrationProvider: TimelineProvider {
    func placeholder(in context: Context) -> HydrationEntry {
        HydrationEntry(date: Date(), todayML: 1200, goalML: 2000)
    }

    func getSnapshot(in context: Context, completion: @escaping (HydrationEntry) -> Void) {
        let entry = HydrationEntry(date: Date(), todayML: 1500, goalML: 2000)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<HydrationEntry>) -> Void) {
        let defaults = UserDefaults(suiteName: "group.Onlock.WaterQualityApp")

        let todayML = defaults?.integer(forKey: "todayML") ?? 0
        let goalML = defaults?.integer(forKey: "goalML") ?? 2000

        let entry = HydrationEntry(date: Date(), todayML: todayML, goalML: goalML)
        let next = Calendar.current.date(byAdding: .minute, value: 30, to: Date())!
        completion(Timeline(entries: [entry], policy: .after(next)))
    }

}

// MARK: - Entry
struct HydrationEntry: TimelineEntry {
    let date: Date
    let todayML: Int
    let goalML: Int

    var progress: Double {
        guard goalML > 0 else { return 0 }
        return min(Double(todayML) / Double(goalML), 1.0)
    }
}

// MARK: - Widget UI
struct HydrationWidgetEntryView: View {
    var entry: HydrationProvider.Entry

    var body: some View {
        ZStack {
            LinearGradient(colors: [.hSoftBlue, .white],
                           startPoint: .topLeading, endPoint: .bottomTrailing)

            VStack(spacing: 8) {
                // Progress Halkası
                ZStack {
                    Circle()
                        .stroke(Color.hBlue.opacity(0.2), lineWidth: 10)
                    Circle()
                        .trim(from: 0, to: entry.progress)
                        .stroke(
                            LinearGradient(colors: [.hTeal, .hBlue],
                                           startPoint: .top,
                                           endPoint: .bottom),
                            style: StrokeStyle(lineWidth: 10, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut, value: entry.progress)

                    VStack(spacing: 4) {
                        Text("\(Int(entry.progress * 100))%")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.hNavy)
                        Text("\(entry.todayML) / \(entry.goalML) ml")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.hNavy.opacity(0.8))
                    }
                }
                .frame(width: 80, height: 80)

                // Alt yazı
                Text(entry.progress >= 1.0 ? "Hedef Tamamlandı 💧" : "Su içmeyi unutma!")
                    .font(.caption2)
                    .foregroundColor(.hNavy.opacity(0.7))
            }
            .padding()
        }
    }
}

// MARK: - Widget Tanımı
struct HydrationWidget: Widget {
    let kind: String = "HydrationWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HydrationProvider()) { entry in
            HydrationWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Su Takip Widget’ı")
        .description("Günlük su tüketimini takip et.")
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryCircular, .accessoryInline])
    }
}
