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
}

extension TodoListModel {

	func delete(_ item: TodoItem, in context: ModelContext) {
		dataManager.delete(item, in: context)
	}

	func delete<S: Sequence>(_ items: S, in context: ModelContext) where S.Element == TodoItem {
		dataManager.delete(items, in: context)
	}
}
