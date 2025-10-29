import SwiftUI

struct AnimatedBackground: View {
    @State private var wavePhase = Angle(degrees: 0)
    @State private var shimmer = false

    var body: some View {
        ZStack {
            // 🔹 Ana Klinik Mavi Arka Plan
            LinearGradient(
                colors: [
                    Color(red: 0.08, green: 0.22, blue: 0.55), // Derin mavi
                    Color(red: 0.11, green: 0.44, blue: 0.85), // Saf su mavisi
                    Color(red: 0.25, green: 0.78, blue: 1.0)   // Sağlık hissi veren açık ton
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // 🔹 Hafif Parlama Efekti (temiz klinik ışık)
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.25),
                            Color.clear
                        ]),
                        center: .center,
                        startRadius: shimmer ? 100 : 300,
                        endRadius: shimmer ? 600 : 900
                    )
                )
                .blur(radius: 80)
                .scaleEffect(shimmer ? 1.3 : 1.0)
                .animation(
                    Animation.easeInOut(duration: 8)
                        .repeatForever(autoreverses: true),
                    value: shimmer
                )

            // 🔹 Modern minimal dalga efekti
            WaveShape(phase: wavePhase.degrees, amplitude: 0.08)
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.25), Color.white.opacity(0.05)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: 220)
                .offset(y: 350)
                .blur(radius: 8)

            WaveShape(phase: wavePhase.degrees + 90, amplitude: 0.1)
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.2), Color.clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: 240)
                .offset(y: 360)
                .blur(radius: 10)

            // 🔹 Hafif üst yansıma çizgisi
            LinearGradient(
                colors: [
                    Color.white.opacity(0.15),
                    Color.clear,
                    Color.white.opacity(0.05)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .blendMode(.screen)
            .ignoresSafeArea()
        }
        .onAppear {
            withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
                wavePhase += Angle(degrees: 360)
            }
            shimmer.toggle()
        }
    }
}

