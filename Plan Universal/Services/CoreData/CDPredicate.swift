//
//  CDPredicate.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 18.04.2024.
//

import Foundation

protocol CoreDataFilter {
	associatedtype Entity
	var predicate: NSPredicate? { get }
}

enum ListFilter {
	case all
}

// MARK: - CoreDataFilter
extension ListFilter: CoreDataFilter {

	typealias Entity = ListEntity
	
	var predicate: NSPredicate? {
		switch self {
		case .all:
			return nil
		}
	}
}

enum TodoFilter {
	case all
	case status(_ value: TodoStatus)
	case list(_ id: UUID?)
}

// MARK: - CoreDataFilter
extension TodoFilter: CoreDataFilter {

	typealias Entity = TodoEntity

	var predicate: NSPredicate? {
		switch self {
		case .all:
			return nil
		case .status(let value):
			return NSPredicate(format: "rawStatus == %@", argumentArray: [value.rawValue])
		case .list(let id):
			return NSPredicate(format: "list.uuid == %@", argumentArray: [id as Any])
		}
	}
}
