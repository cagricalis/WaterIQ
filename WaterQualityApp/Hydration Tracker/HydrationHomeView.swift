//  HydrationHomeView.swift
//  WaterQualityApp

import SwiftUI

struct HydrationHomeView: View {
    @ObservedObject var viewModel: HydrationViewModel
    @State private var showAdd = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 22) {
                WaveHeaderView(
                    title: "Stay hydrated",
                    goalML: viewModel.goalML,
                    completedPercent: viewModel.progressPercent(),
                    subtitle: viewModel.progressPercent() < 0.9 ? "Almost there, champ!" : "Great job!"
                )

                CircularHydrationView(
                    progress: viewModel.progressPercent(),
                    today: viewModel.todayML,
                    goal: viewModel.goalML
                )

                // Quick Add
                HStack(spacing: 12) {
                    ForEach(viewModel.quickOptions, id: \.self) { ml in
                        Button("+\(ml) ml") {
                            Task { await viewModel.addIntake(ml: ml, source: "quick") }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.white)
                        .foregroundColor(.hNavy)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
                    }
                    Button {
                        showAdd = true
                    } label: {
                        Image(systemName: "plus.circle.fill").font(.title2)
                            .frame(width: 50, height: 44)
                            .background(Color.white)
                            .foregroundColor(.hNavy)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
                    }
                }
                .padding(.horizontal, 2)

                // Haftalık özet kartı
                HydrationProgressView(viewModel: viewModel)
            }
            .padding()
        }
        .background(LinearGradient(colors: [.hBackground, .hBlue.opacity(0.08)], startPoint: .top, endPoint: .bottom).ignoresSafeArea())
        .sheet(isPresented: $showAdd) {
            AddDrinkSheet { ml, kind in
                Task { await viewModel.addIntake(ml: ml, source: kind.lowercased()) }
            }
        }
        .task { await viewModel.load() }
    }
}
