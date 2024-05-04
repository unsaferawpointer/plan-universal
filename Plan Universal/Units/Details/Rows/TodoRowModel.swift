//
//  TodoRowModel.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 21.04.2024.
//

import Foundation
import SwiftUI

final class TodoRowModel: ObservableObject {

	@Published var todo: TodoItem

	let hapticFeedback = ImpactFeedbackFacade()

	// MARK: - Initialization

	init(todo: TodoItem) {
		self.todo = todo
	}
}

// MARK: - Calculated properties
extension TodoRowModel {

	var signIcon: String? {
		guard todo.status == .inFocus else {
			return todo.isImportant ? "bolt.fill" : nil
		}
		return "sparkles"
	}

	var signColor: Color {
		guard todo.status != .done else {
			return .secondary
		}
		guard todo.status == .inFocus else {
			return todo.priority.color
		}
		return .yellow
	}

	var isDone: Bool {
		get {
			todo.isDone
		}
		set {
			todo.isDone = newValue
			hapticFeedback.impactOccurred()
		}
	}

	var text: String {
		return todo.text
	}
}
