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
			"In Focus"
		case .backlog:
			"Backlog"
		case .done:
			"Archieve"
		}
	}
}

// MARK: - Identifiable
extension TodoStatus: Identifiable {

	var id: Int {
		return rawValue
	}
}
