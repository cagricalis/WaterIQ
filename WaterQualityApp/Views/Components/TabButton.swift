


//
//  TabButtons.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 26.10.2025.
//

import SwiftUI

struct TabButton: View {
    let title: String
    let index: Int
    @Binding var selectedTab: Int
    var animation: Namespace.ID

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                selectedTab = index
            }
        } label: {
            ZStack {
                if selectedTab == index {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.thinMaterial)
                        .matchedGeometryEffect(id: "TAB", in: animation)
                        .shadow(radius: 4)
                }
                Text(title)
                    .font(.headline)
                    .foregroundColor(selectedTab == index ? .white : .white.opacity(0.6))
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}
