//
//  Order.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 20.04.2024.
//

import Foundation

protocol CoreDataOrder {
	associatedtype Entity
	var sortDescriptors: [NSSortDescriptor] { get }
}

enum ListOrder {
	case creationDate
}

// MARK: - CoreDataFilter
extension ListOrder: CoreDataOrder {

	typealias Entity = ListEntity

	var sortDescriptors: [NSSortDescriptor] {
		return [NSSortDescriptor(keyPath: \ListEntity.creationDate, ascending: true)]
	}
}

enum TodoOrder {
	case inFocus
	case backlog
	case archieve
	case list
}

// MARK: - CoreDataOrder
extension TodoOrder: CoreDataOrder {

	typealias Entity = TodoEntity

	var sortDescriptors: [NSSortDescriptor] {
		switch self {
		case .inFocus:
			return [.todoPriority]
		case .backlog:
			return [.todoPriority, .todoCreationDate]
		case .archieve:
			return [.completionDate]
		case .list:
			return [
				.forwardCompletionDate,
				.todoPriority,
				.todoCreationDate
			]
		}
	}
}

private extension NSSortDescriptor {

	static var todoCreationDate: NSSortDescriptor {
		NSSortDescriptor(keyPath: \TodoEntity.creationDate, ascending: false)
	}

	static var todoPriority: NSSortDescriptor {
		NSSortDescriptor(keyPath: \TodoEntity.rawPriority, ascending: false)
	}

	static var completionDate: NSSortDescriptor {
		NSSortDescriptor(keyPath: \TodoEntity.completionDate, ascending: false)
	}

	static var forwardCompletionDate: NSSortDescriptor {
		NSSortDescriptor(keyPath: \TodoEntity.completionDate, ascending: true)
	}
}
