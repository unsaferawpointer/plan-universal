//
//  DataStorage.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 17.04.2024.
//

import Foundation
import CoreData

final class DataStorage {

	var context: NSManagedObjectContext

	// MARK: - Initialization

	init(context: NSManagedObjectContext = PersistentContainer.shared.mainContext) {
		self.context = context
	}
}

// MARK: - DataStorageProtocol
extension DataStorage: DataStorageProtocol {

	func update(_ todo: TodoEntity, with configuration: TodoConfiguration) {
		todo.configuration = configuration
	}
	
	func update(_ list: ListEntity, with configuration: ListConfiguration) {
		list.configuration = configuration
	}

	func deleteLists(_ lists: [ListEntity]) {
		for list in lists {
			context.delete(list)
		}
	}

	func insertList(_ configuration: ListConfiguration) -> ListEntity {
		return ListEntity(configuration, in: context)
	}

	func insertTodo(_ configuration: TodoConfiguration) -> TodoEntity {
		return TodoEntity(configuration, in: context)
	}

	func deleteTodos(_ todos: [TodoEntity]) {
		for todo in todos {
			context.delete(todo)
		}
	}

	func setStatus(_ status: TodoStatus, for todos: [TodoEntity]) {
		for todo in todos {
			todo.status = status
		}
	}

	func setPriority(_ priority: TodoPriority, for todos: [TodoEntity]) {
		for todo in todos {
			todo.priority = priority
		}
	}

	func save() throws {
		guard context.hasChanges else {
			return
		}
		try context.save()
	}
}
