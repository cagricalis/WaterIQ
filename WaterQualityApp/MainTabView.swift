//
//  MainTabView.swift
//  WaterQualityApp
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var cameraModel: CameraModel
    @EnvironmentObject var networkManager: NetworkManager
    @EnvironmentObject var historyManager: HistoryManager
    @EnvironmentObject var session: UserSession
    @EnvironmentObject var appModeManager: AppModeManager  // ✅ eklendi

    var body: some View {
        TabView {
            // 🔹 Home
            NavigationStack {
                HomeView()
                    .environmentObject(appModeManager) // ✅ ekle
            }
            .tabItem { Label("Home", systemImage: "house.fill") }

            // 🔹 Water List
            NavigationStack {
                WaterListView()
                    .environmentObject(networkManager)
                    .environmentObject(session)
            }
            .tabItem { Label("Water List", systemImage: "drop.fill") }

            // 🔹 Scanner
            NavigationStack {
                if session.isPremium {
                    EmbeddedScannerView()
                        .environmentObject(cameraModel)
                        .environmentObject(networkManager)
                        .environmentObject(historyManager)
                } else {
                    LockedScannerView()
                }
            }
            .tabItem { Label("Scanner", systemImage: "qrcode.viewfinder") }

            // 🔹 History
            NavigationStack {
                HistoryView()
                    .environmentObject(historyManager)
            }
            .tabItem { Label("History", systemImage: "clock.fill") }

            // 🔹 Settings
            NavigationStack {
                SettingsListView()
                    .environmentObject(session)
            }
            .tabItem { Label("Settings", systemImage: "gearshape.fill") }
        }
    }
}
