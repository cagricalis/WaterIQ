import SwiftUI

struct WaterDetailView: View {
    let brand: WaterBrand
    @EnvironmentObject var historyManager: HistoryManager
    @EnvironmentObject var session: UserSession

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                overviewSection

                if session.isPremium {
                    AnalysisGroupView(
                        title: "🦠 Bakteriyolojik Analizler",
                        values: [
                            ("E.Coli (250 ml)", brand.eColi),
                            ("Enterokok (250 ml)", brand.enterokok),
                            ("Koliform Bakteri (250 ml)", brand.koliform),
                            ("Fekal Koliform (250 ml)", brand.fekalKoliform),
                            ("P.aeruginosa (250 ml)", brand.pAeruginosa),
                            ("C.Perfringens (100 ml)", brand.cPerfringens)
                        ]
                    )
                    AnalysisGroupView(
                        title: "⚗️ Kimyasal Parametreler",
                        values: [
                            ("Alüminyum (µg/L)", brand.aluminyum),
                            ("Arsenik (µg/L)", brand.arsenik),
                            ("Bor (mg/L)", brand.bor),
                            ("Kadmiyum (µg/L)", brand.kadmiyum),
                            ("Kurşun (µg/L)", brand.kursun),
                            ("Nitrat (mg/L)", brand.nitrat),
                            ("Nitrit (mg/L)", brand.nitrit),
                            ("Florür (mg/L)", brand.florur),
                            ("Bikarbonat (mg/L)", brand.bikarbonat)
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
        .background(LinearGradient(colors: [.blue.opacity(0.15), .cyan.opacity(0.15)],
                                   startPoint: .top, endPoint: .bottom))
        .navigationTitle("Su Detayı")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { historyManager.addWater(brand) }
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

            // 🔒 Puan sadece Premium’da gösterilir
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
            LinearGradient(colors: [.blue.opacity(0.4), .cyan.opacity(0.3)],
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
