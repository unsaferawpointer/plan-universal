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

	@ObservedObject var model: NavigationRowModel

	// MARK: - Initialization

	init<Filter: CoreDataFilter>(
		title: String,
		icon: String,
		sign: String?,
		filter: Filter
	) where Filter.Entity == TodoEntity {
		self.title = title
		self.icon = icon
		self.sign = sign
		self._model = ObservedObject(initialValue: .init(filter: filter))
	}

	var body: some View {
		if !model.isEmpty {
			if let sign {
				Label(title, systemImage: icon)
					.badge("\(Image(systemName: sign)) \(model.count)")
					.badgeProminence(.increased)
					.imageScale(.small)
			} else {
				Label(title, systemImage: icon)
					.badge("\(model.count)")
					.badgeProminence(.increased)
					.imageScale(.small)
			}
		} else {
			Label(title, systemImage: icon)
		}
	}
}

#Preview {
	NavigationRow(title: "In Focus", icon: "sparkles", sign: "bolt.fill", filter: TodoFilter.all)
}
