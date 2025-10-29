//
//  HistoryView.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 27.10.2025.
//

import SwiftUI

enum HistoryFilter: String, CaseIterable {
    case all = "Tümü"
    case water = "İçme Suları"
    case mineral = "Maden Suları"
}

struct HistoryView: View {
    @EnvironmentObject var historyManager: HistoryManager
    @EnvironmentObject var session: UserSession
    @State private var selectedFilter: HistoryFilter = .all
    @Namespace private var animation
    @State private var showConfirmDelete = false

    var filteredWaterHistory: [WaterHistoryItem] {
        switch selectedFilter {
        case .all, .water: return historyManager.waterHistory.sorted { $0.date > $1.date }
        default: return []
        }
    }

    var filteredMineralHistory: [MineralHistoryItem] {
        switch selectedFilter {
        case .all, .mineral: return historyManager.mineralHistory.sorted { $0.date > $1.date }
        default: return []
        }
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue.opacity(0.2), .cyan.opacity(0.3)],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            if session.isPremium {
                VStack(spacing: 16) {
                    // 🔹 Sekme Butonları
                    HStack(spacing: 0) {
                        ForEach(HistoryFilter.allCases, id: \.self) { filter in
                            Button {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                    selectedFilter = filter
                                }
                            } label: {
                                ZStack {
                                    if selectedFilter == filter {
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color.white)
                                            .shadow(radius: 3)
                                            .matchedGeometryEffect(id: "HISTORY_TAB", in: animation)
                                            .frame(height: 38)
                                    }
                                    Text(filter.rawValue)
                                        .font(.headline)
                                        .foregroundColor(selectedFilter == filter ? .blue : .white)
                                        .frame(maxWidth: .infinity)
                                }
                            }
                        }
                    }
                    .padding(6)
                    .background(Color.white.opacity(0.15))
                    .clipShape(Capsule())
                    .padding(.horizontal)

                    // 🔹 Liste
                    ScrollView {
                        VStack(spacing: 12) {
                            if filteredWaterHistory.isEmpty && filteredMineralHistory.isEmpty {
                                VStack(spacing: 12) {
                                    Image(systemName: "clock.arrow.circlepath")
                                        .font(.system(size: 44))
                                        .foregroundColor(.white.opacity(0.7))
                                    Text("Henüz geçmiş bulunmuyor")
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                .padding(.top, 100)
                            } else {
                                if selectedFilter != .mineral {
                                    ForEach(filteredWaterHistory) { record in
                                        NavigationLink(destination: WaterDetailView(brand: record.brand)
                                            .environmentObject(session)) {
                                            HistoryCardView(
                                                image: record.brand.imageName,
                                                name: record.brand.name,
                                                score: record.brand.qualityScore,
                                                color: record.brand.qualityColor,
                                                type: "💧 İçme Suyu",
                                                date: record.date
                                            )
                                        }
                                    }
                                }
                                if selectedFilter != .water {
                                    ForEach(filteredMineralHistory) { record in
                                        NavigationLink(destination: MineralWaterDetailView(brand: record.brand)
                                            .environmentObject(session)) {
                                            HistoryCardView(
                                                image: record.brand.imageName,
                                                name: record.brand.name,
                                                score: record.brand.qualityScore,
                                                color: record.brand.qualityColor,
                                                type: "⛲️ Maden Suyu",
                                                date: record.date
                                            )
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if !historyManager.isEmpty {
                            Button(role: .destructive) {
                                showConfirmDelete = true
                            } label: {
                                Label("Tümünü Sil", systemImage: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
                .confirmationDialog("Tüm geçmişi silmek istediğine emin misin?",
                                    isPresented: $showConfirmDelete,
                                    titleVisibility: .visible) {
                    Button("Evet, sil", role: .destructive) {
                        historyManager.clearAll()
                    }
                    Button("Vazgeç", role: .cancel) { }
                }
            } else {
                LockedHistoryView()
            }
        }
        .navigationTitle("Geçmiş")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// 🔒 Kilitli görünüm
struct LockedHistoryView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "lock.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .foregroundColor(.gray)
            Text("Geçmiş sadece Premium üyeler içindir 🔒")
                .font(.headline)
                .foregroundColor(.secondary)
            Text("Premium’a geçerek geçmiş kayıtlarını görüntüleyebilirsin.")
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
            }
        }
        .padding(.top, 80)
    }
}
