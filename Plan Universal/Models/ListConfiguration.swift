//
//  ListConfiguration.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 24.04.2024.
//

import Foundation

struct ListConfiguration {

	let uuid: UUID

	var title: String

	var details: String

	var isArchived: Bool

	// MARK: - Initialization

	init(
		uuid: UUID = .init(),
		title: String = "New List",
		details: String = "",
		isArchived: Bool = false
	) {
		self.uuid = uuid
		self.title = title
		self.details = details
		self.isArchived = isArchived
	}

}

// MARK: - ItemConfiguration
extension ListConfiguration: ItemConfiguration {

	typealias Item = ListItem
}

// MARK: - Identifiable
extension ListConfiguration: Identifiable {

	var id: UUID {
		return uuid
	}
}

// MARK: - Hashable
extension ListConfiguration: Hashable { }

// MARK: - Templates
extension ListConfiguration {

	static var `default`: Self {
		return .init()
	}
}
