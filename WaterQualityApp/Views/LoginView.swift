import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @EnvironmentObject var session: UserSession
    @StateObject private var keyboard = KeyboardObserver()

    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?

    @State private var showSuccessSplash = false   // ✅ splash kontrol

    var logoScale: CGFloat { keyboard.keyboardHeight > 0 ? 0.75 : 1.0 }

    var body: some View {
        NavigationStack {
            ZStack {
                AnimatedBackground()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {
                        // Logo + Başlık
                        VStack(spacing: 8) {
                            Image("wateriq_logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100 * logoScale, height: 100 * logoScale)
                                .shadow(radius: 6)
                                .animation(.spring(response: 0.5, dampingFraction: 0.7),
                                           value: keyboard.keyboardHeight)
                            AnimatedLogoTitle(scale: logoScale)
                        }
                        .padding(.top, 80)

                        // Giriş Kartı
                        VStack(spacing: 20) {
                            GlassTextField(placeholder: "E-posta", text: $email, systemImage: "envelope.fill")
                            GlassSecureField(placeholder: "Şifre", text: $password, systemImage: "lock.fill")

                            if let error = errorMessage {
                                Text(error)
                                    .font(.footnote)
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.center)
                            }

                            Button {
                                signIn()
                            } label: {
                                Text("Giriş Yap")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(LinearGradient(colors: [.blue, .cyan],
                                                               startPoint: .leading,
                                                               endPoint: .trailing))
                                    .foregroundColor(.white)
                                    .cornerRadius(14)
                                    .shadow(color: .cyan.opacity(0.5), radius: 5, y: 4)
                            }
                            .padding(.top, 10)

                            // Şifre Sıfırlama
                            Button("Şifremi Unuttum") {
                                resetPassword()
                            }
                            .font(.footnote)
                            .foregroundColor(.white.opacity(0.9))
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                        .padding(.horizontal)

                        // Kayıt Ol Linki
                        HStack(spacing: 4) {
                            Text("Hesabın yok mu?")
                                .foregroundColor(.white.opacity(0.8))
                            NavigationLink {
                                SignUpView().toolbar(.hidden, for: .navigationBar)
                            } label: {
                                Text("Kayıt ol")
                                    .foregroundColor(.white)
                                    .underline()
                            }
                        }

                        Spacer()
                    }
                    .padding(.bottom, keyboard.keyboardHeight + 40)
                    .animation(.easeOut(duration: 0.25), value: keyboard.keyboardHeight)
                }
            }
            .hideKeyboardOnTap()
            .ignoresSafeArea(edges: .bottom)
            .fullScreenCover(isPresented: $showSuccessSplash) { // ✅ Splash göster
                SuccessSplashView {
                    // ✅ Splash bittikten sonra ana uygulamaya geçiş
                    // session.user set edilince app zaten MainTabView’a geçecek
                    if let current = Auth.auth().currentUser {
                        session.user = current
                    }
                }
            }
        }
    }

    // MARK: - Giriş
    private func signIn() {
        errorMessage = nil

        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
                return
            }

            guard let user = result?.user else { return }

            user.reload { _ in
                if user.isEmailVerified {
                    // ✅ Metin yerine splash animasyon
                    showSuccessSplash = true
                } else {
                    errorMessage = "Lütfen e-posta adresini doğrula."
                    try? Auth.auth().signOut()
                }
            }
        }
    }

    // MARK: - Şifre sıfırlama
    private func resetPassword() {
        guard !email.isEmpty else {
            errorMessage = "Lütfen e-posta adresini gir."
            return
        }
        Auth.auth().sendPasswordReset(withEmail: email) { err in
            errorMessage = err?.localizedDescription ?? "🔑 Şifre sıfırlama bağlantısı e-postana gönderildi."
        }
    }
}
