import AVFoundation
import SwiftUI

class CameraModel: NSObject, ObservableObject {
    @Published var scannedCode: String? = nil
    let session = AVCaptureSession()
    private var videoOutput = AVCaptureMetadataOutput()

    override init() {
        super.init()
        setupSession()
    }

    private func setupSession() {
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else { return }
        if session.canAddInput(input) { session.addInput(input) }
        if session.canAddOutput(videoOutput) { session.addOutput(videoOutput) }

        videoOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        videoOutput.metadataObjectTypes = [.qr, .ean8, .ean13, .code128]
    }

    func startSession() {
        if !session.isRunning { session.startRunning() }
        scannedCode = nil
    }

    func stopSession() {
        if session.isRunning { session.stopRunning() }
    }

    func resetScanner() {
        scannedCode = nil
    }

    func stopAndReset() {
        stopSession()
        resetScanner()
    }
}

extension CameraModel: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let stringValue = object.stringValue else { return }
        scannedCode = stringValue
    }
}
