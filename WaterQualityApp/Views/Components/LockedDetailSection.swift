//
//  LockedDetailSection.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 27.10.2025.
//


import SwiftUI

struct LockedDetailSection: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "lock.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80)
                .foregroundColor(.gray)
            Text("Bu analizler sadece Premium kullanıcılar için mevcut 🔒")
                .font(.headline)
                .foregroundColor(.secondary)
            NavigationLink(destination: PaywallView()) {
                Text("Premium’a Geç")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal, 40)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .padding()
    }
}
