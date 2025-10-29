
//
//  OverviewRow.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 27.10.2025.
//

import SwiftUI

public struct OverviewRow: View {
    public let label: String
    public let value: String

    public init(label: String, value: String) {
        self.label = label
        self.value = value
    }

    public var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.white.opacity(0.9))
                .font(.subheadline)
            Spacer()
            Text(value)
                .foregroundColor(.white)
                .font(.subheadline)
                .bold()
        }
        .padding(.vertical, 2)
        Divider().background(Color.white.opacity(0.2))
    }
}
