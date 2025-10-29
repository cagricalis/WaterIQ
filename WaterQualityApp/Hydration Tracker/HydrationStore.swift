//
//  HydrationStore.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 27.10.2025.
//

import CoreData

final class HydrationStore {
    let ctx: NSManagedObjectContext
    init(ctx: NSManagedObjectContext) { self.ctx = ctx }

    // MARK: - Su ekleme
    func addIntake(ml: Int, source: String = "manual", at date: Date = Date()) throws {
        let e = IntakeEvent(context: ctx)
        e.id = UUID()
        e.date = date
        e.amountML = Int32(ml)
        e.source = source
        try ctx.save()
    }

    // MARK: - Günlük toplam (bugün)
    func todayTotalML() throws -> Int {
        let req: NSFetchRequest<IntakeEvent> = IntakeEvent.fetchRequest()
        let cal = Calendar.current
        let start = cal.startOfDay(for: Date())
        let end = cal.date(byAdding: .day, value: 1, to: start)!
        req.predicate = NSPredicate(format: "date >= %@ AND date < %@", start as NSDate, end as NSDate)
        let events = try ctx.fetch(req)
        return events.reduce(0) { $0 + Int($1.amountML) }
    }

    // MARK: - Belirli gün aralığındaki toplamlar
    func rangeTotals(daySpan: Int) throws -> [(date: Date, ml: Int)] {
        let cal = Calendar.current
        let end = cal.startOfDay(for: Date().addingTimeInterval(24*60*60))
        let start = cal.date(byAdding: .day, value: -daySpan, to: end)!
        let req: NSFetchRequest<IntakeEvent> = IntakeEvent.fetchRequest()
        req.predicate = NSPredicate(format: "date >= %@ AND date < %@", start as NSDate, end as NSDate)
        let events = try ctx.fetch(req)

        var dict: [Date: Int] = [:]
        for e in events {
            let d = cal.startOfDay(for: e.date)
            dict[d, default: 0] += Int(e.amountML)
        }

        // 🔹 Tüm günleri doldur (eksik günlerde 0 ml olacak)
        var out: [(date: Date, ml: Int)] = []
        for i in 0..<daySpan {
            let d = cal.date(byAdding: .day, value: i, to: cal.startOfDay(for: start))!
            out.append((date: d, ml: dict[d, default: 0]))
        }
        return out
    }

    // MARK: - Profil oluştur / getir
    func ensureProfile() throws -> UserProfile {
        let req: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        if let p = try ctx.fetch(req).first { return p }

        let p = UserProfile(context: ctx)
        p.id = UUID()
        p.weightKg = 70
        p.heightCm = 175
        p.activityRaw = Int16(ActivityLevel.medium.rawValue)
        p.goalML = Int32(GoalCalculator.recommendedGoalML(weightKg: 70, heightCm: 175, activity: .medium))
        p.wakeStart = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date())
        p.wakeEnd = Calendar.current.date(bySettingHour: 23, minute: 0, second: 0, of: Date())
        p.healthKitEnabled = false
        p.useCloudKit = true
        try ctx.save()
        return p
    }

    // MARK: - Profili kaydet
    func saveProfile(_ p: UserProfile) throws {
        try ctx.save()
    }
}
