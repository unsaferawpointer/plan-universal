//
//  InFocusModel.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 20.07.2024.
//

import Foundation

final class InFocusModel: Observable {

	var localization: InFocusLocalizationProtocol

	init(localization: InFocusLocalizationProtocol = InFocusLocalization()) {
		self.localization = localization
	}
}

extension InFocusModel {

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

	func estimationMessage(for items: [TodoItem]) -> String? {
		let total = items.filter(where: \.isDone, equalsTo: false)
			.compactMap(\.estimation?.storyPoints)
			.sum
		return total > 0 ? localization.estimationMessage(for: total) : nil
	}
}
