//
//  WaterQualityAppWidgetExtensionBundle.swift
//  WaterQualityAppWidgetExtension
//
//  Created by Çağrı Mehmet Çalış on 27.10.2025.
//

import WidgetKit
import SwiftUI

@main
struct WaterQualityAppWidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        WaterQualityAppWidgetExtension()
        WaterQualityAppWidgetExtensionControl()
        WaterQualityAppWidgetExtensionLiveActivity()
    }
}
