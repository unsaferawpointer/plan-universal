//
//  TodoFilter.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 26.04.2024.
//

import Foundation

struct TodoFilter {

	var constainsText: String?

	var base: Base

	init(base: Base, constainsText: String?) {
		self.base = base
		self.constainsText = constainsText
	}
}

// MARK: - Filter
extension TodoFilter: Filter {

	typealias Element = TodoItem

	var predicate: Predicate<TodoItem> {
		if let text = constainsText {
			switch base {
			case .status(let value):
				return #Predicate {
					$0.isDone == value && $0.text.contains(text)
				}
			case .list(let id):
				return #Predicate {
					$0.list?.uuid == id && $0.text.contains(text)
				}
			case .inFocus(let value):
				return #Predicate {
					$0.inFocus == value
				}
			}
		} else {
			switch base {
			case .status(let value):
				return #Predicate { $0.isDone == value }
			case .list(let id):
				return #Predicate { $0.list?.uuid == id }
			case .inFocus(let value):
				return #Predicate {
					$0.inFocus == value && $0.isDone == false
				}
			}
		}
	}
}

extension TodoFilter {

	enum Base {
		case status(_ value: Bool)
		case inFocus(_ value: Bool)
		case list(_ id: UUID?)
	}
}
