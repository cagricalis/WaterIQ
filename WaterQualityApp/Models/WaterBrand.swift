//
//  WaterBrand.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 10.10.2025.
//

import Foundation
import SwiftUI
import Foundation
import FirebaseFirestoreSwift


struct WaterBrand: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    let name: String
    let imageName: String
    let qualityScore: Int
    let ph: Double?
    let hardness: Int?
    let minerals: String?
    let description: String?
    let barcode: String

    var qualityColor: Color {
        switch qualityScore {
        case 0...49: return .red
        case 50...79: return .yellow
        case 80...100: return .green
        default: return .gray
        }
    }
}
