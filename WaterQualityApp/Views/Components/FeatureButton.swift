//
//  FeatureButton.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 24.10.2025.
//

import SwiftUI

struct FeatureButton<Destination: View>: View {
    let title: String
    let icon: String
    let color: Color
    let destination: Destination

    var body: some View {
        NavigationLink(destination: destination) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .padding()
                    .background(color.opacity(0.2))
                    .clipShape(Circle())
                    .foregroundColor(color)

                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(colors: [color.opacity(0.25), .clear],
                               startPoint: .top,
                               endPoint: .bottom)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: color.opacity(0.3), radius: 4, x: 0, y: 3)
        }
    }
}
