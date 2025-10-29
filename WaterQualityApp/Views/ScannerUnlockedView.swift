//
//  ScannerUnlockedView.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 26.10.2025.
//


//
//  ScannerUnlockedView.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 26.10.2025.
//

import SwiftUI

struct ScannerUnlockedView: View {
    @EnvironmentObject var cameraModel: CameraModel
    @EnvironmentObject var networkManager: NetworkManager
    @EnvironmentObject var historyManager: HistoryManager

    @State private var selectedWater: WaterBrand? = nil
    @State private var selectedMineral: MineralWaterBrand? = nil
    @State private var navigateToWater = false
    @State private var navigateToMineral = false
    @State private var showAlert = false

    var body: some View {
        VStack {
            // Kamera Önizleme
            CameraPreview(session: cameraModel.session)
                .frame(height: 280)
                .cornerRadius(12)
                .shadow(radius: 4)
                .padding()

            // Barkod Bilgisi
            if let code = cameraModel.scannedCode {
                Text("Kod: \(code)")
                    .font(.headline)
                    .onAppear { handleScannedCode(code) }
            } else {
                Text("Kod okutun")
                    .foregroundColor(.secondary)
            }

            Spacer()

            // İçme suyu sayfasına yönlendirme
            NavigationLink(isActive: $navigateToWater) {
                if let brand = selectedWater {
                    WaterDetailView(brand: brand)
                        .onAppear { historyManager.addWater(brand) }
                        .onDisappear { resetScanner() }
                } else { EmptyView() }
            } label: { EmptyView() }

            // Maden suyu sayfasına yönlendirme
            NavigationLink(isActive: $navigateToMineral) {
                if let brand = selectedMineral {
                    MineralWaterDetailView(brand: brand)
                        .onAppear { historyManager.addMineral(brand) }
                        .onDisappear { resetScanner() }
                } else { EmptyView() }
            } label: { EmptyView() }
        }
        .onAppear {
            networkManager.fetchLocalWaterBrands()
            networkManager.fetchMineralWaterBrands()
            cameraModel.startSession()
            resetScanner()
        }
        .onDisappear { cameraModel.stopSession() }
        .alert("Barkod bulunamadı", isPresented: $showAlert) {
            Button("Tamam") { resetScanner() }
        }
    }

    // MARK: - Barkod İşleme
    private func handleScannedCode(_ code: String) {
        if let brand = networkManager.waterBrands.first(where: { $0.barcode == code }) {
            selectedWater = brand
            navigateToWater = true
            return
        }
        if let brand = networkManager.mineralWaterBrands.first(where: { $0.barcode == code }) {
            selectedMineral = brand
            navigateToMineral = true
            return
        }
        showAlert = true
    }

    // MARK: - Reset
    private func resetScanner() {
        selectedWater = nil
        selectedMineral = nil
        navigateToWater = false
        navigateToMineral = false
        cameraModel.resetScanner()
    }
}
