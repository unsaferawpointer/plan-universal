//
//  ListConfiguration.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 24.04.2024.
//

import Foundation

struct ListConfiguration {

	var title: String

	var details: String

	var isArchived: Bool

	var project: ProjectItem?

	// MARK: - Initialization

	init(
		title: String = "New List",
		details: String = "",
		isArchived: Bool = false,
		project: ProjectItem?
	) {
		self.title = title
		self.details = details
		self.isArchived = isArchived
		self.project = project
	}

}

// MARK: - ItemConfiguration
extension ListConfiguration: ItemConfiguration {

	typealias Item = ListItem
}

// MARK: - Hashable
extension ListConfiguration: Hashable { }

// MARK: - Templates
extension ListConfiguration {

	static var `default`: Self {
		return .init(project: nil)
	}
}
