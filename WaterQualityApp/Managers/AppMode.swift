//
//  AppModeManager.swift
//

import SwiftUI

enum AppMode {
    case mainApp
    case hydrationApp
}

final class AppModeManager: ObservableObject {
    @Published var currentMode: AppMode = .mainApp
}
