//
//  ListItem.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 24.04.2024.
//
//

import Foundation
import SwiftData

@Model
final class ListItem {

	var uuid: UUID = UUID()
	var title: String = ""
	var options: Int64 = 0
	var details: String = ""
	var isArchieved: Bool = false

	var creationDate: Date = Date()

	// MARK: - Relationships

	@Relationship(deleteRule: .cascade, inverse: \TodoItem.list) var todos: [TodoItem]?

	// MARK: - Order

	var order: Int = 1

	// MARK: - Initialization

	public init() { }

	required init(_ configuration: ListConfiguration) {
		self.title = configuration.title
		self.details = configuration.details
		self.isArchieved = configuration.isArchived
	}

}

// MARK: - Sortable
extension ListItem: Sortable { }

// MARK: - Identifiable
extension ListItem: Identifiable {

	var id: UUID {
		return uuid
	}
}

// MARK: - ConfigurableItem
extension ListItem: ConfigurableItem {

	typealias Configuration = ListConfiguration

	var configuration: Configuration {
		get {
			return .init(
				title: title,
				details: details,
				isArchived: isArchieved
			)
		}
		set {
			self.title = newValue.title
			self.details = newValue.details
			self.isArchieved = newValue.isArchived
		}
	}

}
