//
//  TodoPriority.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 05.04.2024.
//

import Foundation

enum TodoPriority: Int64 {
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
			String(localized: "Low")
		case .medium:
			String(localized: "Medium")
		case .high:
			String(localized: "High")
		}
	}
}

// MARK: - Identifiable
extension TodoPriority: Identifiable {

	var id: Int64 {
		return rawValue
	}
}
