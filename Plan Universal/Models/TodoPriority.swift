//
//  TodoPriority.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 05.04.2024.
//

import Foundation

enum TodoPriority: Int {
	case low
	case medium
	case high
}

// MARK: - CaseIterable
extension TodoPriority: CaseIterable { }

// MARK: - Calculated properties
extension TodoPriority {
	
	var title: String {
		switch self {
		case .low:
			"Low"
		case .medium:
			"Medium"
		case .high:
			"High"
		}
	}
}

// MARK: - Identifiable
extension TodoPriority: Identifiable {

	var id: Int {
		return rawValue
	}
}
