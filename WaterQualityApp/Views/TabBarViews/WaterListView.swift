import SwiftUI

struct WaterListView: View {
    @EnvironmentObject var networkManager: NetworkManager
    @EnvironmentObject var session: UserSession
    @State private var selectedTab: Int = 0
    @State private var searchText: String = ""
    @State private var sortDescending: Bool = true
    @Namespace private var animation

    var filteredWaterBrands: [WaterBrand] {
        let filtered = networkManager.waterBrands.filter {
            searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText)
        }
        let sorted = filtered.sorted {
            sortDescending ? $0.qualityScore > $1.qualityScore : $0.qualityScore < $1.qualityScore
        }
        return session.isPremium ? sorted : Array(sorted.prefix(5))
    }

    var filteredMineralBrands: [MineralWaterBrand] {
        let filtered = networkManager.mineralWaterBrands.filter {
            searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText)
        }
        let sorted = filtered.sorted {
            sortDescending ? $0.qualityScore > $1.qualityScore : $0.qualityScore < $1.qualityScore
        }
        return session.isPremium ? sorted : Array(sorted.prefix(5))
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [.cyan.opacity(0.4), .blue.opacity(0.2)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 12) {
                // 🔹 Sekmeli başlık
                HStack(spacing: 0) {
                    AnimatedTabButton(title: "İçme Suları", index: 0, selectedTab: $selectedTab, animation: animation)
                    AnimatedTabButton(title: "Maden Suları", index: 1, selectedTab: $selectedTab, animation: animation)
                }
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
                .padding(.horizontal)
                .padding(.top, 8)

                // 🔹 Arama ve Filtre
                HStack {
                    TextField("Su markası ara...", text: $searchText)
                        .padding(10)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(12)
                        .shadow(radius: 1)

                    Button {
                        sortDescending.toggle()
                    } label: {
                        Image(systemName: sortDescending ? "arrow.down.circle.fill" : "arrow.up.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)

                // 🔹 Liste
                ScrollView {
                    LazyVStack(spacing: 12) {
                        if selectedTab == 0 {
                            ForEach(filteredWaterBrands) { brand in
                                NavigationLink(destination: WaterDetailView(brand: brand).environmentObject(session)) {
                                    WaterListRow(
                                        brandName: brand.name,
                                        imageName: brand.imageName,
                                        score: session.isPremium ? brand.qualityScore : 0,
                                        color: brand.qualityColor,
                                        showScore: session.isPremium
                                    )
                                }
                            }
                        } else {
                            ForEach(filteredMineralBrands) { brand in
                                NavigationLink(destination: MineralWaterDetailView(brand: brand).environmentObject(session)) {
                                    WaterListRow(
                                        brandName: brand.name,
                                        imageName: brand.imageName,
                                        score: session.isPremium ? brand.qualityScore : 0,
                                        color: brand.qualityColor,
                                        showScore: session.isPremium
                                    )
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationTitle("Su Listesi")
        .onAppear {
            networkManager.fetchLocalWaterBrands()
            networkManager.fetchMineralWaterBrands()
        }
    }
}

struct WaterListRow: View {
    let brandName: String
    let imageName: String
    let score: Int
    let color: Color
    let showScore: Bool

    var body: some View {
        HStack(spacing: 14) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 3)

            VStack(alignment: .leading, spacing: 6) {
                Text(brandName)
                    .font(.headline)
                    .foregroundColor(.primary)

                if showScore {
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .frame(height: 6)
                            .foregroundColor(.gray.opacity(0.2))
                        RoundedRectangle(cornerRadius: 4)
                            .frame(width: CGFloat(score), height: 6)
                            .foregroundColor(color)
                    }

                    Text("\(score)/100")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                } else {
                    Text("Puan gizli 🔒")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }

            Spacer()
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}


// MARK: - Sekmeli Buton (HomeView ile aynı)
struct AnimatedTabButton: View {
    let title: String
    let index: Int
    @Binding var selectedTab: Int
    var animation: Namespace.ID

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
                selectedTab = index
            }
        } label: {
            ZStack {
                if selectedTab == index {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .matchedGeometryEffect(id: "TAB_HIGHLIGHT", in: animation)
                        .frame(height: 36)
                        .shadow(color: .white.opacity(0.3), radius: 3)
                }

                Text(title)
                    .font(.headline)
                    .foregroundColor(selectedTab == index ? .blue : .white.opacity(0.8))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
            }
        }
    }
}
