//  HydrationOnboardingView.swift
//  WaterQualityApp

import SwiftUI

struct HydrationOnboardingView: View {
    let onStart: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.white, .hBlue.opacity(0.15)],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer(minLength: 40)

                // illüstrasyon yerine SF Symbol (yer tutucu)
                ZStack {
                    RoundedRectangle(cornerRadius: 32)
                        .fill(Color.hBlue.opacity(0.2))
                        .frame(width: 220, height: 220)
                    Image(systemName: "figure.walk.motion")
                        .font(.system(size: 90, weight: .thin))
                        .foregroundColor(.hNavy)
                }
                .shadow(color: .hBlue.opacity(0.2), radius: 10, y: 6)

                Text("Stay hydrated")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(.hNavy)

                Text("Track your daily water intake with just a few taps!")
                    .font(.body)
                    .foregroundColor(.hNavy.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 36)

                Spacer()

                Button {
                    onStart()
                } label: {
                    Text("Get Started")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.hNavy)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .hNavy.opacity(0.35), radius: 8, y: 5)
                }
                .padding(.horizontal)

                Button {
                    onStart()
                } label: {
                    Text("Already joined? Log in here")
                        .font(.footnote)
                        .foregroundColor(.hNavy.opacity(0.8))
                        .underline()
                }

                Spacer(minLength: 30)
            }
        }
    }
}
