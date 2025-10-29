//
//  NotificationManager.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 27.10.2025.
//


import UserNotifications

final class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()

    func requestAuthorization() async -> Bool {
        let center = UNUserNotificationCenter.current()
        let granted = try? await center.requestAuthorization(options: [.alert, .sound, .badge])
        center.delegate = self
        return granted ?? false
    }

    func scheduleSmartReminders(wakeStart: Date, wakeEnd: Date, goalML: Int, cupSizeML: Int = 250) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        // Hedefe ulaşmak için yaklaşık kaç içim?
        let count = max(4, min(12, goalML / cupSizeML))
        let interval = (wakeEnd.timeIntervalSince1970 - wakeStart.timeIntervalSince1970) / Double(count)

        for i in 0..<count {
            let fire = wakeStart.addingTimeInterval(Double(i+1) * interval)
            let comps = Calendar.current.dateComponents([.hour, .minute], from: fire)

            var dateComp = DateComponents()
            dateComp.hour = comps.hour
            dateComp.minute = comps.minute

            let content = UNMutableNotificationContent()
            content.title = "Su zamanı 💧"
            content.body = "Hedefine yaklaşmak için bir bardak su iç."
            content.sound = .default

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: true)
            let id = "hydration.\(i)"
            let req = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            center.add(req)
        }
    }
}
