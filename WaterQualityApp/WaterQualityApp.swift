import SwiftUI
import FirebaseCore

@main
struct WaterQualityApp: App {
    @StateObject private var cameraModel = CameraModel()
    @StateObject private var networkManager = NetworkManager()
    @StateObject private var historyManager = HistoryManager()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(cameraModel)
                .environmentObject(networkManager)
                .environmentObject(historyManager)
        }
    }
}
