//
//  TodoDetailsModel.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 19.04.2024.
//

import Foundation
import SwiftData

@Observable
final class TodoDetailsModel {

	var action: Action<TodoItem>

	var configuration: TodoConfiguration

	private var dataManager: DataManager = DataManager()

	// MARK: Initialization

	init(action: Action<TodoItem>) {
		self.action = action
		self.configuration = action.configuration
	}
}

// MARK: - Public interface
extension TodoDetailsModel {

	func delete(in context: ModelContext) {
		switch action {
		case .new:
			fatalError("\(#function) is unavailable because action is <new>")
		case .edit(let todo):
			dataManager.delete(todo, in: context)
		}
	}

	func save(in context: ModelContext) {
		let trimmed = configuration.text.trimmingCharacters(in: .whitespaces)
		let text = trimmed.isEmpty ? String(localized: "New Todo") : trimmed

		switch action {
		case .new:
			dataManager.insert(configuration, in: context)
		case .edit(let todo):
			try? context.transaction {
				todo.configuration = configuration
			}
		}
	}

}

// MARK: - Computed properties
extension TodoDetailsModel {

	var canDelete: Bool {
		guard case .edit = action else {
			return false
		}
		return true
	}

	var canSave: Bool {
		let trimmed = configuration.text.trimmingCharacters(in: .whitespaces)
		return !trimmed.isEmpty
	}
}

//final class TodoDetailsModel: ObservableObject {
//
//	// MARK: - Published
//
//	@Published var configuration: TodoConfigurationV2
//
//	@Published var lists: [ListItem] = []
//
//	// MARK: - DI
//
//	private (set) var action: DetailsAction<TodoItem>
//
//	private let dataStorage: DataStorageProtocol
//
//	// MARK: - Internal state
//
//	private var cancellable: AnyCancellable?
//
//	// MARK: - Initialization
//
//	init(
//		_ action: DetailsAction<TodoEntity>,
//		dataStorage: DataStorageProtocol = DataStorage(),
//		publisher: AnyPublisher<[ListEntity], Never> = PersistentContainer.shared.mainContext.publisher(for: ListEntity.self, filter: ListFilter.all, order: ListOrder.creationDate).eraseToAnyPublisher(),
//		initialConfiguration: TodoConfiguration
//	) {
//		self.action = action
//		self.dataStorage = dataStorage
//		let initialConfiguration = action.wrappedValue?.configuration ?? initialConfiguration
//		self._configuration = Published(initialValue: initialConfiguration)
//		cancellable = publisher.sink { entities in
//			self.lists = entities
//		}
//	}
//}
//
//extension TodoDetailsModel {
//
//	func delete() {
//		switch action {
//		case .new:
//			fatalError()
//		case .edit(let todo):
//			dataStorage.deleteTodos([todo])
//		}
//		try? dataStorage.save()
//	}
//
//	func save() {
//
//		let trimmed = configuration.text.trimmingCharacters(in: .whitespaces)
//		let text = trimmed.isEmpty ? String(localized: "New Todo") : trimmed
//
//		switch action {
//		case .new:
//			let new = dataStorage.insertTodo(configuration)
//			new.text = text
//		case .edit(let todo):
//			todo.configuration = configuration
//			todo.text = text
//		}
//		try? dataStorage.save()
//	}
//
//	var buttonToDeleteIsEnabled: Bool {
//		guard case .edit = action else {
//			return false
//		}
//		return true
//	}
//
//	var buttonToSaveIsEnabled: Bool {
//		let trimmed = configuration.text.trimmingCharacters(in: .whitespaces)
//		return !trimmed.isEmpty
//	}
//}
