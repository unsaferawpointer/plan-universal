//
//  TodoItem.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 05.04.2024.
//

import SwiftData
import Foundation

@Model
final class TodoItem {

	var uuid: UUID

	var text: String

	private var rawStatus: Int

	private var rawPriority: Int

	var creationDate: Date

	var completionDate: Date?

	// MARK: - Relationships

	var list: ListItem?

	// MARK: - Initialization

	init(
		uuid: UUID,
		text: String,
		rawStatus: Int,
		rawPriority: Int,
		creationDate: Date,
		completionDate: Date?,
		list: ListItem?
	) {
		self.uuid = uuid
		self.text = text
		self.rawStatus = rawStatus
		self.rawPriority = rawPriority
		self.creationDate = creationDate
		self.completionDate = completionDate
		self.list = list
	}
}

// MARK: - Identifiable
extension TodoItem: Identifiable {

	var id: UUID {
		return uuid
	}
}
