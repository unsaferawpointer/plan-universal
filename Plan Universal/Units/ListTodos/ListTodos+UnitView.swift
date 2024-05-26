//
//  ListTodos+UnitView.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 26.05.2024.
//

import SwiftUI
import SwiftData

extension ListTodos {

	struct UnitView {

		@Environment(\.modelContext) var modelContext

		// MARK: - Data

		var list: ListItem

		@Query(animation: .default) private var todos: [TodoItem]

		var model: Model = .init()

		// MARK: - Locale state

		@State private var selection: Set<TodoItem> = .init()

		@State private var presentation: Presentation = .init()

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
	}
}

// MARK: - View
extension ListTodos.UnitView: View {

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
					.contextMenu {
						Button("Edit...") {
							presentation.todoAction = .edit(todo)
						}
						Divider()
						Button("Delete") {
							model.delete(todo, in: modelContext)
						}
					}
					.tag(todo)
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
		.contextMenu(forSelectionType: TodoItem.self) { newSelection in
			if newSelection.isEmpty {
				Button("New Todo...") {
					presentation.todoAction = .edit(.init(.init(list: list)))
				}
			} else if newSelection.count == 1, let first = newSelection.first {
				Button("Edit...") {
					presentation.todoAction = .edit(first)
				}
				Divider()
				Button("Delete") {
					model.delete(first, in: modelContext)
				}
			} else {
				Button("Delete") {
					model.delete(newSelection, in: modelContext)
				}
			}
		}
		.listStyle(.inset)
		.scrollIndicators(.never)
		.navigationTitle(list.title)
		.toolbar {
			ToolbarItem(placement: .primaryAction) {
				Button("Add", systemImage: "plus") {
					self.presentation.todoAction = .new(.init(list: list))
				}
			}
		}
		.sheet(item: $presentation.todoAction) { action in
			TodoDetailsView(action: action)
		}
	}
}
