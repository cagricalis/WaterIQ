import Foundation
import FirebaseAuth
import FirebaseFirestore

enum UserPlan: String, Codable {
    case free, premium
}

@MainActor
final class UserSession: ObservableObject {
    @Published var user: User?
    @Published var plan: UserPlan = .free
    var isPremium: Bool { plan == .premium }

    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    init() {
        if let currentUser = Auth.auth().currentUser {
            self.user = currentUser
            attachLivePlanListener(uid: currentUser.uid)
        }
    }

    // MARK: - SIGN UP (Email Verification ile)
    func signUp(email: String, password: String, completion: @escaping (String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(error.localizedDescription)
                return
            }

            guard let user = result?.user else {
                completion("Kullanıcı oluşturulamadı")
                return
            }

            // Doğrulama e-postası gönder
            user.sendEmailVerification { err in
                if let err = err {
                    completion("Doğrulama e-postası gönderilemedi: \(err.localizedDescription)")
                } else {
                    // Doğrulama bekleniyor — kullanıcı henüz giriş yapmasın
                    completion(nil)
                }
            }

            // Firestore dokümanı oluştur
            self.createUserDocIfNeeded(uid: user.uid)
        }
    }

    // MARK: - LOGIN (Email doğrulaması kontrolü ile)
    func signIn(email: String, password: String, completion: @escaping (String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(error.localizedDescription)
                return
            }

            guard let user = result?.user else {
                completion("Giriş başarısız")
                return
            }

            // E-posta doğrulanmamışsa izin verme
            if !user.isEmailVerified {
                try? Auth.auth().signOut()
                completion("Lütfen e-posta adresinizi doğrulayın.")
                return
            }

            Task { @MainActor in
                self.user = user
                self.attachLivePlanListener(uid: user.uid)
                completion(nil)
            }
        }
    }

    // MARK: - LOGOUT
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
            self.plan = .free
        } catch {
            print("SignOut error:", error.localizedDescription)
        }
    }

    // MARK: - PLAN TAKİBİ
    private func createUserDocIfNeeded(uid: String) {
        let ref = db.collection("users").document(uid)
        ref.getDocument { doc, _ in
            if (doc?.exists ?? false) == false {
                ref.setData(["plan": "free", "createdAt": FieldValue.serverTimestamp()])
            }
        }
    }

    private func attachLivePlanListener(uid: String) {
        listener?.remove()
        listener = db.collection("users").document(uid)
            .addSnapshotListener { [weak self] snap, _ in
                guard let self, let data = snap?.data() else { return }
                Task { @MainActor in
                    let planStr = data["plan"] as? String ?? "free"
                    self.plan = UserPlan(rawValue: planStr) ?? .free
                }
            }
    }

    // MARK: - Premium işlemleri
    func upgradeToPremium() {
        guard let uid = user?.uid else { return }
        Task { @MainActor in
            self.plan = .premium
            try? await db.collection("users").document(uid).setData(["plan": "premium"], merge: true)
        }
    }

    func downgradeToFree() {
        guard let uid = user?.uid else { return }
        Task { @MainActor in
            self.plan = .free
            try? await db.collection("users").document(uid).setData(["plan": "free"], merge: true)
        }
    }
}

extension UserSession {
    func sendEmailVerificationIfNeeded(completion: @escaping (Error?) -> Void) {
        if let user = Auth.auth().currentUser, !user.isEmailVerified {
            user.sendEmailVerification(completion: completion)
        } else {
            completion(nil)
        }
    }
}
