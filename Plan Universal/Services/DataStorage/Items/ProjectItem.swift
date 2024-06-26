//
//  ProjectItem.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 15.05.2024.
//

import Foundation
import SwiftData

@Model
final class ProjectItem {

	var uuid: UUID = UUID()
	var name: String = ""
	var isArchieved: Bool = false
	var details: String = ""
	var options: Int64 = 0

	var creationDate: Date = Date()

	// MARK: - Order

	var order: Int = 0

	// MARK: - Relationships

	@Relationship(deleteRule: .cascade, inverse: \ListItem.project) var lists: [ListItem]?

	// MARK: - Initialization

	public init() { }

}

// MARK: - Sortable
extension ProjectItem: Sortable { }

// MARK: - Hashable
extension ProjectItem: Hashable { }

// MARK: - Identifiable
extension ProjectItem: Identifiable {

	var id: UUID {
		return uuid
	}
}

// MARK: - ConfigurableItem
extension ProjectItem: ConfigurableItem {

	typealias Configuration = ProjectConfiguration

	var configuration: ProjectConfiguration {
		get {
			return .init(uuid: uuid, name: name, details: details, isArchieved: isArchieved)
		}
		set {
			self.name = newValue.name
			self.details = newValue.details
			self.isArchieved = newValue.isArchieved
		}
	}
}

// MARK: - Convenience initialization
extension ProjectItem {

	convenience init(_ configuration: ProjectConfiguration) {
		self.init()
		self.name = configuration.name
		self.details = configuration.details
		self.isArchieved = configuration.isArchieved
	}
}
