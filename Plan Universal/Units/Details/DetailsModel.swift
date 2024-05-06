//
//  DetailsModel.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 18.04.2024.
//

import Foundation
import SwiftData
import Combine

final class DetailsModel {

	var panel: Panel

	private var dataManager: DataManagerProtocol

	private let requestManager = RequestManager()

	// MARK: - Initialization

	init(panel: Panel, dataManager: DataManagerProtocol = DataManager()) {
		self.panel = panel
		self.dataManager = dataManager
	}
}

// MARK: - Computed properties
extension DetailsModel {

	var title: String {
		panel.title
	}
}

// MARK: - DataManager Proxy
extension DetailsModel {

	func setPriority(priority: TodoPriority, todo: TodoItem) {
		dataManager.update(todo, keyPath: \.priority, value: priority)
	}

	func setStatus(_ status: TodoStatus, todo: TodoItem) {
		dataManager.update(todo, keyPath: \.status, value: status)
	}

	func delete(_ selected: [TodoItem], in context: ModelContext) {
		try? context.transaction {
			for todo in selected {
				context.delete(todo)
			}
		}
	}
}

// MARK: - RequestManager Proxy
extension DetailsModel {
	
	func sorting() -> [TodoOrder] {
		requestManager.sorting(for: panel)
	}

	func predicate(containsText text: String?) -> TodoFilter {
		requestManager.predicate(for: panel, containsText: text)
	}

	func todoConfiguration() -> TodoConfiguration {
		requestManager.todoConfiguration(for: panel)
	}
}
