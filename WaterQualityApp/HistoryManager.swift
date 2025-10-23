import SwiftUI

class HistoryManager: ObservableObject {
    @Published var historyList: [WaterBrand] = []

    func add(_ brand: WaterBrand) {
        if let index = historyList.firstIndex(where: { $0.id == brand.id }) {
            historyList.remove(at: index)
        }
        historyList.append(brand)
    }
}
