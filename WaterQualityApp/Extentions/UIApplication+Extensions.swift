//
//  UIApplication+Extensions.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 23.10.2025.
//

import SwiftUI

extension UIApplication {
    func endEditing(_ force: Bool = true) {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .forEach { $0.endEditing(force) }
    }
}


