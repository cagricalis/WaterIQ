import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var historyManager: HistoryManager

    var body: some View {
        List {
            ForEach(historyManager.historyList.reversed()) { brand in
                NavigationLink(destination: WaterDetailView(brand: brand)) {
                    HStack {
                        Image(brand.imageName)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        Text(brand.name)
                            .font(.headline)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("History")
    }
}
