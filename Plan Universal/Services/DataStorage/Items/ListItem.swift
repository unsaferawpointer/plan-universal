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
class ListItem {

	var uuid: UUID = UUID()
	var title: String = ""
	var isArchieved: Bool = false
	var isFavorite: Bool = false
	var creationDate: Date = Date()
	var rawIcon: Int64 = 0
	var options: Int64 = 0

	@Relationship(deleteRule: .cascade, inverse: \TodoItem.list) var todos: [TodoItem]?

	public init() { }

}

// MARK: - Identifiable
extension ListItem: Identifiable {

	var id: UUID {
		return uuid
	}
}

// MARK: - Computed properties
extension ListItem {

	var icon: Icon {
		get {
			return Icon(rawValue: rawIcon) ?? .doc
		}
		set {
			rawIcon = newValue.rawValue
		}
	}
}

// MARK: - ConfigurableItem
extension ListItem: ConfigurableItem {

	typealias Configuration = ListConfiguration

	var configuration: Configuration {
		get {
			return .init(
				uuid: uuid,
				title: title,
				isArchieved: isArchieved,
				isFavorite: isFavorite,
				icon: Icon(rawValue: rawIcon) ?? .doc
			)
		}
		set {
			self.title = newValue.title
			self.isArchieved = newValue.isArchieved
			self.isFavorite = newValue.isFavorite
			self.rawIcon = newValue.icon.rawValue
		}
	}

}

// MARK: - Convenience initialization
extension ListItem {

	convenience init(_ configuration: ListConfiguration) {
		self.init()
		self.uuid = configuration.uuid
		self.title = configuration.title
		self.isArchieved = configuration.isArchieved
		self.isFavorite = configuration.isFavorite
	}
}
