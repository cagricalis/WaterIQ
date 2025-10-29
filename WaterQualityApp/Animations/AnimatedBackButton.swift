//
//  AnimatedBackButton.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 27.10.2025.
//


import SwiftUI

struct AnimatedBackButton: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isPressed = false

    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                isPressed.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                dismiss()
            }
        }) {
            Image(systemName: "chevron.left.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: isPressed ? 28 : 32, height: isPressed ? 28 : 32)
                .foregroundColor(.white)
                .shadow(color: .blue.opacity(0.4), radius: 5, y: 2)
        }
        .buttonStyle(.plain)
    }
}
