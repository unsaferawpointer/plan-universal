//
//  TodoListModel.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 26.05.2024.
//

import Foundation
import SwiftData

final class TodoListModel {

	var dataManager = DataManager()

	var localization: TodoListLocalizationProtocol

	init(localization: TodoListLocalizationProtocol = TodoListLocalization()) {
		self.localization = localization
	}
}

extension TodoListModel {

	func delete(_ item: TodoItem, in context: ModelContext) {
		dataManager.delete(item, in: context)
	}

	func delete<S: Sequence>(_ items: S, in context: ModelContext) where S.Element == TodoItem {
		dataManager.delete(items, in: context)
	}

	func subtitle(for items: [TodoItem]) -> String {
		let completedTodos = items.filter(where: \.isDone, equalsTo: true)
		let completedTodosCount = completedTodos.count

		let incompleteTodosCount = items.count - completedTodosCount

		switch (completedTodosCount, incompleteTodosCount) {
		case (0, 0):
			return localization.noScheduledTodos
		case (_, 0):
			return localization.allTodosCompleted
		case (0, _):
			return localization.statusMessage(for: items.count)
		default:
			return localization.statusMessage(
				for: items.count,
				incompleteCount: incompleteTodosCount
			)
		}
	}
}
