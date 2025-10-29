//
//  MineralWaterCard.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 24.10.2025.
//

import SwiftUI

struct MineralWaterCard: View {
    let brand: MineralWaterBrand
    @EnvironmentObject var session: UserSession

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(brand.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 140, height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 16))

            Text(brand.name)
                .font(.headline)
                .foregroundColor(.white)

            if session.isPremium {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: 120, height: 6)
                        .foregroundColor(Color.white.opacity(0.2))
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: CGFloat(brand.qualityScore) * 1.2, height: 6)
                        .foregroundColor(brand.qualityColor)
                }
                Text("\(brand.qualityScore)/100")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            } else {
                Text("Puan gizli 🔒")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .frame(width: 150)
        .padding(8)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(radius: 4)
    }
}
