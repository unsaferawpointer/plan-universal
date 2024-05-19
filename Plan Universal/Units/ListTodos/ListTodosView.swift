//
//  ListTodosView.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 19.05.2024.
//

import SwiftUI
import SwiftData

struct ListTodosView: View {

	@Environment(\.modelContext) var modelContext

	// MARK: - Data

	var list: ListItem

	@Query(animation: .default) private var todos: [TodoItem]

	// MARK: - Locale state

	@State private var selection: Set<UUID> = .init()

	@State private var isTodoDetailsPresented: Bool = false

	@State private var editedTodo: TodoItem?

	// MARK: - Initialization

	init(_ list: ListItem) {
		self.list = list
		let uuid = list.uuid
		let predicate = #Predicate<TodoItem> {
			$0.list?.uuid == uuid
		}
		self._todos = Query(
			filter: predicate,
			sort: \TodoItem.order,
			animation: .default
		)
	}

	var body: some View {
		List(selection: $selection) {
			if !list.details.isEmpty {
				Text(list.details)
					.foregroundStyle(.secondary)
					.font(.body)
					.selectionDisabled()
			}
			ForEach(todos, id: \.uuid) { todo in
				TodoView(todo: todo)
			}
			.onMove { indices, newOffset in
				var sorted = todos
				sorted.move(fromOffsets: indices, toOffset: newOffset)

				withAnimation {
					try? modelContext.transaction {
						for (offset, todo) in sorted.enumerated() {
							todo.order = offset
						}
					}
				}
			}
			.listRowSeparator(.hidden)
		}
		.listStyle(.inset)
		.scrollIndicators(.never)
		.navigationTitle(list.title)
		.toolbar {
			ToolbarItem(placement: .primaryAction) {
				Button("Add", systemImage: "plus") {
					self.isTodoDetailsPresented = true
				}
			}
		}
//		.sheet(isPresented: $isTodoDetailsPresented) {
//			var configuration: TodoConfiguration = .default
//			configuration.list = list
//			return TodoDetailsView(action: .new(configuration))
//		}
		.sheet(item: $editedTodo) { todo in
			TodoDetailsView(action: .edit(todo))
		}
	}


}

//#Preview {
//	ListTodosView()
//}
