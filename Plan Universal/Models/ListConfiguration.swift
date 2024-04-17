//
//  ListConfiguration.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 17.04.2024.
//

import Foundation

struct ListConfiguration {

	let uuid: UUID

	var title: String

	var isArchieved: Bool

	var isFavorite: Bool

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

	static var `default`: ListConfiguration {
		return .init(
			uuid: .init(),
			title: "",
			isArchieved: false,
			isFavorite: false
		)
	}
}

