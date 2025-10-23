import SwiftUI

struct ScannerContainerView: View {
    @EnvironmentObject var cameraModel: CameraModel
    @EnvironmentObject var networkManager: NetworkManager
    @EnvironmentObject var historyManager: HistoryManager

    @State private var selectedBrand: WaterBrand?
    @State private var isNavigating = false

    var body: some View {
        VStack {
            Text("Scan Code")
                .font(.headline)
                .padding()

            CameraPreview(session: cameraModel.session)
                .frame(height: 300)
                .cornerRadius(12)
                .shadow(radius: 3)
                .padding()

            if let code = cameraModel.scannedCode {
                Text("Okunan Kod: \(code)")
                    .font(.headline)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .onAppear {
                        handleScannedCode(code)
                    }
            } else {
                Text("Henüz bir kod okutulmadı")
                    .foregroundColor(.gray)
                    .padding()
            }

            Spacer()

            NavigationLink(
                isActive: $isNavigating,
                destination: {
                    if let brand = selectedBrand {
                        WaterDetailView(brand: brand)
                            .onAppear { historyManager.add(brand) }
                            .onDisappear { resetScanner() }
                    } else {
                        EmptyView()
                    }
                },
                label: { EmptyView() }
            )
        }
        .onAppear {
            cameraModel.startSession()
            networkManager.fetchLocalWaterBrands()
            resetScanner()
        }
        .onDisappear {
            cameraModel.stopSession()
        }
        .navigationTitle("Scanner")
    }

    private func handleScannedCode(_ code: String) {
        if let brand = networkManager.waterBrands.first(where: { $0.barcode == code }) {
            selectedBrand = brand
            isNavigating = true
        }
    }

    private func resetScanner() {
        selectedBrand = nil
        isNavigating = false
        cameraModel.resetScanner()
    }
}
