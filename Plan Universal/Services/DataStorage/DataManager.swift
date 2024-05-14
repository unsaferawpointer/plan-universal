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
	func insert(_ configuration: ListConfiguration, toProject project: ProjectItem?, in context: ModelContext)
	func insert(_ configuration: ProjectConfiguration, in context: ModelContext)

	func delete(_ todo: TodoItem, in context: ModelContext)
	func delete(_ todos: [TodoItem], in context: ModelContext)
	func delete(_ list: ListItem, in context: ModelContext)

	func move(_ project: ProjectItem, after: ProjectItem, in context: ModelContext)
	func move(_ project: ProjectItem, before: ProjectItem, in context: ModelContext)

	func update<Item: PersistentModel, T>(_ item: Item, keyPath: ReferenceWritableKeyPath<Item, T>, value: T)

}

final class DataManager {

}

// MARK: - DataManagerProtocol
extension DataManager: DataManagerProtocol {

	func insert(_ configuration: ProjectConfiguration, in context: ModelContext) {

		let order = SortDescriptor(\ProjectItem.order, order: .forward)

		var descriptor = FetchDescriptor<ProjectItem>(predicate: nil, sortBy: [order])

		guard let projects = try? context.fetch(descriptor), let last = projects.last else {
			let new = ProjectItem(configuration)
			context.insert(new)
			return
		}
		print("orders = \(projects.map(\.order))")
		let new = ProjectItem(configuration)

		print("_TEST lastOrder = \(last.order)")
		new.order = last.order + 1

		context.insert(new)
	}

	func insert(_ configuration: TodoConfiguration, toList list: ListItem, in context: ModelContext) {

		let uuid = list.uuid
		let predicate = #Predicate<TodoItem> {
			$0.list?.uuid == uuid
		}

		let order = SortDescriptor(\TodoItem.order, order: .forward)

		var descriptor = FetchDescriptor<TodoItem>(predicate: predicate, sortBy: [order])

		guard let todos = try? context.fetch(descriptor), let last = todos.last else {
			let new = TodoItem(configuration)
			context.insert(new)
			return
		}

		let new = TodoItem(configuration)
		new.order = last.order + 1
		context.insert(new)
	}
	
	func insert(_ configuration: ListConfiguration, toProject project: ProjectItem?, in context: ModelContext) {

		let uuid = project?.uuid
		let predicate = #Predicate<ListItem> {
			$0.project?.uuid == uuid
		}

		var new = ListItem(configuration)

		let order = SortDescriptor(\ListItem.order, order: .reverse)

		var descriptor = FetchDescriptor<ListItem>(predicate: predicate, sortBy: [order])

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

	func move(_ project: ProjectItem, after: ProjectItem, in context: ModelContext) {
		let order = SortDescriptor(\ProjectItem.order, order: .forward)

	}

	func move(_ project: ProjectItem, before: ProjectItem, in context: ModelContext) {
		
	}
}
