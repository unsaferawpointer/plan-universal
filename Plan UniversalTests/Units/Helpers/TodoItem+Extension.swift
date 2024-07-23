//
//  TodoItem+Extension.swift
//  Plan UniversalTests
//
//  Created by Anton Cherkasov on 21.07.2024.
//

import Foundation
@testable import Plan_Universal

extension TodoItem {

	static var random: TodoItem {
		let configuration = TodoConfiguration(
			text: UUID().uuidString,
			isDone: Bool.random(),
			isUrgent: Bool.random(),
			estimation: nil,
			list: nil
		)
		return .init(configuration)
	}

	static var incomplete: TodoItem {
		let configuration = TodoConfiguration(
			text: UUID().uuidString,
			isDone: false,
			isUrgent: Bool.random(),
			estimation: nil,
			list: nil
		)
		return .init(configuration)
	}

	static var completed: TodoItem {
		let configuration = TodoConfiguration(
			text: UUID().uuidString,
			isDone: true,
			isUrgent: Bool.random(),
			estimation: nil,
			list: nil
		)
		return .init(configuration)
	}
}
