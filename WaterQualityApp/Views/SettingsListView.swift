import SwiftUI

struct SettingsView: View {
    let items: [SettingItem] = [
        SettingItem(title: "Hakkımızda", destination: AnyView(AboutView())),
        SettingItem(title: "Arkadaşını Davet Et", destination: AnyView(InviteFriendView())),
        SettingItem(title: "Premium", destination: AnyView(PremiumView())),
        SettingItem(title: "Yardım", destination: AnyView(HelpView())),
        SettingItem(title: "Gizlilik", destination: AnyView(PrivacyView())),
        SettingItem(title: "Terms of Service", destination: AnyView(TermsView()))
    ]
    
    var body: some View {
        List(items) { item in
            NavigationLink(destination: item.destination) {
                Text(item.title)
                    .font(.body)
                    .padding(.vertical, 8)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Settings")
    }
}

struct SettingItem: Identifiable {
    let id = UUID()
    let title: String
    let destination: AnyView
}
