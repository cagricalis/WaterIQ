//
//  VerificationWaitingView.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 28.10.2025.
//

import SwiftUI
import FirebaseAuth
import Combine

struct VerificationWaitingView: View {
    @EnvironmentObject var session: UserSession
    @Environment(\.openURL) private var openURL

    /// Kayıt sırasında girilen e-posta (bilgilendirme metni için)
    let registeredEmail: String

    @State private var isChecking = true
    @State private var errorMessage: String?
    @State private var infoText: String = "Doğrulama e-postasını gönderdik."
    @State private var resendCooldown: Int = 0

    private let pollInterval: TimeInterval = 3.0
    @State private var timerCancellable: AnyCancellable?

    var body: some View {
        ZStack {
            AnimatedBackground()

            VStack(spacing: 20) {
                Image(systemName: "envelope.circle.fill")
                    .font(.system(size: 72))
                    .foregroundColor(.white)
                    .shadow(radius: 8)

                Text("E-postanı Doğrula")
                    .font(.title2.bold())
                    .foregroundColor(.white)

                Text("Lütfen \(registeredEmail) adresine gönderdiğimiz bağlantıya tıkla. Doğrulandığında otomatik olarak WaterIQ’a geçeceğiz.")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                if let error = errorMessage {
                    Text(error)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .transition(.opacity)
                }

                if isChecking {
                    ProgressView()
                        .tint(.white)
                        .padding(.top, 6)
                }

                // Eğer beklenmedik şekilde currentUser nil ise Login'e dönme seçeneği sun
                if Auth.auth().currentUser == nil {
                    NavigationLink {
                        LoginView().toolbar(.hidden, for: .navigationBar)
                    } label: {
                        Text("Giriş Yap")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.white.opacity(0.25))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }

                VStack(spacing: 12) {
                    Button {
                        // Varsayılan mail uygulamasını açmayı dene (Apple Mail için)
                        if let url = URL(string: "message://") {
                            openURL(url)
                        }
                    } label: {
                        Label("Mail Uygulamasını Aç", systemImage: "mail.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.white.opacity(0.2))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }

                    Button {
                        resendVerification()
                    } label: {
                        Label(resendCooldown > 0 ? "Tekrar gönder ( \(resendCooldown)s )"
                                                 : "Doğrulama E-postasını Tekrar Gönder",
                              systemImage: "paperplane.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(resendCooldown > 0 ? .gray.opacity(0.3) : .white.opacity(0.25))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .disabled(resendCooldown > 0)

                    Button(role: .cancel) {
                        try? Auth.auth().signOut()
                        session.user = nil
                    } label: {
                        Text("Farklı hesapla giriş yap")
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(.top, 6)
                }
                .padding(.horizontal)

                Spacer(minLength: 12)

                Text(infoText)
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding()
        }
        .onAppear {
            infoText = "Doğrulama e-postasını \(DateFormatter.localizedString(from: .now, dateStyle: .none, timeStyle: .short))’te gönderdik."
            startAutoCheck()
            observeForeground()
            startResendCooldown(30) // ilk ekranda 30 sn cooldown
        }
        .onDisappear {
            timerCancellable?.cancel()
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    // MARK: - Otomatik kontrol (polling)
    private func startAutoCheck() {
        // Her pollInterval saniyede bir kullanıcıyı yeniler, verified olduysa ana ekrana geçer
        timerCancellable = Timer.publish(every: pollInterval, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                guard let current = Auth.auth().currentUser else { return }
                current.reload { _ in
                    if current.isEmailVerified {
                        isChecking = false
                        timerCancellable?.cancel()
                        // Otomatik giriş / ana uygulamaya geçiş
                        session.user = current
                        print("✅ E-posta doğrulandı, ana sayfaya geçiliyor.")
                    }
                }
            }
    }

    // MARK: - Uygulama öne gelince yeniden kontrol (kullanıcı mailden döndüyse)
    private func observeForeground() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: .main
        ) { _ in
            guard let current = Auth.auth().currentUser else { return }
            current.reload { _ in
                if current.isEmailVerified {
                    isChecking = false
                    timerCancellable?.cancel()
                    session.user = current
                    print("✅ (foreground) doğrulandı, ana sayfaya geçiliyor.")
                }
            }
        }
    }

    // MARK: - Doğrulama e-postasını tekrar gönder
    private func resendVerification() {
        guard let user = Auth.auth().currentUser else {
            errorMessage = "Oturum bulunamadı. Lütfen giriş yap."
            return
        }
        user.sendEmailVerification { err in
            if let err = err {
                errorMessage = "Tekrar gönderilemedi: \(err.localizedDescription)"
            } else {
                infoText = "Doğrulama e-postasını tekrar gönderdik."
                startResendCooldown(30)
            }
        }
    }

    // MARK: - Cooldown sayacı
    private func startResendCooldown(_ seconds: Int) {
        resendCooldown = seconds
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
            resendCooldown -= 1
            if resendCooldown <= 0 { t.invalidate() }
        }
    }
}
