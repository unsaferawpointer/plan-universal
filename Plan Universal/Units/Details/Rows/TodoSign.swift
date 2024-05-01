//
//  TodoSign.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 29.04.2024.
//

import SwiftUI

enum TodoSign {
	case priority(_ value: TodoPriority)
	case inFocus
}

extension TodoSign {

	var color: Color {
		switch self {
		case .priority(let value):
			return value.color
		case .inFocus:
			return .yellow
		}
	}

	var iconName: String {
		switch self {
		case .priority:
			"bolt.fill"
		case .inFocus:
			"sparckles"
		}
	}
}
