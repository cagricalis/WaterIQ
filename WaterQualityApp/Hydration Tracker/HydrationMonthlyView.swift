//
//  HydrationMonthlyView.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 29.10.2025.
//

import SwiftUI
import Charts

struct HydrationMonthlyView: View {
    @ObservedObject var viewModel: HydrationViewModel
    @State private var monthData: [(date: Date, ml: Int)] = []

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.hBackground, Color.hSoftBlue],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 30) {
                    // MARK: - Üst Bilgi Kartı
                    WaveHeaderView(
                        title: "Aylık Su Takibi",
                        goalML: viewModel.goalML,
                        completedPercent: viewModel.progressPercent(),
                        subtitle: "Son 30 Günlük Eğilim"
                    )
                    .padding(.horizontal)

                    // MARK: - Chart Alanı
                    VStack(alignment: .leading, spacing: 16) {
                        Text("30 Günlük Trend")
                            .font(.headline)
                            .foregroundColor(Color.hNavy)
                            .padding(.horizontal, 8)

                        Chart(monthData, id: \.date) { item in
                            AreaMark(
                                x: .value("Tarih", item.date),
                                y: .value("Tüketim (ml)", item.ml)
                            )
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.hBlue.opacity(0.4), .clear],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .interpolationMethod(.catmullRom)

                            LineMark(
                                x: .value("Tarih", item.date),
                                y: .value("Tüketim (ml)", item.ml)
                            )
                            .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                            .foregroundStyle(
                                LinearGradient(colors: [Color.hTeal, Color.hBlue],
                                               startPoint: .leading,
                                               endPoint: .trailing)
                            )
                            .symbol(Circle()) // ✅ Düzeltildi
                            .symbolSize(20)
                        }
                        .chartXAxis {
                            AxisMarks(values: .stride(by: .day, count: 5)) { value in
                                 AxisValueLabel(format: .dateTime.day().month(.abbreviated))
                                    .font(.caption2)
                                    .foregroundStyle(Color.hNavy.opacity(0.8))
                            }
                        }
                        .chartYAxis {
                            AxisMarks { value in
                                AxisValueLabel {
                                    if let val = value.as(Int.self) {
                                        Text("\(val) ml")
                                            .font(.caption2)
                                            .foregroundColor(Color.hNavy.opacity(0.8))
                                    }
                                }
                            }
                        }
                        .frame(height: 280)
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.ultraThinMaterial)
                                .shadow(color: .black.opacity(0.05), radius: 5, y: 3)
                        )
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 20)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            loadMonthlyData()
        }
    }

    // MARK: - Fake Monthly Data (Demo için)
    private func loadMonthlyData() {
        monthData = (0..<30).map { day in
            let date = Calendar.current.date(byAdding: .day, value: -day, to: Date())!
            let ml = Int.random(in: 1000...3000)
            return (date, ml)
        }.reversed()
    }
}
