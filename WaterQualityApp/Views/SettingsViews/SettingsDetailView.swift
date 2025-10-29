//
//  SettingsDetailView.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 23.10.2025.
//

import SwiftUI

struct SettingsDetailView: View {
    let title: String

    var body: some View {
        VStack {
            Text(title)
                .font(.largeTitle)
                .bold()
                .padding()

            Spacer()
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
