import SwiftUI

struct WaterListView: View {
    @StateObject private var networkManager = NetworkManager()

    var body: some View {
        List(networkManager.waterBrands) { brand in
            NavigationLink(destination: WaterDetailView(brand: brand)) {
                HStack(alignment: .center, spacing: 8) {
                    Image(brand.imageName)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 4) {
                        Text(brand.name)
                            .font(.headline)

                        HStack(spacing: 8) {
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .frame(width: 120, height: 6)
                                    .foregroundColor(Color.gray.opacity(0.3))

                                RoundedRectangle(cornerRadius: 4)
                                    .frame(width: CGFloat(brand.qualityScore) * 1.2, height: 6)
                                    .foregroundColor(brand.qualityColor)
                            }

                            Text("\(brand.qualityScore)/100")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        }
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .listStyle(PlainListStyle())
        .navigationTitle("Su Markaları")
        .onAppear {
            networkManager.fetchLocalWaterBrands()
        }
    }
}
