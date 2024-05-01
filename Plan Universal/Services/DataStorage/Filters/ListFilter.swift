//
//  ListFilter.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 01.05.2024.
//

import Foundation

struct ListFilter {

	private let isFavorite: Bool

	// MARK: - Initialization

	init(isFavorite: Bool) {
		self.isFavorite = isFavorite
	}
}

// MARK: - Filter
extension ListFilter: Filter {

	typealias Element = ListItem

	var predicate: Predicate<Element> {
		return #Predicate {
			$0.isFavorite == isFavorite
		}
	}
}
