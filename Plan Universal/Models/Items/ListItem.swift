//
//  ListItem.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 05.04.2024.
//

import SwiftData
import Foundation

@Model
final class ListItem {

	@Attribute(.unique) var uuid: UUID

	var title: String

	var isArchieved: Bool

	var isFavorite: Bool

	var creationDate: Date

	var rawIcon: Int?

	// MARK: - Relationships

	@Relationship(deleteRule: .cascade, inverse: \TodoItem.list) var todos: [TodoItem] = []

	// MARK: - Initialization

	init(
		uuid: UUID,
		title: String,
		isArchieved: Bool,
		isFavorite: Bool,
		creationDate: Date,
		rawIcon: Int?
	) {
		self.uuid = uuid
		self.title = title
		self.isArchieved = isArchieved
		self.isFavorite = isFavorite
		self.creationDate = creationDate
		self.rawIcon = rawIcon
	}
}

// MARK: - Identifiable
extension ListItem: Identifiable {

	var id: UUID {
		return uuid
	}
}

// MARK: - Templates
extension ListItem {

	static var new: ListItem {
		return .init(
			uuid: .init(),
			title: "New List",
			isArchieved: false,
			isFavorite: false,
			creationDate: .now,
			rawIcon: nil
		)
	}
}
