//
//  InFocusLocalizationMock.swift
//  Plan UniversalTests
//
//  Created by Anton Cherkasov on 21.07.2024.
//

@testable import Plan_Universal

final class InFocusLocalizationMock {

	private (set) var invocations: [Action] = []

	var stubs: Stubs = Stubs()
}

// MARK: - InFocusLocalizationProtocol
extension InFocusLocalizationMock: InFocusLocalizationProtocol {

	func statusMessage(for totalCount: Int, incompleteCount: Int) -> String {
		invocations.append(.statusMessage(totalCount: totalCount, incompleteCount: incompleteCount))
		guard let stub = stubs.statusMessage else {
			fatalError()
		}
		return stub
	}

	func statusMessage(for totalCount: Int) -> String {
		invocations.append(.statusMessageV2(totalCount: totalCount))
		guard let stub = stubs.statusMessageV2 else {
			fatalError()
		}
		return stub
	}

	var noScheduledTodos: String {
		stubs.noScheduledTodos
	}
	
	var allTodosCompleted: String {
		stubs.allTodosCompleted
	}
}

// MARK: - Nested data structs
extension InFocusLocalizationMock {

	enum Action {
		case statusMessage(totalCount: Int, incompleteCount: Int)
		case statusMessageV2(totalCount: Int)
	}
	struct Stubs {
		var statusMessage: String?
		var statusMessageV2: String?
		var noScheduledTodos: String = .random
		var allTodosCompleted: String = .random
	}
}
