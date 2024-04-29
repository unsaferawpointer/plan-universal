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

	var isArchieved: Bool

	var isFavorite: Bool

	var icon: Icon

	// MARK: - Initialization

	init(
		uuid: UUID = .init(),
		title: String = "",
		isArchieved: Bool = false,
		isFavorite: Bool = false,
		icon: Icon = .doc
	) {
		self.uuid = uuid
		self.title = title
		self.isArchieved = isArchieved
		self.isFavorite = isFavorite
		self.icon = icon
	}

}

// MARK: - Identifiable
extension ListConfiguration: Identifiable {

	var id: UUID {
		return uuid
	}
}

// MARK: - Hashable
extension ListConfiguration: Hashable { }
