//
//  HealthKitManager.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 27.10.2025.
//


import HealthKit

final class HealthKitManager {
    static let shared = HealthKitManager()
    private let healthStore = HKHealthStore()
    private let waterType = HKObjectType.quantityType(forIdentifier: .dietaryWater)!

    func requestAuthorization() async throws {
        try await healthStore.requestAuthorization(toShare: [waterType], read: [waterType])
    }

    func saveWaterIntake(ml: Int, at date: Date = Date()) async throws {
        let quantity = HKQuantity(unit: .literUnit(with: .milli), doubleValue: Double(ml))
        let sample = HKQuantitySample(type: waterType, quantity: quantity, start: date, end: date)
        try await healthStore.save(sample)
    }

    func fetchTodayTotalML() async throws -> Int {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: Date())
        let pred = HKQuery.predicateForSamples(withStart: start, end: Date(), options: .strictStartDate)
        return try await withCheckedThrowingContinuation { cont in
            let statsQuery = HKStatisticsQuery(quantityType: waterType,
                                               quantitySamplePredicate: pred,
                                               options: .cumulativeSum) { _, stats, error in
                if let error = error { return cont.resume(throwing: error) }
                let sum = stats?.sumQuantity()?.doubleValue(for: .literUnit(with: .milli)) ?? 0
                cont.resume(returning: Int(sum))
            }
            healthStore.execute(statsQuery)
        }
    }
}
