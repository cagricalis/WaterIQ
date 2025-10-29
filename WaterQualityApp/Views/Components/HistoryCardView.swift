
//
//  HistoryCardView.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 27.10.2025.
//

import SwiftUI

public struct HistoryCardView: View {
    public let image: String
    public let name: String
    public let score: Int
    public let color: Color
    public let type: String
    public let date: Date

    public init(image: String, name: String, score: Int, color: Color, type: String, date: Date) {
        self.image = image
        self.name = name
        self.score = score
        self.color = color
        self.type = type
        self.date = date
    }

    public var body: some View {
        HStack(spacing: 14) {
            Image(image)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 2)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(name)
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    Text(type)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }

                Text(formattedDate(date))
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.7))

                // Skor + bar
                HStack {
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 120, height: 6)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(color)
                            .frame(width: CGFloat(score), height: 6)
                    }
                    Text("\(score)/100")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.9))
                }
            }
            Spacer()
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(radius: 3)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
        )
    }

    private func formattedDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        return f.string(from: date)
    }
}
