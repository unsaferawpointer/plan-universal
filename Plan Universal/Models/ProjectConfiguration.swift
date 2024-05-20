//
//  ProjectConfiguration.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 15.05.2024.
//

import Foundation

struct ProjectConfiguration {

	let uuid: UUID

	var name: String

	var details: String

	var isArchieved: Bool

	// MARK: - Initialization

	init(
		uuid: UUID = .init(),
		name: String = "",
		details: String = "",
		isArchieved: Bool = false
	) {
		self.uuid = uuid
		self.name = name
		self.details = details
		self.isArchieved = isArchieved
	}

}

// MARK: - Identifiable
extension ProjectConfiguration: Identifiable {

	var id: UUID {
		return uuid
	}
}

// MARK: - Hashable
extension ProjectConfiguration: Hashable { }

// MARK: - ItemConfiguration
extension ProjectConfiguration: ItemConfiguration {

	typealias Item = ProjectItem
}

// MARK: - Templates
extension ProjectConfiguration {

	static var `default`: Self {
		return .init()
	}
}
