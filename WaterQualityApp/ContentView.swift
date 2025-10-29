import SwiftUI

struct ContentView: View {
    @StateObject private var appModeManager = AppModeManager()
    @StateObject private var session = UserSession()
    @StateObject private var cameraModel = CameraModel()
    @StateObject private var networkManager = NetworkManager()
    @StateObject private var historyManager = HistoryManager()
    @StateObject private var viewModel = HydrationViewModel()


    var body: some View {
        Group {
            switch appModeManager.currentMode {
            case .mainApp:
                MainTabView()
                    .environmentObject(appModeManager)
                    .environmentObject(session)
                    .environmentObject(cameraModel)
                    .environmentObject(networkManager)
                    .environmentObject(historyManager)
                    .transition(.move(edge: .trailing).combined(with: .opacity))

            case .hydrationApp:
                HydrationProgressView(viewModel: viewModel)
                    .environmentObject(appModeManager)
                    .transition(.move(edge: .leading).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.4), value: appModeManager.currentMode)
    }
}
