//
//  Predicate+Extension.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 10.04.2024.
//

import Foundation

extension Predicate {

	static var inFocus: Predicate<TodoItem> {
		let rawValue = TodoStatus.inFocus.rawValue
		return #Predicate {
			$0.rawStatus == rawValue
		}
	}
}
