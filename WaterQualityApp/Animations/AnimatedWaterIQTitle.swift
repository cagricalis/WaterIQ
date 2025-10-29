//
//  AnimatedWaterIQTitle.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 27.10.2025.
//


import SwiftUI

struct AnimatedWaterIQTitle: View {
    @State private var animateGradient = false

    var body: some View {
        HStack(spacing: 0) {
            Text("Water")
                .font(.system(size: 44, weight: .bold))
                .foregroundColor(.white)

            Text("IQ")
                .font(.system(size: 44, weight: .bold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.cyan, .blue, .teal],
                        startPoint: animateGradient ? .topLeading : .bottomTrailing,
                        endPoint: animateGradient ? .bottomTrailing : .topLeading
                    )
                )
                .onAppear {
                    withAnimation(.linear(duration: 2.5).repeatForever(autoreverses: true)) {
                        animateGradient.toggle()
                    }
                }
        }
        .shadow(color: .white.opacity(0.4), radius: 6, y: 3)
    }
}
