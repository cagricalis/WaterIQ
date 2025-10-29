//
//  WaterBottleShape.swift
//  WaterQualityApp
//
//  Çizgisel bir şişe şekli: gövde + boyun + hafif omuzlar
//

import SwiftUI

struct WaterBottleShape: Shape {
    func path(in rect: CGRect) -> Path {
        // İç boşluk
        let inset: CGFloat = rect.width * 0.06
        let r = rect.insetBy(dx: inset, dy: inset)

        // Boyut oranları
        let neckWidth = r.width * 0.35
        let neckHeight = r.height * 0.16
        let shoulderHeight = r.height * 0.10
        let bodyTopY = r.minY + neckHeight + shoulderHeight
        let bodyBottomY = r.maxY
        let bodyRadius: CGFloat = r.width * 0.16

        var p = Path()

        // Boyun (üst dar kısım)
        let neckLeftX  = r.midX - neckWidth/2
        let neckRightX = r.midX + neckWidth/2
        let neckTopY   = r.minY
        let neckBotY   = r.minY + neckHeight

        // Üst kapak (oval)
        p.addRoundedRect(in: CGRect(x: neckLeftX,
                                    y: neckTopY,
                                    width: neckWidth,
                                    height: neckHeight*0.45),
                         cornerSize: CGSize(width: neckWidth*0.15, height: neckWidth*0.15))

        // Boyun dikey
        p.move(to: CGPoint(x: neckLeftX, y: neckTopY + neckHeight*0.45))
        p.addLine(to: CGPoint(x: neckLeftX, y: neckBotY))
        p.move(to: CGPoint(x: neckRightX, y: neckTopY + neckHeight*0.45))
        p.addLine(to: CGPoint(x: neckRightX, y: neckBotY))

        // Omuzlar (boyundan gövdeye yumuşak geçiş)
        let shoulderLeftStart  = CGPoint(x: neckLeftX,  y: neckBotY)
        let shoulderRightStart = CGPoint(x: neckRightX, y: neckBotY)
        let shoulderLeftEnd    = CGPoint(x: r.minX + bodyRadius,  y: bodyTopY)
        let shoulderRightEnd   = CGPoint(x: r.maxX - bodyRadius,  y: bodyTopY)

        p.move(to: shoulderLeftStart)
        p.addQuadCurve(to: shoulderLeftEnd,
                       control: CGPoint(x: r.minX + r.width*0.25, y: neckBotY + shoulderHeight*0.4))

        p.move(to: shoulderRightStart)
        p.addQuadCurve(to: shoulderRightEnd,
                       control: CGPoint(x: r.maxX - r.width*0.25, y: neckBotY + shoulderHeight*0.4))

        // Gövde (yuvarlatılmış köşeli dikdörtgen)
        let bodyRect = CGRect(x: r.minX,
                              y: bodyTopY,
                              width: r.width,
                              height: bodyBottomY - bodyTopY)
        p.addRoundedRect(in: bodyRect, cornerSize: CGSize(width: bodyRadius, height: bodyRadius))

        return p
    }
}
