//
//  TodoOrderV2.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 28.04.2024.
//

import Foundation

enum TodoOrderV2 {
	case creationDate(_ order: SortOrder)
	case completionDate(_ order: SortOrder)
	case priority(_ order: SortOrder)
	case status(_ order: SortOrder)
}

// MARK: - Order
extension TodoOrderV2: OrderV2 {

	typealias Element = TodoItem

	var sortDescriptor: SortDescriptor<TodoItem> {
		switch self {
		case .creationDate(let order):
			SortDescriptor(\.creationDate, order: order)
		case .completionDate(let order):
			SortDescriptor(\.completionDate, order: order)
		case .priority(let order):
			SortDescriptor(\.rawPriority, order: order)
		case .status(let order):
			SortDescriptor(\.rawStatus, order: order)
		}
	}
}
