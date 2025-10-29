//
//  PersistenceController.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 27.10.2025.
//


import CoreData

final class PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false, useCloudKit: Bool = true) {
        container = NSPersistentCloudKitContainer(name: "HydrationModel")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        if useCloudKit == false {
            // CloudKit’i kapat
            if let desc = container.persistentStoreDescriptions.first {
                desc.cloudKitContainerOptions = nil
            }
        } else {
            container.persistentStoreDescriptions.first?.setOption(true as NSNumber,
                                                                 forKey: NSPersistentHistoryTrackingKey)
            container.persistentStoreDescriptions.first?.setOption(true as NSNumber,
                                                                 forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        }
        container.loadPersistentStores { _, error in
            if let error = error { fatalError("Unresolved error \(error)") }
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            self.container.viewContext.automaticallyMergesChangesFromParent = true
        }
    }
}
