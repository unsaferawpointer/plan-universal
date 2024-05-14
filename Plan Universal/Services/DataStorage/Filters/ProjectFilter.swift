//
//  ProjectFilter.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 15.05.2024.
//

import Foundation

struct ProjectFilter { }

// MARK: - Filter
extension ProjectFilter: Filter {

	typealias Element = ProjectItem

	var predicate: Predicate<Element> {
		return .true
	}
}
