

//
//  LockedFeatureButton.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 26.10.2025.
//

import SwiftUI

struct LockedFeatureButton: View {
    let title: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "lock.fill")
                .font(.largeTitle)
                .foregroundColor(.gray)
                .padding()
                .background(Color.white.opacity(0.2))
                .clipShape(Circle())

            Text(title)
                .foregroundColor(.white.opacity(0.8))
                .font(.headline)

            Text("Premium gerekli 🔒")
                .font(.caption)
                .foregroundColor(.yellow)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(radius: 4)
    }
}
