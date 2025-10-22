import SwiftUI

struct EmbeddedScannerView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var camera = CameraModel()
    
    var body: some View {
        VStack {
            // Üstte geri butonu
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .padding()
                }
                Spacer()
                Text("Scan Code")
                    .font(.headline)
                Spacer()
            }
            
            // Kamera alanı
            CameraPreview(session: camera.session)
                .frame(height: 300)
                .cornerRadius(12)
                .shadow(radius: 3)
                .padding()
            
            if let code = camera.scannedCode {
                Text("Okunan Kod: \(code)")
                    .font(.headline)
                    .padding()
            }
            
            Spacer()
        }
        .onAppear { camera.startSession() }
        .onDisappear { camera.stopSession() }
    }
}
