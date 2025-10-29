//
//  WaterSearchView.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 23.10.2025.
//


import SwiftUI

struct WaterSearchView: View {
    @EnvironmentObject var networkManager: NetworkManager
    @State private var searchText = ""

    var filteredBrands: [WaterBrand] {
        if searchText.isEmpty {
            return networkManager.waterBrands
        } else {
            return networkManager.waterBrands.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Search water...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                List(filteredBrands) { brand in
                    NavigationLink(destination: WaterDetailView(brand: brand)) {
                        HStack {
                            Image(brand.imageName)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            Text(brand.name)
                                .font(.headline)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Search Water")
        }
    }
}
