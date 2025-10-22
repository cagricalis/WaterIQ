import SwiftUI
import AVFoundation

struct ScannerView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var camera = CameraModel()
    
    var body: some View {
        VStack {
            // Üstte küçük bir başlık ve geri butonu
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .padding()
                }
                Spacer()
                Text("Scan Code")
                    .font(.headline)
                Spacer()
                Spacer().frame(width: 44) // denge için
            }
            .padding(.horizontal)
            
            // Kamera önizleme alanı
            ZStack {
                CameraPreview(session: camera.session)
                    .ignoresSafeArea(.container, edges: .bottom)
                
                if let code = camera.scannedCode {
                    VStack {
                        Spacer()
                        Text("Sonuç: \(code)")
                            .font(.headline)
                            .padding()
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                        Spacer().frame(height: 80)
                    }
                }
            }
        }
        .onAppear {
            camera.checkPermission()
            camera.startSession()
        }
        .onDisappear {
            camera.stopSession()
        }
    }
}
