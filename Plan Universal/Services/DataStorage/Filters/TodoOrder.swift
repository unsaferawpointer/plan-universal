//
//  TodoOrder.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 28.04.2024.
//

import Foundation

enum TodoOrder {
	case creationDate(_ order: SortOrder)
	case status(_ order: SortOrder)
}

// MARK: - Order
extension TodoOrder: Order {

	typealias Element = TodoItem

	var sortDescriptor: SortDescriptor<TodoItem> {
		switch self {
		case .creationDate(let order):
			SortDescriptor(\.creationDate, order: order)
		case .status(let order):
			SortDescriptor(\.rawStatus, order: order)
		}
	}
}
