import SwiftUI

struct MineralWaterDetailView: View {
    let brand: MineralWaterBrand
    @EnvironmentObject var historyManager: HistoryManager
    @EnvironmentObject var session: UserSession

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                overviewSection

                if session.isPremium {
                    AnalysisGroupView(
                        title: "💎 Mineral İçeriği",
                        values: [
                            ("Kalsiyum (mg/L)", brand.kalsiyum),
                            ("Magnezyum (mg/L)", brand.magnezyum),
                            ("Sodyum (mg/L)", brand.sodyum),
                            ("Potasyum (mg/L)", brand.potasyum),
                            ("Bikarbonat (mg/L)", brand.bikarbonat),
                            ("Sülfat (mg/L)", brand.sulfat),
                            ("Klorür (mg/L)", brand.klorur),
                            ("Florür (mg/L)", brand.florur)
                        ]
                    )
                    AnalysisGroupView(
                        title: "⚗️ Kimyasal Parametreler",
                        values: [
                            ("Arsenik (µg/L)", brand.arsenik),
                            ("Kurşun (µg/L)", brand.kursun),
                            ("Nitrat (mg/L)", brand.nitrat),
                            ("Nitrit (mg/L)", brand.nitrit),
                            ("Bor (mg/L)", brand.bor),
                            ("Amonyum (mg/L)", brand.amonyum)
                        ]
                    )
                    AnalysisGroupView(
                        title: "☢️ Radyoaktif Parametreler",
                        values: [
                            ("Trityum (Bq/L)", brand.trityum),
                            ("Alfa Yayınlayıcılar (Bq/L)", brand.alfa),
                            ("Beta Yayınlayıcılar (Bq/L)", brand.beta)
                        ]
                    )
                } else {
                    LockedDetailSection()
                }
            }
            .padding(.bottom, 40)
        }
        .background(LinearGradient(colors: [.teal.opacity(0.15), .mint.opacity(0.15)],
                                   startPoint: .top, endPoint: .bottom))
        .navigationTitle("Maden Suyu Detayı")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { historyManager.addMineral(brand) }
    }

    private var headerSection: some View {
        VStack(spacing: 8) {
            Image(brand.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 4)

            Text(brand.name)
                .font(.title)
                .bold()
                .foregroundColor(.white)

            // 🔒 Puan sadece Premium’da görünür
            if session.isPremium {
                VStack(alignment: .leading, spacing: 4) {
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.white.opacity(0.2))
                            .frame(height: 10)
                        RoundedRectangle(cornerRadius: 6)
                            .fill(brand.qualityColor)
                            .frame(width: CGFloat(brand.qualityScore) * 2, height: 10)
                    }
                    Text("Kalite Puanı: \(brand.qualityScore)/100")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .background(
            LinearGradient(colors: [.mint.opacity(0.4), .teal.opacity(0.3)],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .clipShape(RoundedRectangle(cornerRadius: 24))
        )
        .padding(.horizontal)
    }

    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("💧 Genel Özellikler")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.leading, 8)
            VStack(spacing: 6) {
                OverviewRow(label: "pH", value: String(format: "%.1f", brand.ph ?? 0))
                OverviewRow(label: "TDS", value: "\(Int(brand.tds ?? 0)) ppm")
                OverviewRow(label: "PFAS", value: brand.pfas ?? "-")
                OverviewRow(label: "Microplastics", value: brand.microplastics ?? "-")
                OverviewRow(label: "Fluoride", value: String(format: "%.2f mg/L", brand.fluoride ?? 0))
                OverviewRow(label: "Packaging", value: brand.packaging ?? "-")
                OverviewRow(label: "Source", value: brand.sourceType ?? "-")
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(12)
        }
        .padding(.horizontal)
    }
}
