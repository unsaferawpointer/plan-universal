//
//  TodoDetailsModel.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 19.04.2024.
//

import Foundation
import Combine

final class TodoDetailsModel: ObservableObject {

	// MARK: - Published

	@Published var configuration: TodoConfiguration

	@Published var lists: [ListEntity] = []

	// MARK: - DI

	private (set) var action: DetailsAction<TodoEntity>

	private let dataStorage: DataStorageProtocol

	// MARK: - Internal state

	private var cancellable: AnyCancellable?

	// MARK: - Initialization

	init(
		_ action: DetailsAction<TodoEntity>,
		dataStorage: DataStorageProtocol = DataStorage(),
		publisher: AnyPublisher<[ListEntity], Never> = PersistentContainer.shared.mainContext.publisher(for: ListEntity.self, filter: ListFilter.all, order: ListOrder.creationDate).eraseToAnyPublisher(),
		initialConfiguration: TodoConfiguration
	) {
		self.action = action
		self.dataStorage = dataStorage
		let initialConfiguration = action.wrappedValue?.configuration ?? initialConfiguration
		self._configuration = Published(initialValue: initialConfiguration)
		cancellable = publisher.sink { entities in
			self.lists = entities
		}
	}
}

extension TodoDetailsModel {

	func delete() {
		switch action {
		case .new:
			fatalError()
		case .edit(let todo):
			dataStorage.deleteTodos([todo])
		}
		try? dataStorage.save()
	}

	func save() {

		let trimmed = configuration.text.trimmingCharacters(in: .whitespaces)
		let text = trimmed.isEmpty ? String(localized: "New Todo") : trimmed

		switch action {
		case .new:
			let new = dataStorage.insertTodo(configuration)
			new.text = text
		case .edit(let todo):
			todo.configuration = configuration
			todo.text = text
		}
		try? dataStorage.save()
	}

	var buttonToDeleteIsEnabled: Bool {
		guard case .edit = action else {
			return false
		}
		return true
	}

	var buttonToSaveIsEnabled: Bool {
		let trimmed = configuration.text.trimmingCharacters(in: .whitespaces)
		return !trimmed.isEmpty
	}
}
