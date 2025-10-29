
//
//  CarouselViews.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 26.10.2025.
//

import SwiftUI

// İçme Suyu Carousel
struct WaterCarouselView: View {
    @EnvironmentObject var session: UserSession
    let brands: [WaterBrand]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 18) {
                ForEach(brands) { brand in
                    NavigationLink(destination: WaterDetailView(brand: brand)) {
                        WaterCard(brand: brand)
                            .environmentObject(session)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

// Maden Suyu Carousel
struct MineralWaterCarouselView: View {
    @EnvironmentObject var session: UserSession
    let brands: [MineralWaterBrand]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 18) {
                ForEach(brands) { brand in
                    NavigationLink(destination: MineralWaterDetailView(brand: brand)) {
                        MineralWaterCard(brand: brand)
                            .environmentObject(session)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
