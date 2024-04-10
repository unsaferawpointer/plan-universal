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

	// MARK: - Data

	@Query private var todos: [TodoItem]

	init(title: String, icon: String, predicate: Predicate<TodoItem>) {
		self.title = title
		self.icon = icon
		self._todos = Query(filter: predicate, animation: .default)
	}

	var body: some View {
		if !todos.isEmpty {
			Label(title, systemImage: icon)
				.badge("\(Image(systemName: "bolt.fill")) \(todos.count)")
				.badgeProminence(.increased)
				.imageScale(.small)
		} else {
			Label(title, systemImage: icon)
		}
	}
}

#Preview {
	NavigationRow(title: "In Focus", icon: "sparkles", predicate: .inFocus)
}
