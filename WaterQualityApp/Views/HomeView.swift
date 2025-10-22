//
//  HomeView.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 10.10.2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var networkManager = NetworkManager()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                
                // Başlık ve See All
                HStack {
                    Text("Waters")
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                    
                    NavigationLink(destination: WaterListView()) {
                        Text("See All")
                            .foregroundColor(.blue)
                            .fontWeight(.semibold)
                    }
                }
                .padding(.horizontal)
                
                // Yana kaydırmalı horizontal list
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(networkManager.waterBrands) { brand in
                            NavigationLink(destination: WaterDetailView(brand: brand)) {
                                VStack {
                                    Image(brand.imageName)
                                        .resizable()
                                        .frame(width: 120, height: 120)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    
                                    Text(brand.name)
                                        .font(.headline)
                                }
                                .frame(width: 140)
                                .shadow(radius: 2)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 160)
                
                Spacer()
            }
            .navigationTitle("Home")
            .onAppear {
                networkManager.fetchLocalWaterBrands() // veya API ile fetchWaterBrands()
            }
        }
    }
}
