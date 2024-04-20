//
//  NavigationRowModel.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 20.04.2024.
//

import Foundation
import Combine

final class NavigationRowModel: ObservableObject {

	// MARK: - Published

	@Published var todos: [TodoEntity] = []

	// MARK: - Internal

	private var cancellable: AnyCancellable?

	init<Filter: CoreDataFilter>(filter: Filter) where Filter.Entity == TodoEntity {
		let publisher = PersistentContainer.shared.mainContext.publisher(
			for: TodoEntity.self,
			filter: filter,
			order: TodoOrder.backlog
		).eraseToAnyPublisher()
		cancellable = publisher.sink { entities in
			self.todos = entities
		}
	}
}

extension NavigationRowModel {

	var count: Int {
		todos.count
	}

	var isEmpty: Bool {
		todos.isEmpty
	}
}
