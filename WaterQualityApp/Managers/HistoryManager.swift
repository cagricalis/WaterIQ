import Foundation
import SwiftUI

// MARK: - Kayıt Tipleri
struct WaterHistoryItem: Identifiable, Codable {
    let id: UUID
    let brand: WaterBrand
    let date: Date

    init(brand: WaterBrand, date: Date = Date()) {
        self.id = UUID()
        self.brand = brand
        self.date = date
    }
}

struct MineralHistoryItem: Identifiable, Codable {
    let id: UUID
    let brand: MineralWaterBrand
    let date: Date

    init(brand: MineralWaterBrand, date: Date = Date()) {
        self.id = UUID()
        self.brand = brand
        self.date = date
    }
}

// MARK: - Manager
final class HistoryManager: ObservableObject {
    @Published var waterHistory: [WaterHistoryItem] = [] {
        didSet { save() }
    }
    @Published var mineralHistory: [MineralHistoryItem] = [] {
        didSet { save() }
    }

    private let waterKey = "WaterIQ_History_Water"
    private let mineralKey = "WaterIQ_History_Mineral"

    init() {
        load()
    }

    var isEmpty: Bool {
        waterHistory.isEmpty && mineralHistory.isEmpty
    }

    // En üste ekler; aynı markayı tekrar eklerse eski kaydı kaldırıp günceli üste alır
    func addWater(_ brand: WaterBrand) {
        waterHistory.removeAll { $0.brand.name == brand.name }
        waterHistory.insert(WaterHistoryItem(brand: brand), at: 0)
    }

    func addMineral(_ brand: MineralWaterBrand) {
        mineralHistory.removeAll { $0.brand.name == brand.name }
        mineralHistory.insert(MineralHistoryItem(brand: brand), at: 0)
    }

    func clearAll() {
        waterHistory.removeAll()
        mineralHistory.removeAll()
    }

    // MARK: - Persistence
    private func save() {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        if let waterData = try? encoder.encode(waterHistory) {
            UserDefaults.standard.set(waterData, forKey: waterKey)
        }
        if let mineralData = try? encoder.encode(mineralHistory) {
            UserDefaults.standard.set(mineralData, forKey: mineralKey)
        }
    }

    private func load() {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        if let data = UserDefaults.standard.data(forKey: waterKey),
           let decoded = try? decoder.decode([WaterHistoryItem].self, from: data) {
            waterHistory = decoded
        }

        if let data = UserDefaults.standard.data(forKey: mineralKey),
           let decoded = try? decoder.decode([MineralHistoryItem].self, from: data) {
            mineralHistory = decoded
        }
    }
}
