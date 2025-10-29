import FirebaseFirestore
import Foundation

final class NetworkManager: ObservableObject {
    @Published var waterBrands: [WaterBrand] = []
    @Published var mineralWaterBrands: [MineralWaterBrand] = []
    private let db = Firestore.firestore()

    func fetchLocalWaterBrands() {
        db.collection("waterBrands").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else { return }
            self.waterBrands = documents.compactMap { try? $0.data(as: WaterBrand.self) }
        }
    }

    func fetchMineralWaterBrands() {
        db.collection("mineralWaterBrands").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else { return }
            self.mineralWaterBrands = documents.compactMap { try? $0.data(as: MineralWaterBrand.self) }
        }
    }
}
