//
//  PersistentContainer.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 14.04.2024.
//

import Foundation
import CoreData

protocol PersistentContainerProtocol {
	var mainContext: NSManagedObjectContext { get }
}

final class PersistentContainer {

	static var shared = PersistentContainer()

	let container: NSPersistentCloudKitContainer

	// MARK: - Initialization

	private init(inMemory: Bool = false) {
		container = NSPersistentCloudKitContainer(name: "Plan")
		if inMemory {
			container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
		}
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error {
				// Replace this implementation with code to handle the error appropriately.
				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

				/*
				 Typical reasons for an error here include:
				 * The parent directory does not exist, cannot be created, or disallows writing.
				 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
				 * The device is out of space.
				 * The store could not be migrated to the current model version.
				 Check the error message to determine what the actual problem was.
				 */
				fatalError("Unresolved error \(error)")
			}
		})

		guard let description = container.persistentStoreDescriptions.first else {
			fatalError("###\(#function): Failed to retrieve a persistent store description.")
		}

		description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
		description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
		container.viewContext.automaticallyMergesChangesFromParent = true
	}
}

// MARK: - PersistentContainerProtocol
extension PersistentContainer: PersistentContainerProtocol {

	var mainContext: NSManagedObjectContext {
		container.viewContext
	}
}
