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

		@Environment(\.modelContext) var modelContext

		// MARK: - Data

		var project: ProjectItem

		@Query(animation: .default) private var lists: [ListItem]

		// MARK: - Locale state

		@State private var selection: Set<TodoItem> = .init()

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
		.contextMenu(forSelectionType: TodoItem.self) { newSelection in
			if newSelection.isEmpty {
				EmptyView()
			} else if newSelection.count == 1, let first = newSelection.first {
				Toggle("Completed", isOn: .init(get: {
					return first.isDone
				}, set: { newValue in
					first.isDone = newValue
				}))
				Toggle("Urgent", isOn: .init(get: {
					return first.isUrgent
				}, set: { newValue in
					first.isUrgent = newValue
				}))
				Divider()
				Button("Delete", systemImage: "trash") {
					modelContext.delete(first)
				}
			} else {
				Toggle(
					sources: Binding(get: {
						return newSelection.map { $0 }
					}, set: { _ in

					}),
					isOn: \.isUrgent
				) {
					Text("Urgent")
				}
				Divider()
				Button("Delete", systemImage: "trash") {
					try? modelContext.transaction {
						for todo in newSelection {
							modelContext.delete(todo)
						}
					}
				}
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
			ListDetails.UnitView(action, project: project)
		}
		.sheet(item: $presentation.todoAction) { action in
			TodoDetailsView(action: action)
		}
	}
}
