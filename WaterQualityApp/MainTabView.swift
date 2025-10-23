import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var cameraModel: CameraModel
    @EnvironmentObject var networkManager: NetworkManager
    @EnvironmentObject var historyManager: HistoryManager

    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem { Label("Home", systemImage: "house.fill") }

            NavigationStack {
                WaterListView()
            }
            .tabItem { Label("Water List", systemImage: "drop.fill") }

            NavigationStack {
                EmbeddedScannerView()
            }
            .tabItem { Label("Scanner", systemImage: "qrcode.viewfinder") }

            NavigationStack {
                HistoryView()
            }
            .tabItem { Label("History", systemImage: "clock.fill") }

            NavigationStack {
                SettingsListView()
            }
            .tabItem { Label("Settings", systemImage: "gearshape.fill") }
        }
    }
}
