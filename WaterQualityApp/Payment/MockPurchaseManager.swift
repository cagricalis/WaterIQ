import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
final class MockPurchaseManager: ObservableObject {
    @Published var isPremium = false

    func loadProducts() async {
        // Mock: gerçek StoreKit ürünleri burada yüklenecek
    }

    func purchasePremium(userSession: UserSession) async {
        // Simülasyon: premium aktif et
        isPremium = true
        guard let uid = userSession.user?.uid else { return }
        try? await Firestore.firestore()
            .collection("users")
            .document(uid)
            .setData(["plan": "premium"], merge: true)

        userSession.plan = .premium
    }

    func restorePurchases(userSession: UserSession) async {
        // Fake restore
        isPremium = true
        userSession.plan = .premium
    }

    func resetToFree(userSession: UserSession) async {
        isPremium = false
        guard let uid = userSession.user?.uid else { return }
        try? await Firestore.firestore()
            .collection("users")
            .document(uid)
            .setData(["plan": "free"], merge: true)
        userSession.plan = .free
    }
}
