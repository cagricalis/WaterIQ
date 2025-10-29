import SwiftUI

// MARK: - Destek Tipleri (Aynı dosyada tutarak "scope" hatalarını önlüyoruz)
enum PlanType { case monthly, lifetime }

struct PlanCard: View {
    let title: String
    let price: String
    let subtext: String
    let isSelected: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title).font(.headline)
                    Text(price).font(.title3).bold()
                    Text(subtext).font(.caption).foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .blue : .gray)
                    .font(.title2)
            }
            .padding()
            .background(isSelected ? Color.blue.opacity(0.1) : Color(.systemGray6))
            .cornerRadius(12)
        }
        .padding(.horizontal, 4)
        .animation(.easeInOut, value: isSelected)
    }
}

// MARK: - Paywall
struct PaywallView: View {
    @EnvironmentObject var session: UserSession
    @StateObject private var purchaseManager = MockPurchaseManager()

    @State private var selectedPlan: PlanType = .monthly
    @State private var showSuccess = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Banner
                Text("🎉 %25 İNDİRİM FIRSATI")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 20)
                    .background(Color.orange)
                    .cornerRadius(20)

                Text("WaterIQ Premium")
                    .font(.largeTitle).bold()
                    .padding(.top, 10)

                // Özellik listesi
                VStack(alignment: .leading, spacing: 8) {
                    Label("Sınırsız barkod tarama", systemImage: "qrcode.viewfinder")
                    Label("Tüm mineral analizlerine erişim", systemImage: "drop.fill")
                    Label("Geçmiş kaydı sınırı yok", systemImage: "clock.fill")
                    Label("Reklamsız deneyim", systemImage: "nosign")
                }
                .font(.body)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)

                // Plan seçim kartları
                VStack(spacing: 12) {
                    PlanCard(
                        title: "Yıllık Premium",
                        price: "₺500 / yıl",
                        subtext: "₺667 yerine %25 indirim!",
                        isSelected: selectedPlan == .monthly
                    )
                    .onTapGesture { selectedPlan = .monthly }

                    PlanCard(
                        title: "Lifetime Premium",
                        price: "₺999,99 (tek seferlik)",
                        subtext: "Ömür boyu erişim",
                        isSelected: selectedPlan == .lifetime
                    )
                    .onTapGesture { selectedPlan = .lifetime }
                }
                .padding(.horizontal)

                // Satın alma (mock)
                Button {
                    Task {
                        await purchaseManager.purchasePremium(userSession: session)
                        showSuccess = true
                    }
                } label: {
                    Text(selectedPlan == .lifetime
                         ? "₺999,99 Karşılığı Lifetime Satın Al"
                         : "₺500 / Yıl Premium’a Geç")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.top, 10)

                // Alt aksiyonlar
                VStack(spacing: 8) {
                    Button("Free Trial Başlat (7 Gün)") {
                        Task {
                            await purchaseManager.purchasePremium(userSession: session)
                            showSuccess = true
                        }
                    }
                    .font(.callout)
                    .foregroundColor(.blue)

                    Button("Satın Almaları Geri Yükle") {
                        Task {
                            await purchaseManager.restorePurchases(userSession: session)
                            showSuccess = true
                        }
                    }
                    .font(.callout)
                    .foregroundColor(.gray)

                    Button("Free hesap olarak devam et") {
                        Task {
                            await purchaseManager.resetToFree(userSession: session)
                        }
                    }
                    .font(.callout)
                    .padding(.top, 4)
                }
                .padding(.top, 8)
            }
            .padding()
        }
        .alert("🎉 Tebrikler!", isPresented: $showSuccess) {
            Button("Tamam") { showSuccess = false }
        } message: {
            Text("Premium üyelik aktif edildi! Tüm özellikleri şimdi kullanabilirsiniz.")
        }
        .navigationTitle("Premium’a Geç")
    }
}
