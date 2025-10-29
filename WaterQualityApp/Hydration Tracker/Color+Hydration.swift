//
//  Color+Hydration.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 29.10.2025.
//

import SwiftUI

extension Color {
    // MARK: - Tema Renkleri
    static let hBlue = Color(hex: "#4CC9F0")         // Ana açık mavi
    static let hTeal = Color(hex: "#00B4D8")         // Turkuaz
    static let hNavy = Color(hex: "#1A4385")         // Koyu lacivert
    static let hSoftBlue = Color(hex: "#CAF0F8")     // Açık pastel mavi
    static let hBackground = Color(hex: "#E9F5FF")   // Arka plan rengi

    // MARK: - HEX Dönüştürücü (Çakışmasız)
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}
