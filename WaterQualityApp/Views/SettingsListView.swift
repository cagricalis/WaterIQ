import SwiftUI

struct SettingsListView: View {
    let settingsItems = ["Hakkımızda", "Arkadaşını Davet Et", "Premium", "Yardım", "Gizlilik", "Terms of Service"]

    var body: some View {
        List {
            ForEach(settingsItems, id: \.self) { item in
                NavigationLink(destination: SettingsDetailView(title: item)) {
                    Text(item)
                        .font(.headline)
                        .padding(.vertical, 6)
                }
            }
        }
        .navigationTitle("Settings")
    }
}
