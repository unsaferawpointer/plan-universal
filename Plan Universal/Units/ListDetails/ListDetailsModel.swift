//
//  ListDetailsModel.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 18.04.2024.
//

import Foundation
import SwiftData

@Observable
final class ListDetailsModel {

	private var action: Action<ListItem>

	var configuration: ListConfiguration

	// MARK: - Initialization

	init(action: Action<ListItem>) {
		self.action = action
		self.configuration = action.configuration
	}
}

// MARK: - Public interface
extension ListDetailsModel {
	
	var canDelete: Bool {
		guard case .edit = action else {
			return false
		}
		return true
	}

	var canSave: Bool {
		let trimmed = configuration.title.trimmingCharacters(in: .whitespaces)
		return !trimmed.isEmpty
	}
}

// MARK: - Public interface
extension ListDetailsModel {

	func delete(in context: ModelContext) {
		guard case let .edit(item) = action else {
			return
		}
		context.delete(item)
	}

	func save(in context: ModelContext) {

		let trimmed = configuration.title.trimmingCharacters(in: .whitespaces)
		let title = trimmed.isEmpty ? String(localized: "New List") : trimmed

		switch action {
		case .new:
			let new = ListItem(configuration)
			context.insert(new)
		case .edit(let list):
			try? context.transaction {
				list.configuration = configuration
				list.title = title
			}
		}
	}
}
