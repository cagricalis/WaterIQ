//
//  HydrationViewModel.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 29.10.2025.
//

import Foundation
import CoreData
import SwiftUI
import WidgetKit


@MainActor
final class HydrationViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var todayML: Int = 0
    @Published var goalML: Int = 2000
    @Published var quickOptions: [Int] = [200, 300, 500]
    @Published var profile: UserProfile?
    @Published var weeklyData: [(Date, Int)] = []

    private let store: HydrationStore

    // MARK: - Init
    init(ctx: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.store = HydrationStore(ctx: ctx)
    }

    // MARK: - Load Data
    func load() async {
        do {
            profile = try store.ensureProfile()
            goalML = Int(profile?.goalML ?? 2000)
            todayML = try store.todayTotalML()
            weeklyData = try store.rangeTotals(daySpan: 7)
            syncToWidget() // ilk açılışta widget senkronizasyonu
        } catch {
            print("Hydration load error:", error)
        }
    }

    // MARK: - Add Water Intake
    func addIntake(ml: Int, source: String) async {
        do {
            try store.addIntake(ml: ml, source: source)

            // 🔹 UI değişiklikleri ana thread’de
            await MainActor.run {
                todayML += ml
                if let newData = try? store.rangeTotals(daySpan: 7) {
                    weeklyData = newData
                }
                syncToWidget() // 🔹 widget güncelle
            }
        } catch {
            print("Add intake error:", error)
        }
    }

    // MARK: - Progress
    func progressPercent() -> Double {
        guard goalML > 0 else { return 0 }
        return min(Double(todayML) / Double(goalML), 1.0)
    }

    // MARK: - Goal Calculation
    func recalcGoal(weight: Double, height: Double, activity: ActivityLevel) async {
        guard let profile = profile else { return }
        let newGoal = GoalCalculator.recommendedGoalML(
            weightKg: weight,
            heightCm: height,
            activity: activity
        )
        profile.goalML = Int32(newGoal)
        goalML = newGoal
        try? PersistenceController.shared.container.viewContext.save()
        syncToWidget() // hedef değiştiyse widget güncelle
    }

    // MARK: - Widget Sync
    func syncToWidget() {
        // ⚙️ App Group ID: Onlock.WaterQualityApp
        let defaults = UserDefaults(suiteName: "group.Onlock.WaterQualityApp")
        defaults?.set(todayML, forKey: "todayML")
        defaults?.set(goalML, forKey: "goalML")

        WidgetCenter.shared.reloadAllTimelines()
    }


    // MARK: - Widget Display Text
    func todayProgressText() -> String {
        "\(Int(progressPercent() * 100))% — \(todayML) ml"
    }
}
