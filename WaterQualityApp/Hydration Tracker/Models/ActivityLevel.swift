//
//  ActivityLevel.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 27.10.2025.
//


import Foundation

enum ActivityLevel: Int, CaseIterable, Identifiable {
    case low = 0, medium, high
    var id: Int { rawValue }
    var label: String {
        switch self {
        case .low: return "Düşük"
        case .medium: return "Orta"
        case .high: return "Yüksek"
        }
    }
    var multiplier: Double {
        switch self {
        case .low: return 30   // ml/kg
        case .medium: return 35
        case .high: return 40
        }
    }
}

struct GoalCalculator {
    static func recommendedGoalML(weightKg: Double, heightCm: Double, activity: ActivityLevel) -> Int {
        // Basit formül: ağırlık temelli + boy etkisi (çok hafif)
        let base = weightKg * activity.multiplier
        let heightAdj = max(0, (heightCm - 160) * 2) // 160 cm üzeri her cm için +2 ml
        return Int((base + heightAdj).rounded())
    }
}
