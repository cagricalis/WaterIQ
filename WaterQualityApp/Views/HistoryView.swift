import SwiftUI

struct HistoryListView: View {
    @ObservedObject var historyManager: HistoryManager = .shared

    var body: some View {
        NavigationStack {
            List(historyManager.scannedBrands) { brand in
                NavigationLink(destination: WaterDetailView(brand: brand)) {
                    HStack {
                        Image(brand.imageName)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        Text(brand.name)
                            .font(.headline)
                    }
                }
            }
            .navigationTitle("History")
        }
    }
}
