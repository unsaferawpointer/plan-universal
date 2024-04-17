//
//  DetailsModel.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 18.04.2024.
//

import Foundation
import Combine

final class DetailsModel: ObservableObject {

	// MARK: - Published

	@Published var selection: Set<TodoEntity.ID> = .init()

	@Published var todos: [TodoEntity] = []

	// MARK: - DI

	private let dataStorage: DataStorageProtocol

	// MARK: - Internal

	private var cancellable: AnyCancellable?

	init(panel: Panel) {
		let publisher = PersistentContainer.shared.mainContext.publisher(
			for: TodoEntity.self,
			filter: panel.filter
		).eraseToAnyPublisher()
		self.dataStorage = DataStorage()
		cancellable = publisher.sink { entities in
			self.todos = entities
		}
	}
}

// MARK: - Public interface
extension DetailsModel {
	
	var isEmpty: Bool {
		return todos.isEmpty
	}

	var count: Int {
		return todos.count
	}

	func delete(_ todo: TodoEntity) {
		var selected = selected(for: todo)
		dataStorage.deleteTodos(selected)
	}

	func setStatus(_ status: TodoStatus, todo: TodoEntity) {
		var selected = selected(for: todo)
		dataStorage.setStatus(status, for: selected)
	}

	func setPriority(_ priority: TodoPriority, todo: TodoEntity) {
		var selected = selected(for: todo)
		dataStorage.setPriority(priority, for: selected)
	}

	func insert(with conficuration: TodoConfiguration) {
		dataStorage.insertTodo(conficuration)
	}
}

// MARK: - Helpers
private extension DetailsModel {

	func selected(for todo: TodoEntity) -> [TodoEntity] {
		guard selection.contains(todo.id) else {
			return [todo]
		}
		return todos.filter {
			selection.contains($0.id)
		}
	}
}

extension Panel {

	var filter: TodoFilter {
		switch self {
		case .inFocus:
			return .status(.inFocus)
		case .backlog:
			return .status(.backlog)
		case .archieve:
			return .status(.done)
		case .list(let value):
			return .list(value.uuid)
		}
	}
}