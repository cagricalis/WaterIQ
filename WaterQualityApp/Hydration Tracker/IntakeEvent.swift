//
//  IntakeEvent.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 27.10.2025.
//


import Foundation
import CoreData

@objc(IntakeEvent)
public class IntakeEvent: NSManagedObject {}

extension IntakeEvent {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<IntakeEvent> {
        return NSFetchRequest<IntakeEvent>(entityName: "IntakeEvent")
    }

    @NSManaged public var id: UUID
    @NSManaged public var date: Date
    @NSManaged public var amountML: Int32
    @NSManaged public var source: String?
}

@objc(UserProfile)
public class UserProfile: NSManagedObject {}

extension UserProfile {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserProfile> {
        return NSFetchRequest<UserProfile>(entityName: "UserProfile")
    }

    @NSManaged public var id: UUID
    @NSManaged public var weightKg: Double
    @NSManaged public var heightCm: Double
    @NSManaged public var activityRaw: Int16
    @NSManaged public var goalML: Int32
    @NSManaged public var wakeStart: Date?
    @NSManaged public var wakeEnd: Date?
    @NSManaged public var useCloudKit: Bool
    @NSManaged public var healthKitEnabled: Bool
}
