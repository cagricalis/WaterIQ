//
//  HydrationAppRootView.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 28.10.2025.
//

import SwiftUI
import Charts

struct HydrationAppRootView: View {
    @ObservedObject var viewModel: HydrationViewModel
    @EnvironmentObject var appModeManager: AppModeManager
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            todayView
                .tag(0)
                .tabItem { Label("Bugün", systemImage: "drop.fill") }

            HydrationStatsView(viewModel: viewModel)
                .tag(1)
                .tabItem { Label("İstatistikler", systemImage: "chart.bar.fill") }

            HydrationSettingsView()
                .tag(2)
                .tabItem { Label("Ayarlar", systemImage: "gearshape.fill") }
        }
        .tint(.hBlue)
    }

    // MARK: - Bugün Sekmesi
    private var todayView: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [.white, Color.hBlue.opacity(0.1)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 28) {

                        // Başlık
                        VStack(spacing: 8) {
                            Text("Günlük Su Takibi")
                                .font(.system(size: 26, weight: .bold, design: .rounded))
                                .foregroundColor(.hNavy)
                            Text(motivationalQuote())
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 30)

                        // Günlük İlerleme Halkası
                        CircularHydrationView(
                            progress: viewModel.progressPercent(),
                            today: viewModel.todayML,
                            goal: viewModel.goalML
                        )
                        .frame(height: 230)
                        .padding(.top, 10)

                        // Haftalık Grafik
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Haftalık Su Alımı 💧")
                                .font(.headline)
                                .foregroundColor(.hNavy)
                                .padding(.leading, 6)

                            HydrationProgressView(viewModel: viewModel)
                                .frame(height: 220)
                                .background(Color.white)
                                .cornerRadius(16)
                                .shadow(color: .hBlue.opacity(0.1), radius: 8, y: 4)
                                .padding(.horizontal)
                        }

                        // Hızlı Ekle Butonları
                        VStack(spacing: 16) {
                            Text("Hızlı Ekle")
                                .font(.headline)
                                .foregroundColor(.hNavy)

                            HStack(spacing: 16) {
                                ForEach(viewModel.quickOptions, id: \.self) { ml in
                                    Button {
                                        Task { await viewModel.addIntake(ml: ml, source: "quick") }
                                    } label: {
                                        Text("+\(ml) ml")
                                            .font(.headline)
                                            .frame(width: 90, height: 44)
                                            .background(
                                                LinearGradient(
                                                    colors: [.hBlue, .hNavy],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .foregroundColor(.white)
                                            .cornerRadius(12)
                                            .shadow(color: .hBlue.opacity(0.3), radius: 4, y: 2)
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                        .padding(.horizontal)
                        .padding(.bottom, 30)

                        // WaterIQ Dönüş Butonu
                        Button {
                            withAnimation(.easeInOut(duration: 0.35)) {
                                appModeManager.currentMode = .mainApp
                            }
                        } label: {
                            HStack {
                                Image(systemName: "arrow.left.circle.fill")
                                Text("WaterIQ Uygulamasına Dön")
                            }
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(colors: [.hBlue, .hNavy],
                                               startPoint: .leading,
                                               endPoint: .trailing)
                            )
                            .foregroundColor(.white)
                            .cornerRadius(14)
                            .shadow(color: .hBlue.opacity(0.3), radius: 6, y: 3)
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Hydration Tracker")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Motive Edici Cümleler
    private func motivationalQuote() -> String {
        [
            "Su hayatın kaynağıdır 💧",
            "Bir yudum daha, enerji seninle!",
            "Bugün de harika gidiyorsun 💙",
            "Küçük adımlar, büyük fark yaratır 🌿",
            "Kendine iyi bak, su iç 💦"
        ].randomElement() ?? ""
    }
}
