//
//  TodoConfiguration.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 13.04.2024.
//

import Foundation

struct TodoConfiguration {

	var text: String = ""

	var status: TodoStatus = .backlog

	var priority: TodoPriority = .low

	var list: ListItem?

}

// MARK: - Hashable
extension TodoConfiguration: Hashable { }

// MARK: - Templates
extension TodoConfiguration {

	static var `default`: TodoConfiguration {
		return .init()
	}

	static var inFocus: TodoConfiguration {
		return .init(status: .inFocus)
	}

	static var backlog: TodoConfiguration {
		return .init(status: .backlog)
	}

	static var done: TodoConfiguration {
		return .init(status: .done)
	}
}
