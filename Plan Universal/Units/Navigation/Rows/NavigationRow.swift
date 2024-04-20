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

	@ObservedObject var model: NavigationRowModel

	// MARK: - Initialization

	init(title: String, icon: String, filter: TodoFilter) {
		self.title = title
		self.icon = icon
		self._model = ObservedObject(initialValue: .init(filter: filter))
	}

	var body: some View {
		if !model.isEmpty {
			Label(title, systemImage: icon)
				.badge("\(Image(systemName: "bolt.fill")) \(model.count)")
				.badgeProminence(.increased)
				.imageScale(.small)
		} else {
			Label(title, systemImage: icon)
		}
	}
}

#Preview {
	NavigationRow(title: "In Focus", icon: "sparkles", filter: .all)
}
