//
//  SuccessSplashView.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 28.10.2025.
//


import SwiftUI

/// Giriş başarı ekranı: su damlası + dalga dolumu + check animasyonu
struct SuccessSplashView: View {
    /// Animasyon bittikten sonra tetiklenir (ör. ana ekrana geçmek için)
    let onFinish: () -> Void

    @State private var progress: CGFloat = 0.0
    @State private var showCheck = false
    @State private var fadeOut = false

    var body: some View {
        ZStack {
            // Arka plan
            LinearGradient(colors: [Color(hex: "#0A3D62"), Color(hex: "#1A73E8")],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            // Su damlası kapsülü
            ZStack {
                // Dış damla
                DropShape()
                    .stroke(.white.opacity(0.25), lineWidth: 6)
                    .frame(width: 180, height: 220)

                // İçte yükselen dalga dolumu
                DropShape()
                    .fill(
                        LinearGradient(colors: [Color.cyan, Color.teal],
                                       startPoint: .bottom, endPoint: .top)
                    )
                    .mask {
                        WaveFill(progress: progress)
                            .frame(width: 180, height: 220)
                    }
                    .overlay(
                        WaveLine(amplitude: 8, progress: progress)
                            .stroke(Color.white.opacity(0.6), lineWidth: 1.5)
                            .frame(width: 160, height: 200)
                            .offset(y: 8)
                            .blendMode(.screen)
                    )

                // Onay işareti (gecikmeli)
                if showCheck {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 84, height: 84)
                        .foregroundStyle(.white)
                        .shadow(color: .white.opacity(0.6), radius: 10)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .shadow(color: .black.opacity(0.25), radius: 20, y: 8)

            // Alttaki metin
            VStack {
                Spacer()
                Text(showCheck ? "Hoş geldin!" : "Giriş yapılıyor…")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.95))
                    .padding(.bottom, 40)
            }
            .padding(.horizontal)
        }
        .opacity(fadeOut ? 0 : 1)
        .onAppear {
            // 1) Dalga dolum animasyonu
            withAnimation(.easeInOut(duration: 1.2)) {
                progress = 1.0
            }
            // 2) Check işareti
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.95) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    showCheck = true
                }
            }
            // 3) Fade out + tamamla callback
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                withAnimation(.easeInOut(duration: 0.25)) {
                    fadeOut = true
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.9) {
                onFinish()
            }
        }
    }
}

// MARK: - Su damlası şekli
fileprivate struct DropShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        p.move(to: CGPoint(x: w/2, y: 0))
        p.addQuadCurve(to: CGPoint(x: w, y: h * 0.55),
                       control: CGPoint(x: w, y: h * 0.2))
        p.addQuadCurve(to: CGPoint(x: w/2, y: h),
                       control: CGPoint(x: w, y: h * 0.85))
        p.addQuadCurve(to: CGPoint(x: 0, y: h * 0.55),
                       control: CGPoint(x: 0, y: h * 0.85))
        p.addQuadCurve(to: CGPoint(x: w/2, y: 0),
                       control: CGPoint(x: 0, y: h * 0.2))
        p.closeSubpath()
        return p
    }
}

// MARK: - Dalga dolumu maskesi
fileprivate struct WaveFill: View {
    let progress: CGFloat // 0..1
    @State private var phase: Angle = .degrees(0)

    var body: some View {
        GeometryReader { geo in
            let height = geo.size.height
            let fillHeight = height * progress
            ZStack(alignment: .bottom) {
                // dolu kısım
                Rectangle()
                    .fill(.white.opacity(0.001))
                    .frame(height: height) // maske boyu sabit; alt kısımda wave çizilecek

                // Dalga
                WavePath(phase: phase, amplitude: 10)
                    .fill(Color.white)
                    .frame(height: fillHeight)
                    .offset(y: height - fillHeight)
                    .onAppear {
                        withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                            phase = .degrees(360)
                        }
                    }
            }
        }
    }
}

// MARK: - Dalga çizgisi (overlay)
fileprivate struct WaveLine: Shape {
    var amplitude: CGFloat
    var progress: CGFloat // 0..1
    var animatableData: CGFloat {
        get { progress }
        set { }
    }
    func path(in rect: CGRect) -> Path {
        let h = rect.height * progress
        var p = Path()
        let midY = rect.maxY - h + 8
        let waveLen = rect.width / 1.2
        let amp = amplitude

        p.move(to: CGPoint(x: 0, y: midY))
        var x: CGFloat = 0
        while x <= rect.width {
            let relative = x / waveLen * .pi * 2
            let y = midY + sin(relative) * amp
            p.addLine(to: CGPoint(x: x, y: y))
            x += 2
        }
        return p
    }
}

// MARK: - Dalga maskesi için dolgu
fileprivate struct WavePath: Shape {
    var phase: Angle
    var amplitude: CGFloat

    var animatableData: Double {
        get { phase.degrees }
        set { phase = .degrees(newValue) }
    }

    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        let midY = h * 0.5
        p.move(to: CGPoint(x: 0, y: midY))
        var x: CGFloat = 0
        while x <= w {
            let relative = x / w
            let y = midY + CGFloat(sin((relative * 2 * .pi) + phase.radians)) * amplitude
            p.addLine(to: CGPoint(x: x, y: y))
            x += 2
        }
        p.addLine(to: CGPoint(x: w, y: h))
        p.addLine(to: CGPoint(x: 0, y: h))
        p.closeSubpath()
        return p
    }
}

