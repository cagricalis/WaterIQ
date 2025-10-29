import SwiftUI

// MARK: - OverviewSection (İçme Suyu için)
struct OverviewSection: View {
    let brand: WaterBrand

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Overview")
                .font(.title3)
                .bold()
                .padding(.horizontal)

            VStack(spacing: 12) {
                HStack {
                    OverviewItem(title: "pH", value: brand.ph.formatted(1))
                    OverviewItem(title: "TDS", value: "\(brand.tds.formatted(0)) ppm")
                    OverviewItem(title: "Fluoride", value: "\(brand.fluoride.formatted(2)) mg/L")
                }

                HStack {
                    OverviewItem(title: "PFAS", value: brand.pfas ?? "-")
                    OverviewItem(title: "Microplastics", value: brand.microplastics ?? "-")
                }

                HStack {
                    OverviewItem(title: "Packaging", value: brand.packaging ?? "-")
                    OverviewItem(title: "Source", value: brand.sourceType ?? "-")
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
}

// MARK: - MineralOverviewSection (Maden Suyu için)
struct MineralOverviewSection: View {
    let brand: MineralWaterBrand

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Overview")
                .font(.title3)
                .bold()
                .padding(.horizontal)

            VStack(spacing: 12) {
                HStack {
                    OverviewItem(title: "pH", value: brand.ph.formatted(1))
                    OverviewItem(title: "TDS", value: "\(brand.tds.formatted(0)) ppm")
                    OverviewItem(title: "Fluoride", value: "\(brand.fluoride.formatted(2)) mg/L")
                }

                HStack {
                    OverviewItem(title: "PFAS", value: brand.pfas ?? "-")
                    OverviewItem(title: "Microplastics", value: brand.microplastics ?? "-")
                }

                HStack {
                    OverviewItem(title: "Packaging", value: brand.packaging ?? "-")
                    OverviewItem(title: "Source", value: brand.sourceType ?? "-")
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
}

// MARK: - OverviewItem (Küçük bilgi kartı)
struct OverviewItem: View {
    let title: String
    let value: String

    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.headline)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - AnalysisGroupView
struct AnalysisGroupView: View {
    let title: String
    let values: [(String, String?)]

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
                .padding(.horizontal)

            VStack(alignment: .leading, spacing: 4) {
                ForEach(values, id: \.0) { item in
                    if let val = item.1 {
                        HStack {
                            Text(item.0)
                            Spacer()
                            Text(val)
                                .foregroundColor(.blue)
                        }
                        .font(.subheadline)
                        .padding(.vertical, 2)
                        .padding(.horizontal)
                    }
                }
            }
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
        }
        .padding(.top, 8)
    }
}

// MARK: - License Bilgileri (İçme Suyu)
struct LicenseSection: View {
    let brand: WaterBrand
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Ruhsat & Kaynak Bilgileri")
                .font(.headline)
                .padding(.horizontal)
            VStack(alignment: .leading, spacing: 4) {
                if let il = brand.il { Text("İl: \(il)") }
                if let ilce = brand.ilce { Text("İlçe: \(ilce)") }
                if let num = brand.numuneAlanBirim { Text("Numune Alan Birim: \(num)") }
                if let analiz = brand.analizYapanBirim { Text("Analiz Yapan: \(analiz)") }
                if let ruhsat = brand.ruhsatNo { Text("Ruhsat No: \(ruhsat)") }
            }
            .font(.subheadline)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
        }
        .padding(.top, 10)
    }
}

// MARK: - License Bilgileri (Maden Suyu)
struct LicenseSectionMineral: View {
    let brand: MineralWaterBrand
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Ruhsat & Kaynak Bilgileri")
                .font(.headline)
                .padding(.horizontal)
            VStack(alignment: .leading, spacing: 4) {
                if let il = brand.il { Text("İl: \(il)") }
                if let ilce = brand.ilce { Text("İlçe: \(ilce)") }
                if let num = brand.numuneAlanBirim { Text("Numune Alan Birim: \(num)") }
                if let analiz = brand.analizYapanBirim { Text("Analiz Yapan: \(analiz)") }
                if let ruhsat = brand.ruhsatNo { Text("Ruhsat No: \(ruhsat)") }
            }
            .font(.subheadline)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
        }
        .padding(.top, 10)
    }
}

// MARK: - Yardımcı Fonksiyonlar
extension Double? {
    func formatted(_ decimals: Int = 1) -> String {
        guard let self else { return "-" }
        return String(format: "%.\(decimals)f", self)
    }
}
