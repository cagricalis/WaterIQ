//
//  VerificationSuccessView.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 27.10.2025.
//


import SwiftUI

struct VerificationSuccessView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)
                .shadow(radius: 8)
                .transition(.scale)

            Text("Hesabın başarıyla doğrulandı 🎉")
                .font(.title3.bold())
                .foregroundColor(.white)

            Text("Artık WaterIQ’nun tüm özelliklerini kullanabilirsin 💧")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}
