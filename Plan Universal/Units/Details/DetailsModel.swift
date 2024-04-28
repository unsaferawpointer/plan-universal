//
//  DetailsModel.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 18.04.2024.
//

import Foundation
import SwiftUI
import Combine

//final class DetailsModel: ObservableObject {
//
//	// MARK: - Published
//
//	@Published var selection: Set<TodoItem.ID> = .init()
//
//	@Published var todos: [TodoItem] = []
//
//	@Published var elements: DetailsTodoRowElements
//
//	// MARK: - DI
//
//	private let dataStorage: DataStorageProtocol
//
//	// MARK: - Internal
//
//	private var cancellable: AnyCancellable?
//
//	init(panel: Panel) {
//		let publisher = PersistentContainer.shared.mainContext.publisher(
//			for: TodoEntity.self,
//			filter: panel.filter,
//			order: panel.order
//		).eraseToAnyPublisher()
//		self.dataStorage = DataStorage()
//		self.elements = panel.elements
//		cancellable = publisher.sink { entities in
//			withAnimation {
//				self.todos = entities
//			}
//		}
//	}
//}
//
//// MARK: - Public interface
//extension DetailsModel {
//	
//	var isEmpty: Bool {
//		return todos.isEmpty
//	}
//
//	var count: Int {
//		return todos.count
//	}
//
//	func delete(_ todo: TodoEntity) {
//		var selected = selected(for: todo)
//		dataStorage.deleteTodos(selected)
//		try? dataStorage.save()
//	}
//
//	func setStatus(_ status: TodoStatus, todo: TodoItem) {
//		var selected = selected(for: todo)
//		dataStorage.setStatus(status, for: selected)
//		try? dataStorage.save()
//	}
//
//	func setPriority(_ priority: TodoPriority, todo: TodoItem) {
//		var selected = selected(for: todo)
//		dataStorage.setPriority(priority, for: selected)
//		try? dataStorage.save()
//	}
//
//	func insert(with conficuration: TodoConfiguration) {
//		dataStorage.insertTodo(conficuration)
//		try? dataStorage.save()
//	}
//}
//
//// MARK: - Helpers
//private extension DetailsModel {
//
//	func selected(for todo: TodoItem) -> [TodoItem] {
//		guard selection.contains(todo.id) else {
//			return [todo]
//		}
//		return todos.filter {
//			selection.contains($0.id)
//		}
//	}
//}
//
//extension Panel {
//
//	var elements: DetailsTodoRowElements {
//		switch self {
//		case .inFocus, .backlog, .completed:
//			return [.listLabel]
//		case .list:
//			return []
//		}
//	}
//
//	var filter: TodoFilter {
//		switch self {
//		case .inFocus:
//			return .status(.inFocus)
//		case .backlog:
//			return .status(.backlog)
//		case .completed:
//			return .status(.done)
//		case .list(let value):
//			return .list(value.uuid)
//		}
//	}
//
//	var order: TodoOrder {
//		switch self {
//		case .inFocus:
//			return .inFocus
//		case .backlog:
//			return .backlog
//		case .completed:
//			return .archieve
//		case .list:
//			return .list
//		}
//	}
//}
