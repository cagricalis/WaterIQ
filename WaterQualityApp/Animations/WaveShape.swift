//
//  WaveShape.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 28.10.2025.
//


//  WaveShape.swift
//  WaterQualityApp
//
//  Ortak animasyonlu dalga formu
//

import SwiftUI

struct WaveShape: Shape {
    var phase: CGFloat
    var amplitude: CGFloat

    var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let midHeight = rect.height * 0.5

        path.move(to: CGPoint(x: 0, y: midHeight))

        for x in stride(from: 0, through: width, by: 1) {
            let relativeX = x / width
            let angle = (relativeX * 360 + phase) * .pi / 180
            let y = midHeight + sin(angle) * amplitude
            path.addLine(to: CGPoint(x: x, y: y))
        }

        path.addLine(to: CGPoint(x: width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()

        return path
    }
}
