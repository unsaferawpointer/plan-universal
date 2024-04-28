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

	var elemens: DetailsTodoRowElements

	// MARK: - Initialization

	init(todo: TodoItem, elemens: DetailsTodoRowElements) {
		self.todo = todo
		self.elemens = elemens
	}
}

// MARK: - Calculated properties
extension DetailsTodoRowModel {

	var showSign: Bool {
		return todo.isImportant
	}

	var isDone: Bool {
		todo.isDone
	}

	var text: String {
		return todo.text
	}

	var listTitle: String? {
		return todo.list?.title
	}

	var showList: Bool {
		return elemens.contains(.listLabel)
	}

	var signColor: Color {
		return todo.priority.color
	}
}

// MARK: - Public interface
extension DetailsTodoRowModel {

	func setCompletion(_ value: Bool) {
		todo.isDone = value
	}
}
