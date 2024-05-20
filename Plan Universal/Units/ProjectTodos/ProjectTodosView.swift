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
			BannerView(
				systemIcon: "doc.text",
				message: project.name,
				color: .secondary
			)
			.listRowSeparator(.hidden)
			ForEach(lists) { list in
				ListSectionView(list: list, editedList: $editedList, editedTodo: $editedTodo)
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
			var configuration: ListConfiguration = .default
			configuration.project = project
			return ListDetailsView(.new(configuration))
		}
		.sheet(item: $editedList) { list in
			ListDetailsView(.edit(list))
		}
		.sheet(item: $editedTodo) { todo in
			TodoDetailsView(action: .edit(todo))
		}
	}


}

//#Preview {
//	ProjectTodosView()
//}
