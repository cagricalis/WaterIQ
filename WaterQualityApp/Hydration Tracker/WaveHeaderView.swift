//
//  WaveHeaderView.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 28.10.2025.
//

import SwiftUI

struct WaveHeaderView: View {
    let title: String
    let goalML: Int
    let completedPercent: Double      // 0...1
    var subtitle: String?

    @State private var phase: CGFloat = 0

    var body: some View {
        ZStack(alignment: .topLeading) {
            // 🔹 Arka plan kartı
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [.hBlue.opacity(0.25), .hNavy.opacity(0.15)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    // 🔹 1. Dalga
                    WaveShape(phase: phase, amplitude: 12)
                        .fill(Color.hBlue.opacity(0.35))
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .offset(y: 24)
                )
                .overlay(
                    // 🔹 2. Dalga
                    WaveShape(phase: phase * 1.3 + CGFloat(40), amplitude: 8)
                        .fill(Color.white.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .offset(y: 36)
                )

            // 🔹 Başlık, metinler ve veriler
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                    .foregroundColor(.hNavy)

                HStack(spacing: 14) {
                    pill("Goal", "\(goalML) ml")
                    pill("Completed", "\(Int(completedPercent * 100))%")
                }

                if let subtitle {
                    Text("“\(subtitle)”")
                        .font(.footnote)
                        .foregroundColor(.hNavy.opacity(0.8))
                        .padding(.top, 4)
                }
            }
            .padding(20)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 150)
        .onAppear {
            // 🔹 Sürekli akan dalga animasyonu
            withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                phase = 360
            }
        }
    }

    // 🔹 Küçük bilgi kapsülleri (Goal, Completed)
    private func pill(_ title: String, _ value: String) -> some View {
        HStack(spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundColor(.hNavy.opacity(0.8))
            Text(value)
                .font(.caption.bold())
                .foregroundColor(.hNavy)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
    }
}
