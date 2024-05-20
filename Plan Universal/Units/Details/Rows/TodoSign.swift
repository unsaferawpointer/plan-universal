//
//  TodoSign.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 29.04.2024.
//

import SwiftUI

enum TodoSign {
	case urgent(_ value: Bool)
	case inFocus
}

extension TodoSign {

	var color: Color {
		switch self {
		case .urgent(let value):
			return value ? .yellow : .secondary
		case .inFocus:
			return .yellow
		}
	}

	var iconName: String {
		switch self {
		case .urgent:
			"bolt.fill"
		case .inFocus:
			"sparckles"
		}
	}
}
