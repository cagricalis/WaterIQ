import SwiftUI

struct ContentView: View {
    var body: some View {
        MainTabView()  // Artık historyManager veya diğer modelleri buradan geçmeye gerek yok
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
