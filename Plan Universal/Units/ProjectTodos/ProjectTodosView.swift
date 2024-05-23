//
//  ProjectTodosView.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 16.05.2024.
//

import SwiftUI
import SwiftData

struct ProjectTodosView: View {

	@Environment(\.modelContext) var modelContext

	// MARK: - Data

	var project: ProjectItem

	@Query(animation: .default) private var lists: [ListItem]

	// MARK: - Locale state

	@State private var selection: Set<UUID> = .init()

	@State private var isListDetailsPresented: Bool = false

	@State private var editedList: ListItem?

	@State private var editedTodo: TodoItem?

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
				ListSectionView(
					list: list,
					editedList: $editedList,
					editedTodo: $editedTodo
				)
			}
		}
		.listStyle(.inset)
		.scrollIndicators(.never)
		.navigationTitle(project.name)
		.toolbar {
			ToolbarItem(placement: .primaryAction) {
				Button("Add", systemImage: "plus") {
					self.isListDetailsPresented = true
				}
			}
		}
		.sheet(isPresented: $isListDetailsPresented) {
			ListDetailsView(.new(.init()), project: project)
		}
		.sheet(item: $editedList) { list in
			ListDetailsView(.edit(list), project: project)
		}
		.sheet(item: $editedTodo) { todo in
			TodoDetailsView(action: .edit(todo), list: todo.list!)
		}
	}


}

//#Preview {
//	ProjectTodosView()
//}
