//
//  ProjectDetailModel.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 15.05.2024.
//

import Foundation
import SwiftData

@Observable
final class ProjectDetailsModel {

	private var action: Action<ProjectItem>

	var configuration: ProjectConfiguration

	@ObservationIgnored
	var dataManager = DataManager()

	// MARK: - Initialization

	init(action: Action<ProjectItem>) {
		self.action = action
		self.configuration = action.configuration
	}
}

// MARK: - Public interface
extension ProjectDetailsModel {

	var canDelete: Bool {
		guard case .edit = action else {
			return false
		}
		return true
	}

	var canSave: Bool {
		let trimmed = configuration.name.trimmingCharacters(in: .whitespaces)
		return !trimmed.isEmpty
	}

	var isNew: Bool {
		guard case .new = action else {
			return false
		}
		return true
	}
}

// MARK: - Public interface
extension ProjectDetailsModel {

	func delete(in context: ModelContext) {
		guard case let .edit(item) = action else {
			return
		}
		context.delete(item)
	}

	func save(in context: ModelContext) {

		let trimmed = configuration.name.trimmingCharacters(in: .whitespaces)
		let name = trimmed.isEmpty ? String(localized: "New Project") : trimmed

		switch action {
		case .new:
			dataManager.insert(configuration, in: context)
		case .edit(let list):
			try? context.transaction {
				list.configuration = configuration
				list.name = name
			}
		}
	}
}
