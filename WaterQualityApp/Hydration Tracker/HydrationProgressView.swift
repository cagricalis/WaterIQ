//  HydrationProgressView.swift
//  WaterQualityApp

import SwiftUI
import Charts

struct HydrationProgressView: View {
    @ObservedObject var viewModel: HydrationViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Weekly Intake")
                .font(.headline)
                .foregroundColor(.hNavy)

            Chart(viewModel.weeklyData, id: \.0) { (date, ml) in
                BarMark(
                    x: .value("Day", date, unit: .day),
                    y: .value("ml", ml)
                )
                .foregroundStyle(LinearGradient(colors: [.hNavy, .hBlue], startPoint: .bottom, endPoint: .top))
                .cornerRadius(6)
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { _ in
                    AxisGridLine().foregroundStyle(.clear)
                    AxisTick().foregroundStyle(.clear)
                    AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                }
            }
            .frame(height: 220)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.05), radius: 6, y: 4)
    }
}
