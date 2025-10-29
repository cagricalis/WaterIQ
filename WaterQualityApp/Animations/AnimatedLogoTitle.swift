//
//  AnimatedLogoTitle.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 28.10.2025.
//

import SwiftUI

struct AnimatedLogoTitle: View {
    var scale: CGFloat

    var body: some View {
        HStack(spacing: 0) {
            // 🔹 "Water" kısmı: beyaz, clean
            Text("water")
                .foregroundColor(.white)
                .font(.custom("Inter-SemiBold", size: 44 * scale))
                .fontWeight(.semibold)
                .tracking(-0.5)

            // 🔹 "IQ" kısmı: kurumsal lacivert (#1A4385)
            Text("IQ")
                .foregroundColor(Color(hex: "#1A4385"))
                .font(.custom("Inter-ExtraBold", size: 44 * scale))
                .tracking(-1)
        }
        .shadow(color: Color.white.opacity(0.25), radius: 3, y: 1)
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: scale)
        .accessibilityLabel("Water IQ Logo")
    }
}


