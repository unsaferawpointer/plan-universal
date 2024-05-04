//
//  DataManager.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 24.04.2024.
//

import Foundation
import SwiftData

protocol DataManagerProtocol {

	func insert(_ configuration: TodoConfiguration, in context: ModelContext)
	func insert(_ configuration: ListConfiguration, in context: ModelContext)

	func delete(_ todo: TodoItem, in context: ModelContext)
	func delete(_ todos: [TodoItem], in context: ModelContext)
	func delete(_ list: ListItem, in context: ModelContext)

	func update<Item: PersistentModel, T>(_ item: Item, keyPath: ReferenceWritableKeyPath<Item, T>, value: T)

}

final class DataManager {

}

// MARK: - DataManagerProtocol
extension DataManager: DataManagerProtocol {

	func insert(_ configuration: TodoConfiguration, in context: ModelContext) {
		let new = TodoItem(configuration)
		context.insert(new)
	}
	
	func insert(_ configuration: ListConfiguration, in context: ModelContext) {
		let new = ListItem(configuration)
		context.insert(new)
	}

	func delete(_ todo: TodoItem, in context: ModelContext) {
		context.delete(todo)
	}

	func delete(_ todos: [TodoItem], in context: ModelContext) {
		try? context.transaction {
			for todo in todos {
				context.delete(todo)
			}
		}
	}

	func delete(_ list: ListItem, in context: ModelContext) {
		context.delete(list)
	}

	func update<Item: PersistentModel, T>(_ item: Item, keyPath: ReferenceWritableKeyPath<Item, T>, value: T) {
		item[keyPath: keyPath] = value
	}
}
