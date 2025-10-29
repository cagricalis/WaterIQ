import SwiftUI

struct ScannerContainerView: View {
    @EnvironmentObject var cameraModel: CameraModel
    @EnvironmentObject var networkManager: NetworkManager
    @EnvironmentObject var historyManager: HistoryManager

    @State private var selectedWater: WaterBrand?
    @State private var selectedMineral: MineralWaterBrand?
    @State private var navigateToWater = false
    @State private var navigateToMineral = false
    @State private var showAlert = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Barkod Tarayıcı")
                .font(.title2)
                .bold()
                .padding(.top, 10)

            // 🔹 Kamera önizleme
            CameraPreview(session: cameraModel.session)
                .frame(height: 320)
                .cornerRadius(14)
                .shadow(radius: 5)
                .padding(.horizontal)

            // 🔹 Kod bilgisi
            if let code = cameraModel.scannedCode {
                Text("Okunan Kod: \(code)")
                    .font(.headline)
                    .padding(10)
                    .background(Color.gray.opacity(0.15))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .onAppear {
                        handleScannedCode(code)
                    }
            } else {
                Text("Henüz bir kod okutulmadı")
                    .foregroundColor(.gray)
                    .padding(.top, 8)
            }

            Spacer()

            // 🔹 İçme suyu navigasyonu
            NavigationLink(isActive: $navigateToWater) {
                if let brand = selectedWater {
                    WaterDetailView(brand: brand)
                        .onAppear {
                            historyManager.addWater(brand)
                        }
                        .onDisappear {
                            resetScanner()
                        }
                } else {
                    EmptyView()
                }
            } label: { EmptyView() }

            // 🔹 Maden suyu navigasyonu
            NavigationLink(isActive: $navigateToMineral) {
                if let brand = selectedMineral {
                    MineralWaterDetailView(brand: brand)
                        .onAppear {
                            historyManager.addMineral(brand)
                        }
                        .onDisappear {
                            resetScanner()
                        }
                } else {
                    EmptyView()
                }
            } label: { EmptyView() }
        }
        .navigationTitle("Scanner")
        .onAppear {
            cameraModel.startSession()
            networkManager.fetchLocalWaterBrands()
            networkManager.fetchMineralWaterBrands()
            resetScanner()
        }
        .onDisappear {
            cameraModel.stopSession()
        }
        .alert("Barkod bulunamadı", isPresented: $showAlert) {
            Button("Tamam") {
                resetScanner()
            }
        }
    }

    // MARK: - Kod kontrolü
    private func handleScannedCode(_ code: String) {
        // 🔹 İçme sularında kontrol
        if let brand = networkManager.waterBrands.first(where: { $0.barcode == code }) {
            selectedWater = brand
            navigateToWater = true
            return
        }

        // 🔹 Maden sularında kontrol
        if let brand = networkManager.mineralWaterBrands.first(where: { $0.barcode == code }) {
            selectedMineral = brand
            navigateToMineral = true
            return
        }

        // 🔹 Eşleşme bulunamadıysa
        showAlert = true
    }

    // MARK: - Resetleme
    private func resetScanner() {
        selectedWater = nil
        selectedMineral = nil
        navigateToWater = false
        navigateToMineral = false
        cameraModel.resetScanner()
    }
}
