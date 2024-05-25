//
//  Action.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 17.04.2024.
//

import Foundation

enum Action<Item: ConfigurableItem> {
	case new(_ configuration: Item.Configuration)
	case edit(_ item: Item)
}

// MARK: - Computed properties
extension Action {

	var wrappedValue: Item? {
		switch self {
		case .new:
			return nil
		case .edit(let item):
			return item
		}
	}

	var configuration: Item.Configuration {
		switch self {
		case .new(let initialConfiguration):
			return initialConfiguration
		case .edit(let item):
			return item.configuration
		}
	}
}

extension Action: Identifiable where Item: Identifiable, Item.Configuration: Hashable {

	var id: AnyHashable {
		switch self {
		case .new(let configuration):
			return configuration
		case .edit(let item):
			return item.id
		}
	}
}

extension Action: Equatable where Item: Equatable, Item.Configuration: Equatable { }
