//
//  TodoConfiguration.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 24.04.2024.
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
