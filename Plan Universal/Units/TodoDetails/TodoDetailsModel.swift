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
			break
//			dataManager.insert(configuration, in: context)
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
