//
//  NavigationRow.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 10.04.2024.
//

import SwiftUI
import SwiftData

struct NavigationRow: View {

	private let title: String

	private let icon: String

	private let sign: String?

	// MARK: - Data

	@Query var todos: [TodoItem]

	// MARK: - Initialization

	init<T: Filter>(
		title: String,
		icon: String,
		sign: String?,
		filter: T
	) where T.Element == TodoItem {
		self.title = title
		self.icon = icon
		self.sign = sign
		self._todos = Query(filter: filter.predicate)
	}

	var body: some View {
		if !todos.isEmpty {
			if let sign {
				Label(title, systemImage: icon)
					.badge("\(Image(systemName: sign)) \(todos.count)")
					.badgeProminence(.increased)
					.imageScale(.small)
			} else {
				Label(title, systemImage: icon)
					.badge("\(todos.count)")
					.badgeProminence(.increased)
					.imageScale(.small)
			}
		} else {
			Label(title, systemImage: icon)
		}
	}
}

#Preview {
	NavigationRow(title: "In Focus", icon: "sparkles", sign: "bolt.fill", filter: TodoFilter(base: .status(true), constainsText: nil))
}
