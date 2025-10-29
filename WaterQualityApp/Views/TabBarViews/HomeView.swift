//
//  HomeView.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 27.10.2025.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var cameraModel: CameraModel
    @EnvironmentObject var networkManager: NetworkManager
    @EnvironmentObject var historyManager: HistoryManager
    @EnvironmentObject var session: UserSession
    @EnvironmentObject var appModeManager: AppModeManager

    @State private var selectedTab: Int = 0
    @Namespace private var animation

    var body: some View {
        ZStack {
            LinearGradient(colors: [.cyan.opacity(0.4), .blue.opacity(0.2)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 30) {
                    headerSection
                    tabSelector

                    // 🔹 İçerik (sular)
                    Group {
                        if selectedTab == 0 {
                            WaterCarouselView(brands: limitedWaterList)
                        } else {
                            MineralWaterCarouselView(brands: limitedMineralList)
                        }
                    }

                    // 🔹 Özellik Butonları
                    featureButtons

                    // 🔹 Su Takip Uygulaması Butonu
                    hydrationAppButton
                }
            }
        }
        .onAppear {
            networkManager.fetchLocalWaterBrands()
            networkManager.fetchMineralWaterBrands()
        }
    }
}

// MARK: - Bölümler

extension HomeView {
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Hoş geldin,")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                Text(session.user?.email ?? "Kullanıcı")
                    .font(.title.bold())
                    .foregroundColor(.white)
            }
            Spacer()
            Image("wateriq_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 50)
                .shadow(radius: 3)
        }
        .padding(.horizontal)
        .padding(.top, 40)
    }

    private var tabSelector: some View {
        HStack(spacing: 0) {
            TabButton(title: "İçme Suları", index: 0, selectedTab: $selectedTab, animation: animation)
            TabButton(title: "Maden Suları", index: 1, selectedTab: $selectedTab, animation: animation)
        }
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .padding(.horizontal)
    }

    private var featureButtons: some View {
        HStack(spacing: 16) {
            if session.isPremium {
                FeatureButton(
                    title: "Barkod Tara",
                    icon: "qrcode.viewfinder",
                    color: .blue,
                    destination: EmbeddedScannerView()
                        .environmentObject(cameraModel)
                        .environmentObject(networkManager)
                        .environmentObject(historyManager)
                )
            } else {
                LockedFeatureButton(title: "Barkod Tara")
            }

            FeatureButton(
                title: "Suları Keşfet",
                icon: "magnifyingglass",
                color: .green,
                destination: WaterListView()
                    .environmentObject(networkManager)
                    .environmentObject(session)
            )
        }
        .padding(.horizontal)
    }

    // 🔹 Su Takip Uygulaması Butonu
    private var hydrationAppButton: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.5)) {
                appModeManager.currentMode = .hydrationApp
            }
        } label: {
            VStack(spacing: 8) {
                Image(systemName: "drop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 55, height: 55)
                    .foregroundColor(.teal)
                    .shadow(radius: 3)
                Text("Su Takip Uygulaması")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                LinearGradient(colors: [.teal.opacity(0.3), .blue.opacity(0.2)],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .teal.opacity(0.4), radius: 5, x: 0, y: 3)
        }
        .padding(.horizontal)
        .padding(.bottom, 80)
    }

    // 🔹 Free kullanıcılar için sınırlı liste
    private var limitedWaterList: [WaterBrand] {
        session.isPremium ? networkManager.waterBrands : Array(networkManager.waterBrands.prefix(3))
    }

    private var limitedMineralList: [MineralWaterBrand] {
        session.isPremium ? networkManager.mineralWaterBrands : Array(networkManager.mineralWaterBrands.prefix(3))
    }
}
