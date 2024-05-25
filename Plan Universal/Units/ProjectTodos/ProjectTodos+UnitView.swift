//
//  ProjectTodos+UnitView.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 24.05.2024.
//

import SwiftUI
import SwiftData

extension ProjectTodos {

	struct UnitView {

		// MARK: - Data

		var project: ProjectItem

		@Query(animation: .default) private var lists: [ListItem]

		// MARK: - Locale state

		@State private var selection: Set<UUID> = .init()

		@State private var presentation: Presentation = .init()

		// MARK: - Initialization

		init(_ project: ProjectItem) {
			self.project = project
			let uuid = project.uuid
			let predicate = #Predicate<ListItem> {
				$0.project?.uuid == uuid
			}
			self._lists = Query(
				filter: predicate,
				sort: \ListItem.order,
				animation: .default
			)
		}
	}
}

// MARK: - View
extension ProjectTodos.UnitView: View {

	var body: some View {
		List(selection: $selection) {
			if !project.details.isEmpty {
				BannerView(
					systemIcon: "square.stack.3d.up",
					message: project.details,
					color: .secondary
				)
				.listRowSeparator(.hidden)
			}
			ForEach(lists) { list in
				ProjectTodos.ListSection(list: list, presentation: $presentation)
			}
		}
		.listStyle(.inset)
		.scrollIndicators(.never)
		.navigationTitle(project.name)
		.toolbar {
			ToolbarItem(placement: .primaryAction) {
				Button("Add", systemImage: "plus") {
					var configuration = ListConfiguration(title: "", details: "", isArchived: false, project: project)
					self.presentation.listAction = .new(configuration)
				}
			}
		}
		.sheet(item: $presentation.listAction) { action in
			ListDetailsView(action, project: project)
		}
		.sheet(item: $presentation.todoAction) { action in
			TodoDetailsView(action: action)
		}
	}
}
