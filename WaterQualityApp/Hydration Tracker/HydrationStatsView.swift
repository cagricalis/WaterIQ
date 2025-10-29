//
//  HydrationStatsView.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 29.10.2025.
//

import SwiftUI
import Charts

struct HydrationStatsView: View {
    @ObservedObject var viewModel: HydrationViewModel
    @State private var selectedDay: (date: Date, ml: Int)?

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.hBackground, Color.hSoftBlue],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    // MARK: - Header
                    WaveHeaderView(
                        title: "Haftalık Su Analizi",
                        goalML: viewModel.goalML,
                        completedPercent: viewModel.progressPercent(),
                        subtitle: summaryText()
                    )
                    .padding(.horizontal)

                    // MARK: - Progress Ring
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .stroke(lineWidth: 12)
                                .foregroundColor(Color.white.opacity(0.2))
                                .frame(width: 130, height: 130)
                            Circle()
                                .trim(from: 0, to: viewModel.progressPercent())
                                .stroke(
                                    LinearGradient(colors: [Color.hTeal, Color.hBlue],
                                                   startPoint: .bottom,
                                                   endPoint: .top),
                                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                                )
                                .rotationEffect(.degrees(-90))
                                .frame(width: 130, height: 130)
                                .animation(.easeInOut(duration: 1.2),
                                           value: viewModel.progressPercent())

                            VStack(spacing: 4) {
                                Text("\(Int(viewModel.progressPercent() * 100))%")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(Color.hNavy)
                                Text("Hedef Tamamlandı")
                                    .font(.caption)
                                    .foregroundColor(Color.hNavy.opacity(0.7))
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)

                    // MARK: - Trend Chart
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Son 7 Günlük Trend")
                            .font(.headline)
                            .foregroundColor(Color.hNavy)
                            .padding(.horizontal, 8)

                        ZStack {
                            Chart {
                                // Günlük sütunlar
                                ForEach(viewModel.weeklyData, id: \.0) { (date, ml) in
                                    BarMark(
                                        x: .value("Tarih", date, unit: .day),
                                        y: .value("Miktar", ml)
                                    )
                                    .foregroundStyle(
                                        LinearGradient(colors: [Color.hBlue, Color.hTeal],
                                                       startPoint: .bottom,
                                                       endPoint: .top)
                                    )
                                    .cornerRadius(6)
                                    .opacity(selectedDay?.date == date ? 1 : 0.85)
                                }

                                // Ortalama çizgi (trend)
                                let average = averageML()
                                RuleMark(y: .value("Ortalama", average))
                                    .foregroundStyle(Color.hNavy.opacity(0.3))
                                    .lineStyle(StrokeStyle(lineWidth: 2, dash: [4]))
                                    .annotation(position: .top, alignment: .leading) {
                                        Text("Ortalama: \(average) ml")
                                            .font(.caption2)
                                            .foregroundColor(Color.hNavy)
                                            .padding(4)
                                            .background(Color.white.opacity(0.6))
                                            .cornerRadius(6)
                                    }

                                // Trend çizgisi
                                ForEach(viewModel.weeklyData.indices, id: \.self) { i in
                                    if i > 0 {
                                        let prev = viewModel.weeklyData[i - 1]
                                        let curr = viewModel.weeklyData[i]
                                        LineMark(
                                            x: .value("Tarih", curr.0, unit: .day),
                                            y: .value("Trend", (prev.1 + curr.1) / 2)
                                        )
                                        .foregroundStyle(
                                            LinearGradient(colors: [Color.hTeal, Color.hBlue],
                                                           startPoint: .leading,
                                                           endPoint: .trailing)
                                        )
                                        .interpolationMethod(.catmullRom)
                                        .lineStyle(StrokeStyle(lineWidth: 3))
                                    }
                                }
                            }
                            .chartXAxis {
                                AxisMarks(values: .stride(by: .day)) { value in
                                    AxisValueLabel(format: .dateTime.weekday(.narrow))
                                        .foregroundStyle(Color.hNavy)
                                }
                            }
                            .frame(height: 250)
                            .padding(.horizontal, 8)
                            .padding(.bottom, 10)

                            // 🔹 Tap detection overlay (Chart’ta onTapGesture yerine)
                            Rectangle()
                                .fill(Color.clear)
                                .contentShape(Rectangle())
                                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onEnded { _ in
                                            // Rastgele tıklama örneği
                                            if let randomDay = viewModel.weeklyData.randomElement() {
                                                withAnimation(.easeInOut) {
                                                    selectedDay = randomDay
                                                }
                                            }
                                        }
                                )
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .shadow(color: .black.opacity(0.1), radius: 5, y: 3)

                    // MARK: - Weekly Summary
                    VStack(spacing: 20) {
                        HStack {
                            statCard(title: "Toplam", value: "\(totalML()) ml",
                                     icon: "drop.fill", color: Color.hBlue)
                            statCard(title: "Ortalama", value: "\(averageML()) ml",
                                     icon: "chart.bar.fill", color: Color.hTeal)
                        }

                        HStack {
                            statCard(title: "En İyi Gün", value: bestDayText(),
                                     icon: "star.fill", color: .yellow)
                            statCard(title: "Hedef", value: "\(viewModel.goalML) ml",
                                     icon: "target", color: Color.hNavy)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 20)
                .padding(.bottom, 60)
            }
        }
    }

    // MARK: - Helper Methods
    private func totalML() -> Int {
        viewModel.weeklyData.map(\.1).reduce(0, +)
    }

    private func averageML() -> Int {
        let total = totalML()
        return viewModel.weeklyData.isEmpty ? 0 : total / viewModel.weeklyData.count
    }

    private func bestDayText() -> String {
        guard let best = viewModel.weeklyData.max(by: { $0.1 < $1.1 }) else { return "-" }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "E"
        return formatter.string(from: best.0)
    }

    private func summaryText() -> String {
        let avg = averageML()
        switch avg {
        case 0..<1000: return "Daha fazla su içmelisin 💧"
        case 1000..<2000: return "İyi gidiyorsun 👏"
        case 2000..<3000: return "Mükemmel denge 🚀"
        default: return "Süper hidrasyon 💙"
        }
    }

    // MARK: - Stat Card
    private func statCard(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            Text(title)
                .font(.caption)
                .foregroundColor(Color.hNavy.opacity(0.7))
            Text(value)
                .font(.headline)
                .foregroundColor(Color.hNavy)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 3, y: 2)
    }
}
