//
//  HydrationTodayView.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 28.10.2025.
//

import SwiftUI

struct HydrationTodayView: View {
    @ObservedObject var viewModel: HydrationViewModel

    @State private var showAddPopup = false
    @State private var animateBottle = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [.hBackground, .hSoftBlue],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 25) {

                // MARK: - Üst Başlık Dalgalı Kart
                WaveHeaderView(
                    title: "Günlük Su Takibi",
                    goalML: viewModel.goalML,
                    completedPercent: viewModel.progressPercent(),
                    subtitle: progressText()
                )
                .padding(.horizontal)

                // MARK: - Şişe + İlerleme Göstergesi
                VStack(spacing: 20) {
                    ZStack {
                        // 🔹 Animasyonlu SwiftUI su şişesi
                        WaterBottleView(
                            level: CGFloat(viewModel.progressPercent()),
                            height: 250
                        )
                        .scaleEffect(animateBottle ? 1.02 : 0.98)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                                   value: animateBottle)

                        VStack(spacing: 6) {
                            Text("\(viewModel.todayML) / \(viewModel.goalML) ml")
                                .font(.title3.bold())
                                .foregroundColor(.hNavy)
                            Text("\(Int(viewModel.progressPercent() * 100))%")
                                .font(.largeTitle.bold())
                                .foregroundColor(.hBlue)
                        }
                        .offset(y: 180)
                    }

                    // MARK: - Hızlı Ekleme Butonları
                    HStack(spacing: 20) {
                        ForEach(viewModel.quickOptions, id: \.self) { ml in
                            Button("+\(ml) ml") {
                                Task {
                                    await viewModel.addIntake(ml: ml, source: "quick")
                                    triggerBottleAnimation()
                                }
                            }
                            .buttonStyle(HydrationButtonStyle())
                        }
                    }

                    // MARK: - Manuel Giriş Butonu
                    Button {
                        showAddPopup.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Miktar Ekle")
                                .font(.headline)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(colors: [.hBlue, .hNavy],
                                                   startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .shadow(color: .hBlue.opacity(0.3), radius: 6, y: 4)
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 10)

                Spacer()
            }
        }
        .onAppear {
            withAnimation {
                animateBottle = true
            }
        }
        .sheet(isPresented: $showAddPopup) {
            AddWaterPopup(viewModel: viewModel)
                .presentationDetents([.fraction(0.35)])
        }
    }

    // MARK: - Duruma Göre Alt Metin
    private func progressText() -> String {
        switch viewModel.progressPercent() {
        case 0..<0.3: return "Hadi başlayalım 💧"
        case 0.3..<0.6: return "İyi gidiyorsun 👏"
        case 0.6..<0.9: return "Neredeyse bitti 🚀"
        default: return "Mükemmel 💙"
        }
    }

    // MARK: - Şişe “nefes” animasyonu tetikle
    private func triggerBottleAnimation() {
        animateBottle = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            animateBottle = true
        }
    }
}

// MARK: - Özel Buton Stili
struct HydrationButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding()
            .frame(width: 100)
            .background(configuration.isPressed ?
                        Color.hBlue.opacity(0.7) :
                        Color.hBlue)
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(color: .hBlue.opacity(0.25), radius: 6, y: 4)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Su Miktarı Ekleme Popup
struct AddWaterPopup: View {
    @ObservedObject var viewModel: HydrationViewModel
    @State private var selectedAmount: Double = 250

    var body: some View {
        VStack(spacing: 24) {
            Text("Ne kadar içtin?")
                .font(.title3.bold())
                .foregroundColor(.hNavy)

            Slider(value: $selectedAmount, in: 50...1000, step: 50)
                .accentColor(.hBlue)

            Text("\(Int(selectedAmount)) ml")
                .font(.headline)
                .foregroundColor(.hBlue)

            Button("Ekle") {
                Task {
                    await viewModel.addIntake(ml: Int(selectedAmount), source: "manual")
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(.hBlue)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .padding()
    }
}
