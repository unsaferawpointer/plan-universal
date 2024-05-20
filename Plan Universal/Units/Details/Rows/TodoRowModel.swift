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
		guard todo.inFocus else {
			return todo.isUrgent ? "bolt.fill" : nil
		}
		return "sparkles"
	}

	var signColor: Color {
		guard !todo.isDone else {
			return .secondary
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
