//
//  HydrationTrendView.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 29.10.2025.
//

import SwiftUI
import Charts

struct HydrationTrendView: View {
    @ObservedObject var viewModel: HydrationViewModel

    @State private var selectedRange: RangeType = .weekly
    @State private var chartData: [(date: Date, ml: Int)] = []

    enum RangeType: String, CaseIterable, Identifiable {
        case weekly = "7 Gün"
        case monthly = "30 Gün"
        var id: String { rawValue }
        var daySpan: Int { self == .weekly ? 7 : 30 }
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.hBackground, Color.hSoftBlue],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    // MARK: - Üst Bilgi Kartı
                    WaveHeaderView(
                        title: "Su Tüketim Trendi",
                        goalML: viewModel.goalML,
                        completedPercent: viewModel.progressPercent(),
                        subtitle: selectedRange == .weekly
                            ? "Son 7 Günlük İstatistik"
                            : "Son 30 Günlük Eğilim"
                    )
                    .padding(.horizontal)

                    // MARK: - Picker
                    Picker("Zaman Aralığı", selection: $selectedRange) {
                        ForEach(RangeType.allCases) { range in
                            Text(range.rawValue).tag(range)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .onChange(of: selectedRange) { _ in
                        loadChartData()
                    }

                    // MARK: - Chart
                    VStack(alignment: .leading, spacing: 16) {
                        Text("\(selectedRange.rawValue) Trend")
                            .font(.headline)
                            .foregroundColor(Color.hNavy)
                            .padding(.horizontal, 8)

                        Chart(chartData, id: \.date) { item in
                            AreaMark(
                                x: .value("Tarih", item.date),
                                y: .value("Tüketim (ml)", item.ml)
                            )
                            .foregroundStyle(
                                LinearGradient(colors: [Color.hBlue.opacity(0.3), .clear],
                                               startPoint: .top,
                                               endPoint: .bottom)
                            )

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
                            .symbol(Circle())
                            .symbolSize(20)
                        }
                        .chartXAxis {
                            AxisMarks(values: .stride(by: .day, count: selectedRange == .weekly ? 1 : 5)) { value in
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
                                .shadow(color: .black.opacity(0.08), radius: 6, y: 3)
                        )
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 20)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            loadChartData()
        }
    }

    // MARK: - Chart Data Loader
    private func loadChartData() {
        let span = selectedRange.daySpan
        chartData = (0..<span).map { day in
            let date = Calendar.current.date(byAdding: .day, value: -day, to: Date())!
            let ml = Int.random(in: 1200...3000)
            return (date, ml)
        }.reversed()
    }
}
