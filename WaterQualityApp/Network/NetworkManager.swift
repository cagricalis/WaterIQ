//
//  NetworkManager.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 10.10.2025.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class NetworkManager: ObservableObject {
    @Published var waterBrands: [WaterBrand] = []
    private let db = Firestore.firestore()

    func fetchLocalWaterBrands() {
        db.collection("waterBrands").getDocuments { snapshot, error in
            if let error = error {
                print("❌ Firestore error: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("⚠️ No documents found")
                return
            }

            DispatchQueue.main.async {
                self.waterBrands = documents.compactMap { doc in
                    try? doc.data(as: WaterBrand.self)
                }
            }
        }
    }
}
