//
//  EmbeddedScannerView.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 26.10.2025.
//

import SwiftUI

struct EmbeddedScannerView: View {
    @EnvironmentObject var cameraModel: CameraModel
    @EnvironmentObject var networkManager: NetworkManager
    @EnvironmentObject var historyManager: HistoryManager
    @EnvironmentObject var session: UserSession

    var body: some View {
        Group {
            if session.isPremium {
                ScannerUnlockedView()
                    .environmentObject(cameraModel)
                    .environmentObject(networkManager)
                    .environmentObject(historyManager)
            } else {
                LockedScannerView()
            }
        }
        .navigationTitle("Barkod Tarayıcı")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Kilitli Görünüm
struct LockedScannerView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "lock.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .foregroundColor(.gray)
                .padding(.bottom, 10)

            Text("Bu özellik sadece Premium üyeler içindir 🔒")
                .font(.headline)
                .foregroundColor(.secondary)

            Text("Premium’a geçerek barkod tarayıcıyı kullanabilirsin.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal)

            NavigationLink(destination: PaywallView()) {
                Text("Premium’a Geç")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal, 40)
                    .padding(.top, 10)
            }
        }
        .padding()
    }
}
