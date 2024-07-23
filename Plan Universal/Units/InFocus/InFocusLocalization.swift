//
//  InFocusLocalization.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 20.07.2024.
//

import Foundation

protocol InFocusLocalizationProtocol {
	func statusMessage(for totalCount: Int, incompleteCount: Int) -> String
	func statusMessage(for totalCount: Int) -> String
	var noScheduledTodos: String { get }
	var allTodosCompleted: String { get }
}

final class InFocusLocalization { }

// MARK: - InFocusLocalizationProtocol
extension InFocusLocalization: InFocusLocalizationProtocol {

	func statusMessage(for totalCount: Int, incompleteCount: Int) -> String {
		let leading = String(localized: "\(totalCount) todos")
		let trailing = String(localized: "\(incompleteCount) incomplete")
		return leading + " - " + trailing
	}

	func statusMessage(for totalCount: Int) -> String {
		return String(localized: "\(totalCount) todos")
	}

	var noScheduledTodos: String {
		String(localized: "No scheduled todos")
	}

	var allTodosCompleted: String {
		String(localized: "All tasks completed")
	}
}
