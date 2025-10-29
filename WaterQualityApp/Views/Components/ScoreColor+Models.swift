//
//  ScoreColor+Models.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 24.10.2025.
//

import SwiftUI

extension WaterBrand {
    var qualityColor: Color {
        switch qualityScore {
        case ..<40:    return .red
        case 40..<70:  return .orange
        case 70..<85:  return .yellow
        default:       return .green
        }
    }
}

extension MineralWaterBrand {
    var qualityColor: Color {
        switch qualityScore {
        case ..<40:    return .red
        case 40..<70:  return .orange
        case 70..<85:  return .yellow
        default:       return .green
        }
    }
}
