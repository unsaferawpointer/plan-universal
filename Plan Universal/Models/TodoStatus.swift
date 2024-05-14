//
//  TodoStatus.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 05.04.2024.
//

import Foundation

enum TodoStatus: Int64 {
	case backlog
	case inFocus
	case done
	case archieved
}

// MARK: - CaseIterable
extension TodoStatus: CaseIterable { }

// MARK: - Calculated properties
extension TodoStatus {

	var title: String {
		switch self {
		case .backlog:
			String(localized: "Backlog")
		case .inFocus:
			String(localized: "In Focus")
		case .done:
			String(localized: "Done")
		case .archieved:
			String(localized: "Archieved")
		}
	}
}

// MARK: - Identifiable
extension TodoStatus: Identifiable {

	var id: Int64 {
		return rawValue
	}
}
