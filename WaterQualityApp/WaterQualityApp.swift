//
//  WaterQualityApp.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 27.10.2025.
//

import SwiftUI
import FirebaseCore

// MARK: - AppDelegate
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

// MARK: - Main App
@main
struct WaterQualityApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    // MARK: - Global States
    @StateObject private var appModeManager = AppModeManager()
    @StateObject private var session = UserSession()
    @StateObject private var cameraModel = CameraModel()
    @StateObject private var networkManager = NetworkManager()
    @StateObject private var historyManager = HistoryManager()
    @StateObject private var hydrationViewModel = HydrationViewModel()

    var body: some Scene {
        WindowGroup {
            Group {
                switch appModeManager.currentMode {
                case .mainApp:
                    // 🔹 Ana Uygulama (WaterIQ)
                    if session.user == nil {
                        SignUpView()
                            .environmentObject(session)
                            .environmentObject(appModeManager)
                    } else {
                        MainTabView()
                            .environmentObject(appModeManager)
                            .environmentObject(session)
                            .environmentObject(cameraModel)
                            .environmentObject(networkManager)
                            .environmentObject(historyManager)
                    }

                case .hydrationApp:
                    // 🔹 Su Takip Uygulaması (bağımsız alt mod)
                    HydrationAppRootView(viewModel: hydrationViewModel)
                        .environmentObject(appModeManager)
                        .transition(.move(edge: .trailing))
                }
            }
            .animation(.easeInOut(duration: 0.4), value: appModeManager.currentMode)
        }
    }
}
