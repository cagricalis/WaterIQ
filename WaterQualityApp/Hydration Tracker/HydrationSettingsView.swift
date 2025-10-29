//
//  HydrationSettingsView.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 28.10.2025.
//

import SwiftUI

struct HydrationSettingsView: View {
    @StateObject private var vm = HydrationViewModel(ctx: PersistenceController.shared.container.viewContext)
    @EnvironmentObject var appModeManager: AppModeManager

    @State private var weight: Double = 70
    @State private var height: Double = 175
    @State private var activity: ActivityLevel = .medium
    @State private var wakeStart = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!
    @State private var wakeEnd = Calendar.current.date(bySettingHour: 23, minute: 0, second: 0, of: Date())!
    @State private var healthKitEnabled = false

    var body: some View {
        ZStack {
            // MARK: - Background
            LinearGradient(colors: [.hBackground, .hSoftBlue],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {

                    // MARK: - Header
                    VStack(spacing: 8) {
                        Text("Ayarlar ⚙️")
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                            .foregroundColor(.hNavy)
                        Text("Profilini düzenle, hedefini belirle ve hatırlatıcıları yönet")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 20)

                    // MARK: - Profil Kartı
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Profil Bilgileri")
                            .font(.headline)
                            .foregroundColor(.hNavy)

                        Stepper(value: $weight, in: 30...200, step: 1) {
                            Text("Kilo: \(Int(weight)) kg")
                                .font(.body)
                        }
                        Stepper(value: $height, in: 120...220, step: 1) {
                            Text("Boy: \(Int(height)) cm")
                                .font(.body)
                        }

                        Picker("Aktivite Seviyesi", selection: $activity) {
                            ForEach(ActivityLevel.allCases) { level in
                                Text(level.label).tag(level)
                            }
                        }
                        .pickerStyle(.segmented)

                        Button("Hedefi Güncelle") {
                            Task { await vm.recalcGoal(weight: weight, height: height, activity: activity) }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.hBlue)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .shadow(color: .hBlue.opacity(0.1), radius: 6, y: 3)
                    .padding(.horizontal)

                    // MARK: - Hatırlatıcı Kartı
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Hatırlatıcılar ⏰")
                            .font(.headline)
                            .foregroundColor(.hNavy)

                        DatePicker("Gün Başlangıcı", selection: $wakeStart, displayedComponents: .hourAndMinute)
                        DatePicker("Gün Sonu", selection: $wakeEnd, displayedComponents: .hourAndMinute)

                        Button("Akıllı Hatırlatıcıları Planla") {
                            NotificationManager.shared.scheduleSmartReminders(
                                wakeStart: wakeStart,
                                wakeEnd: wakeEnd,
                                goalML: vm.goalML
                            )
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.hNavy)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .shadow(color: .hBlue.opacity(0.1), radius: 6, y: 3)
                    .padding(.horizontal)

                    // MARK: - HealthKit Kartı
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Apple Health Entegrasyonu 🍎")
                            .font(.headline)
                            .foregroundColor(.hNavy)

                        Toggle("HealthKit Aktif", isOn: $healthKitEnabled)
                            .tint(.hBlue)
                            .onChange(of: healthKitEnabled) { enabled in
                                Task {
                                    if enabled { try? await HealthKitManager.shared.requestAuthorization() }
                                    vm.profile?.healthKitEnabled = enabled
                                    try? PersistenceController.shared.container.viewContext.save()
                                }
                            }

                        Text("Etkinleştirildiğinde, su alımı Apple Sağlık uygulamasıyla senkronize edilir.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .shadow(color: .hBlue.opacity(0.1), radius: 6, y: 3)
                    .padding(.horizontal)

                    // MARK: - WaterIQ'ya Dön Butonu
                    Button {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            appModeManager.currentMode = .mainApp
                        }
                    } label: {
                        HStack {
                            Image(systemName: "arrow.left.circle.fill")
                            Text("WaterIQ Uygulamasına Dön")
                        }
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(colors: [.hBlue, .hNavy],
                                           startPoint: .leading,
                                           endPoint: .trailing)
                        )
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .shadow(color: .hBlue.opacity(0.3), radius: 6, y: 3)
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .task {
            await vm.load()
            if let p = vm.profile {
                weight = p.weightKg
                height = p.heightCm
                activity = ActivityLevel(rawValue: Int(p.activityRaw)) ?? .medium
                healthKitEnabled = p.healthKitEnabled
                if let s = p.wakeStart { wakeStart = s }
                if let e = p.wakeEnd { wakeEnd = e }
            }
        }
    }
}
