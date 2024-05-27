//
//  ListDetails+Model.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 27.05.2024.
//

import SwiftData

extension ListDetails {

	@Observable
	final class Model {
		
		private var action: Action<ListItem>

		private var project: ProjectItem?

		var configuration: ListConfiguration

		// MARK: - Initialization

		init(action: Action<ListItem>, project: ProjectItem?) {
			self.action = action
			self.project = project
			self.configuration = action.configuration
		}
	}
}

// MARK: - Public interface
extension ListDetails.Model {

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

	var isNew: Bool {
		return action.isNew
	}
}

// MARK: - Public interface
extension ListDetails.Model {

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
			new.project = project
			context.insert(new)
		case .edit(let list):
			try? context.transaction {
				list.configuration = configuration
				list.title = title
			}
		}
	}
}
