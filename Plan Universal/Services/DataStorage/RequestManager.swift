//
//  RequestManager.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 26.04.2024.
//

import Foundation

protocol RequestManagerProtocol {
	func sorting(for panel: Panel) -> [TodoOrder]
	func listPredicate(isFavorite: Bool) -> ListFilter
	func projectPredicate() -> ProjectFilter
}

final class RequestManager { }

// MARK: - RequestManagerProtocol
extension RequestManager: RequestManagerProtocol {

	func sorting(for panel: Panel) -> [TodoOrder] {
		return [.creationDate(.reverse)]
	}

	func listPredicate(isFavorite: Bool) -> ListFilter {
		return ListFilter(isFavorite: isFavorite)
	}

	func projectPredicate() -> ProjectFilter {
		return ProjectFilter()
	}
}
