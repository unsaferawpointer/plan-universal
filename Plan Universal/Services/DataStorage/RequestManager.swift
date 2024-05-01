//
//  RequestManager.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 26.04.2024.
//

import Foundation

protocol RequestManagerProtocol {
	func predicate(for panel: Panel, containsText text: String?) -> TodoFilterV2
	func sorting(for panel: Panel) -> [TodoOrderV2]
	func configuration(for panel: Panel) -> TodoConfiguration
}

final class RequestManager {
	
}

// MARK: - RequestManagerProtocol
extension RequestManager: RequestManagerProtocol {

	func sorting(for panel: Panel) -> [TodoOrderV2] {
		switch panel {
		case .inFocus, .backlog:
			return [.priority(.reverse), .creationDate(.reverse)]
		case .list:
			return [.status(.forward), .priority(.reverse), .creationDate(.reverse)]
		case .completed:
			return [.completionDate(.reverse)]
		}
	}

	func predicate(for panel: Panel, containsText text: String?) -> TodoFilterV2 {
		switch panel {
		case .inFocus:
			return .init(base: .status(.inFocus), constainsText: text)
		case .backlog:
			return .init(base: .status(.backlog), constainsText: text)
		case .completed:
			return .init(base: .status(.done), constainsText: text)
		case .list(let value):
			return .init(base: .list(value.uuid), constainsText: text)
		}
	}

	func configuration(for panel: Panel) -> TodoConfiguration {
		switch panel {
		case .inFocus:
			return TodoConfiguration(text: "", status: .inFocus, priority: .low, list: nil)
		case .backlog:
			return TodoConfiguration(text: "", status: .backlog, priority: .low, list: nil)
		case .completed:
			return TodoConfiguration(text: "", status: .done, priority: .low, list: nil)
		case .list(let value):
			return TodoConfiguration(text: "", status: .backlog, priority: .low, list: value)
		}
	}
}
