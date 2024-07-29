//
//  TodoListLocalization.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 25.07.2024.
//

import Foundation

protocol TodoListLocalizationProtocol {
	func statusMessage(for totalCount: Int, incompleteCount: Int) -> String
	func statusMessage(for totalCount: Int) -> String
	var noScheduledTodos: String { get }
	var allTodosCompleted: String { get }
	func estimationMessage(for estimation: Int) -> String
}

final class TodoListLocalization { }

// MARK: - TodoListLocalizationProtocol
extension TodoListLocalization: TodoListLocalizationProtocol {

	func statusMessage(for totalCount: Int, incompleteCount: Int) -> String {
		let leading = String(localized: "\(totalCount) todos")
		let trailing = String(localized: "\(incompleteCount) incomplete")
		return leading + " - " + trailing
	}

	func statusMessage(for totalCount: Int) -> String {
		return String(localized: "\(totalCount) todos")
	}

	var noScheduledTodos: String {
		String(localized: "No todos")
	}

	var allTodosCompleted: String {
		String(localized: "All tasks completed")
	}

	func estimationMessage(for estimation: Int) -> String {
		return String(localized: "Estimation - \(estimation) sp")
	}
}
