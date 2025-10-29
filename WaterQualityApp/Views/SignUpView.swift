import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @EnvironmentObject var session: UserSession
    @StateObject private var keyboard = KeyboardObserver()

    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var isLoading = false
    @State private var goToWaiting = false      // ✅ bekleme ekranına geçiş

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

                        // Form Kartı
                        VStack(spacing: 20) {
                            GlassTextField(placeholder: "E-posta", text: $email, systemImage: "envelope.fill")
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled(true)

                            GlassSecureField(placeholder: "Şifre", text: $password, systemImage: "lock.fill")

                            if let error = errorMessage {
                                Text(error)
                                    .font(.footnote)
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.center)
                            }

                            Button {
                                signUp()
                            } label: {
                                HStack {
                                    if isLoading { ProgressView().tint(.white) }
                                    Text("Kayıt Ol").font(.headline)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(LinearGradient(colors: [.teal, .blue],
                                                           startPoint: .leading,
                                                           endPoint: .trailing))
                                .foregroundColor(.white)
                                .cornerRadius(14)
                                .shadow(color: .blue.opacity(0.4), radius: 5, y: 4)
                            }
                            .disabled(isLoading)
                            .padding(.top, 10)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                        .padding(.horizontal)

                        // Login Link
                        NavigationLink {
                            LoginView()
                                .toolbar(.hidden, for: .navigationBar)
                        } label: {
                            Text("Zaten hesabın var mı? Giriş yap")
                                .foregroundColor(.white)
                                .font(.subheadline)
                                .underline()
                        }

                        // ✅ Bekleme ekranına otomatik geçiş
                        NavigationLink(isActive: $goToWaiting) {
                            VerificationWaitingView(registeredEmail: email)
                                .toolbar(.hidden, for: .navigationBar)
                        } label: { EmptyView() }

                        Spacer()
                    }
                    .padding(.bottom, keyboard.keyboardHeight + 40)
                    .animation(.easeOut(duration: 0.25), value: keyboard.keyboardHeight)
                }
            }
            .hideKeyboardOnTap()
            .ignoresSafeArea(edges: .bottom)
        }
    }

    // MARK: - Firebase SignUp
   
    private func signUp() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Lütfen e-posta ve şifre gir."
            return
        }

        isLoading = true
        errorMessage = nil

        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            isLoading = false

            if let error = error {
                self.errorMessage = error.localizedDescription
                print("🚫 SignUp error:", error.localizedDescription)
                return
            }

            guard let user = result?.user else {
                self.errorMessage = "Kullanıcı oluşturulamadı."
                return
            }

            // ✅ ÖNEMLİ: ÇIKIŞ YAPMIYORUZ. currentUser açık kalsın ki bekleme ekranı poll edebilsin.
            user.sendEmailVerification { err in
                if let err = err {
                    self.errorMessage = "Mail gönderimi başarısız: \(err.localizedDescription)"
                } else {
                    print("✅ Doğrulama maili gönderildi.")
                    // Doğrulanana kadar ana uygulamaya geçmiyoruz.
                    // session.user'ı BİLE SET ETMİYORUZ; bekleme ekranı açılıyor:
                    self.goToWaiting = true
                }
            }
        }
    }

}
