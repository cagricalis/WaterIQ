import SwiftUI

struct FeatureGate<Content: View>: View {
    @EnvironmentObject var session: UserSession
    let requiredPlan: UserPlan
    let content: () -> Content

    init(requiredPlan: UserPlan, @ViewBuilder content: @escaping () -> Content) {
        self.requiredPlan = requiredPlan
        self.content = content
    }

    var body: some View {
        if session.plan == requiredPlan {
            content()
        } else {
            VStack(spacing: 10) {
                Image(systemName: "lock.fill")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
                Text("Bu özellik yalnızca Premium kullanıcılar içindir.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                NavigationLink(destination: PaywallView().environmentObject(session)) {
                    Text("Premium’a Geç")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .padding()
        }
    }
}
