//
//  DetailsTodoRowModel.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 21.04.2024.
//

import Foundation
import SwiftUI

final class DetailsTodoRowModel: ObservableObject {

	@Published var todo: TodoItem

	// MARK: - Initialization

	init(todo: TodoItem) {
		self.todo = todo
	}
}

// MARK: - Calculated properties
extension DetailsTodoRowModel {

	var signIcon: String? {
		guard todo.status == .inFocus else {
			return "bolt.fill"
		}
		return todo.isImportant ? "sparkles" : nil
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
		todo.isDone
	}

	var text: String {
		return todo.text
	}
}

// MARK: - Public interface
extension DetailsTodoRowModel {

	func setCompletion(_ value: Bool) {
		todo.status = value ? .done : .backlog
	}
}
