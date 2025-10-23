import SwiftUI

struct EmbeddedScannerView: View {
    @EnvironmentObject var cameraModel: CameraModel
    @EnvironmentObject var networkManager: NetworkManager
    @EnvironmentObject var historyManager: HistoryManager

    @State private var selectedBrand: WaterBrand? = nil
    @State private var navigate = false
    @State private var showAlert = false

    var body: some View {
        VStack {
            CameraPreview(session: cameraModel.session)
                .frame(height: 280)
                .cornerRadius(12)
                .shadow(radius: 4)
                .padding()

            if let code = cameraModel.scannedCode {
                Text("Kod: \(code)")
                    .font(.headline)
                    .onAppear { handleScannedCode(code) }
            } else {
                Text("Kod okutun")
                    .foregroundColor(.secondary)
            }

            Spacer()

            NavigationLink(isActive: $navigate) {
                if let brand = selectedBrand {
                    WaterDetailView(brand: brand)
                        .onAppear { historyManager.add(brand) }
                        .onDisappear { resetScanner() }
                } else {
                    EmptyView()
                }
            } label: { EmptyView() }
        }
        .navigationTitle("Scanner")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            networkManager.fetchLocalWaterBrands()
            cameraModel.startSession()
            resetScanner()
        }
        .onDisappear { cameraModel.stopSession() }
        .alert("Barkod bulunamadı", isPresented: $showAlert) {
            Button("Tamam") { resetScanner() }
        }
    }

    private func handleScannedCode(_ code: String) {
        if let brand = networkManager.waterBrands.first(where: { $0.barcode == code }) {
            selectedBrand = brand
            navigate = true
        } else {
            showAlert = true
        }
    }

    private func resetScanner() {
        selectedBrand = nil
        navigate = false
        cameraModel.resetScanner()
    }
}
