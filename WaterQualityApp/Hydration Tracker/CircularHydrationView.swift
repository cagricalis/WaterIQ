//  CircularHydrationView.swift
//  WaterQualityApp

import SwiftUI

struct CircularHydrationView: View {
    let progress: Double        // 0...1
    let today: Int
    let goal: Int

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 18)
                .foregroundColor(.hBlue.opacity(0.25))
                .frame(width: 200, height: 200)

            Circle()
                .trim(from: 0, to: min(progress, 1))
                .stroke(style: StrokeStyle(lineWidth: 18, lineCap: .round))
                .foregroundColor(.hNavy)
                .frame(width: 200, height: 200)
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: progress)

            VStack(spacing: 6) {
                Text("\(today) / \(goal) ml")
                    .font(.headline)
                    .foregroundColor(.hNavy)
                Text("\(Int(min(progress,1)*100))%")
                    .font(.title3.bold())
                    .foregroundColor(.hNavy)
            }
        }
        .padding(.vertical, 8)
    }
}
