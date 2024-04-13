//
//  Query+Extension.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 13.04.2024.
//

import Foundation
import _SwiftData_SwiftUI

extension Query where Element == ListItem, Result == [ListItem] {

	static var all: Query<Element, Result> {
		Query(
			filter: #Predicate {
				$0.isFavorite == false
			},
			sort: \ListItem.creationDate,
			animation: .default
		)
	}
}
