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

	var creationDate: Date = Date()

	// MARK: - Relationships

	@Relationship(deleteRule: .nullify) var project: ProjectItem?

	@Relationship(deleteRule: .cascade, inverse: \TodoItem.list) var todos: [TodoItem]?

	// MARK: - Order

	var order: Int = 1

	// MARK: - Initialization

	public init() { }

	required init(_ configuration: ListConfiguration) {
		self.uuid = configuration.uuid
		self.title = configuration.title
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
				uuid: uuid,
				title: title
			)
		}
		set {
			self.title = newValue.title
		}
	}

}
