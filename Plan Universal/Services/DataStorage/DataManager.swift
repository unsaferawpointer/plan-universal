//
//  DataManager.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 24.04.2024.
//

import Foundation
import SwiftData

protocol DataManagerProtocol {

	func insert(_ configuration: TodoConfiguration, toList list: ListItem, in context: ModelContext)
	func insert(_ configuration: ListConfiguration, in context: ModelContext)

	func delete(_ todo: TodoItem, in context: ModelContext)
	func delete<S: Sequence>(_ todos: S, in context: ModelContext) where S.Element == TodoItem
	func delete(_ list: ListItem, in context: ModelContext)


	func update<Item: PersistentModel, T>(_ item: Item, keyPath: ReferenceWritableKeyPath<Item, T>, value: T)

}

final class DataManager {

}

// MARK: - DataManagerProtocol
extension DataManager: DataManagerProtocol {

	func insert(_ configuration: TodoConfiguration, toList list: ListItem, in context: ModelContext) {

		let uuid = list.uuid

		let predicate = #Predicate<TodoItem> {
			$0.list?.uuid == uuid
		}

		let order = SortDescriptor(\TodoItem.order, order: .forward)

		let descriptor = FetchDescriptor<TodoItem>(predicate: predicate, sortBy: [order])

		guard let todos = try? context.fetch(descriptor), let last = todos.last else {
			let new = TodoItem(configuration)
			context.insert(new)
			return
		}

		let new = TodoItem(configuration)
		new.order = last.order + 1
		context.insert(new)
	}

	func insert(_ configuration: ListConfiguration, in context: ModelContext) {

		let new = ListItem(configuration)

		let order = SortDescriptor(\ListItem.order, order: .reverse)

		let descriptor = FetchDescriptor<ListItem>(predicate: nil, sortBy: [order])

		guard let lists = try? context.fetch(descriptor), let last = lists.first else {
			context.insert(new)
			return
		}

		new.order = last.order + 1

		context.insert(new)
	}

	func delete(_ todo: TodoItem, in context: ModelContext) {
		context.delete(todo)
	}

	func delete<S>(_ todos: S, in context: ModelContext) where S : Sequence, S.Element == TodoItem {
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
