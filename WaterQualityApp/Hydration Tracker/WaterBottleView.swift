//
//  WaterBottleView.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 28.10.2025.
//


//
//  WaterBottleView.swift
//  WaterQualityApp
//
//  Cam şişe, animasyonlu dalga ve baloncuk katmanları.
//

import SwiftUI

struct WaterBottleView: View {
    /// 0...1 arası doluluk
    var level: CGFloat
    var height: CGFloat = 240

    @State private var phase1: CGFloat = 0
    @State private var phase2: CGFloat = 90
    @State private var bubbleTick: CGFloat = 0

    var body: some View {
        let clamped = min(max(level, 0), 1)

        return ZStack {
            // Şişe gövdesi
            WaterBottleShape()
                .fill(Color.white.opacity(0.10))

            // İç gölge/kenar
            WaterBottleShape()
                .stroke(Color.white.opacity(0.35), lineWidth: 1.2)

            // Dalgalar (arka)
            GeometryReader { geo in
                let rect = geo.frame(in: .local)
                WaterFillWaveShape(fillLevel: clamped, phase: phase1, amplitude: rect.height * 0.015)
                    .fill(LinearGradient(colors: [Color.blue.opacity(0.35), Color.cyan.opacity(0.35)],
                                         startPoint: .top, endPoint: .bottom))
                    .clipShape(WaterBottleShape())
            }

            // Dalgalar (ön)
            GeometryReader { geo in
                let rect = geo.frame(in: .local)
                WaterFillWaveShape(fillLevel: clamped, phase: phase2, amplitude: rect.height * 0.02)
                    .fill(LinearGradient(colors: [Color.cyan.opacity(0.45), Color.blue.opacity(0.45)],
                                         startPoint: .top, endPoint: .bottom))
                    .clipShape(WaterBottleShape())
                    .opacity(0.95)
            }

            // Baloncuklar
            BubbleLayer(level: clamped, tick: bubbleTick)
                .clipShape(WaterBottleShape())

            // Cam parlaklığı (highlight)
            WaterBottleShape()
                .stroke(Color.white.opacity(0.18), lineWidth: 6)
                .blur(radius: 6)
                .offset(x: -2, y: -2)
                .mask(
                    LinearGradient(colors: [Color.white.opacity(0.9), .clear],
                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .allowsHitTesting(false)
        }
        .frame(width: height * 0.42, height: height)
        .onAppear {
            withAnimation(.linear(duration: 3.0).repeatForever(autoreverses: false)) {
                phase1 = 360
            }
            withAnimation(.linear(duration: 2.2).repeatForever(autoreverses: false)) {
                phase2 = 360 + 90
            }
            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                bubbleTick = 1
            }
        }
    }
}

// MARK: - Küçük baloncuk katmanı
private struct BubbleLayer: View {
    var level: CGFloat   // 0..1
    var tick: CGFloat    // 0..1 arası animasyon işaretçisi

    var body: some View {
        GeometryReader { geo in
            let r = geo.frame(in: .local)
            let baseY = r.maxY - level * r.height

            ZStack {
                // 6 baloncuk: farklı hız/konum
                ForEach(0..<6, id: \.self) { i in
                    let x = r.minX + CGFloat.random(in: r.width*0.25...r.width*0.75)
                    // Baloncuk, su yüzeyinin altından doğsun:
                    let startY = r.maxY - CGFloat.random(in: 0...(r.height * level * 0.9))
                    let endY   = baseY - CGFloat.random(in: 10...40)
                    let progress = (tick + CGFloat(i) * 0.15).truncatingRemainder(dividingBy: 1)

                    Circle()
                        .fill(Color.white.opacity(0.35))
                        .frame(width: CGFloat.random(in: 3...6), height: CGFloat.random(in: 3...6))
                        .position(x: x,
                                  y: startY - (startY - endY) * progress)
                        .opacity(Double(0.2 + 0.8 * (1 - progress)))
                }
            }
        }
    }
}
