//
//  TodoStatus.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 05.04.2024.
//

import Foundation

enum TodoStatus: Int64 {
	case inFocus = 0
	case backlog = 1
	case done = 2
}

// MARK: - CaseIterable
extension TodoStatus: CaseIterable { }

// MARK: - Calculated properties
extension TodoStatus {

	var title: String {
		switch self {
		case .inFocus:
			String(localized: "In Focus")
		case .backlog:
			String(localized: "Backlog")
		case .done:
			String(localized: "Archieve")
		}
	}
}

// MARK: - Identifiable
extension TodoStatus: Identifiable {

	var id: Int64 {
		return rawValue
	}
}
