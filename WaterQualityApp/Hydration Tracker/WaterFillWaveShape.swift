//
//  WaterFillWaveShape.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 28.10.2025.
//


//
//  WaterFillWaveShape.swift
//  WaterQualityApp
//
//  Sine dalgası ile doldurma şekli (animatable phase).
//

import SwiftUI

struct WaterFillWaveShape: Shape {
    var fillLevel: CGFloat   // 0...1 (0 boş, 1 dolu)
    var phase: CGFloat       // dalga fazı (derece ya da rad değil—biz dereceden çevireceğiz)
    var amplitude: CGFloat   // dalga yüksekliği

    var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }

    func path(in rect: CGRect) -> Path {
        // Seviye clamp
        let level = min(max(fillLevel, 0), 1)

        // Dolum yüksekliği: alttan yukarıya
        let waterTopY = rect.maxY - level * rect.height

        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: waterTopY))

        let twoPi = CGFloat.pi * 2
        // Fazı rad (0..2π) gibi düşünelim:
        let basePhase = phase * CGFloat.pi / 180

        // Dalga çizimi
        let step: CGFloat = max(1, rect.width / 120) // kalite/perf dengesi
        for x in stride(from: rect.minX, through: rect.maxX, by: step) {
            let progress = (x - rect.minX) / rect.width
            let y = waterTopY + sin(progress * twoPi + basePhase) * amplitude
            path.addLine(to: CGPoint(x: x, y: y))
        }

        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
