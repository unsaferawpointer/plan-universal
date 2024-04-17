//
//  Panel.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 05.04.2024.
//

import Foundation

/// An enum that represents the person's selection in the app's sidebar.
///
/// The `Panel` enum encodes the views the person can select in the sidebar, and hence appear in the detail view.
enum Panel: Hashable {
	case inFocus
	case backlog
	case archieve
	case list(_ value: ListEntity)
}

extension Panel {

	var title: String {
		switch self {
		case .inFocus:
			return String(localized: "In Focus")
		case .backlog:
			return String(localized: "Backlog")
		case .archieve:
			return String(localized: "Archieve")
		case .list(let value):
			return value.title
		}
	}
}
