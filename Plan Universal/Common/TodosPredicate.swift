//
//  TodosPredicate.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 14.04.2024.
//

import Foundation

enum TodosPredicate {
	case status(value: TodoStatus)
	case priority(value: TodoPriority)
}
