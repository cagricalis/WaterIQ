import SwiftUI

struct HomeView: View {
    @EnvironmentObject var cameraModel: CameraModel
    @EnvironmentObject var networkManager: NetworkManager
    @EnvironmentObject var historyManager: HistoryManager

    var body: some View {
        VStack(alignment: .leading) {
            Text("Waters")
                .font(.title2)
                .bold()
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(networkManager.waterBrands) { brand in
                        NavigationLink(destination: WaterDetailView(brand: brand)) {
                            VStack(alignment: .leading, spacing: 8) {
                                Image(brand.imageName)
                                    .resizable()
                                    .frame(width: 120, height: 120)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                Text(brand.name).font(.headline)
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(width: 120, height: 8)
                                        .foregroundColor(Color.gray.opacity(0.3))
                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(width: CGFloat(brand.qualityScore) * 1.2, height: 8)
                                        .foregroundColor(brand.qualityColor)
                                    Text("\(brand.qualityScore)/100")
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                        .frame(width: 120, alignment: .center)
                                        .offset(y: -14)
                                }
                            }
                            .frame(width: 140)
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 180)

            NavigationLink(destination: EmbeddedScannerView()) {
                VStack(spacing: 8) {
                    Image(systemName: "qrcode.viewfinder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.blue)
                    Text("Scan Barcode")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                .frame(width: 150, height: 150)
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .shadow(radius: 4)
                .padding(.top, 20)
                .padding(.horizontal)
            }

            Spacer()
        }
        .onAppear { networkManager.fetchLocalWaterBrands() }
        .navigationTitle("Home")
    }
}
