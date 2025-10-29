//
//  WaterCardView.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 23.10.2025.
//


import SwiftUI

struct WaterCardView: View {
    let brand: WaterBrand

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(brand.imageName)
                .resizable()
                .frame(width: 120, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            Text(brand.name)
                .font(.headline)
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 120, height: 8)
                    .foregroundColor(Color.gray.opacity(0.3))
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: CGFloat(brand.qualityScore) * 1.2, height: 8)
                    .foregroundColor(brand.qualityColor)
                Text("\(brand.qualityScore)/100")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .frame(width: 120, alignment: .center)
                    .offset(y: -14)
            }
        }
        .frame(width: 140)
        .padding(8)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}
