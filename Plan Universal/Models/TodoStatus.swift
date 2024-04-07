//
//  TodoStatus.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 05.04.2024.
//

import Foundation

enum TodoStatus: Int {
	case inFocus
	case backlog
	case done
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

	var id: Int {
		return rawValue
	}
}
