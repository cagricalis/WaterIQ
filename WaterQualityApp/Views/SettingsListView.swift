import SwiftUI

struct SettingsListView: View {
    @EnvironmentObject var session: UserSession

    var body: some View {
        List {
            Section(header: Text("Hesap")) {
                HStack {
                    Text("Plan:")
                    Spacer()
                    Text(session.plan == .premium ? "⭐️ Premium" : "🔓 Free")
                        .foregroundColor(session.plan == .premium ? .yellow : .gray)
                }
            }
            Section {
                Button("Çıkış Yap") {
                    session.signOut()
                }
                .foregroundColor(.red)
            }


            Section(header: Text("Uygulama")) {
                NavigationLink("Hakkımızda", destination: Text("DIGIT Bilişim – WaterIQ Projesi"))
                NavigationLink("Arkadaşını Davet Et", destination: Text("Yakında aktif olacak"))
                
                NavigationLink("Premium", destination: PaywallView()
                    .environmentObject(session))
                
                NavigationLink("Yardım", destination: Text("Destek için: support@wateriq.app"))
                NavigationLink("Gizlilik", destination: Text("Verileriniz gizlidir."))
                NavigationLink("Terms of Service", destination: Text("Kullanım koşulları yakında."))
            }
        }
        .navigationTitle("Ayarlar")
    }
}


