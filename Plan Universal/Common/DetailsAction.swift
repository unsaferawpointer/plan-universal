//
//  DetailsAction.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 17.04.2024.
//

import Foundation

enum DetailsAction<Value> {
	case new
	case edit(_ value: Value)
}

extension DetailsAction {

	var wrappedValue: Value? {
		switch self {
		case .new:
			return nil
		case .edit(let value):
			return value
		}
	}
}
