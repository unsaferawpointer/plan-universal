//
//  TodoListUnitView.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 26.05.2024.
//

import SwiftUI
import SwiftData

struct TodoListUnitView {

	@Environment(\.modelContext) var modelContext

	// MARK: - Data

	var list: ListItem

	@Query(animation: .default) private var todos: [TodoItem]

	var model: TodoListModel = .init()

	// MARK: - Locale state

	@State private var selection: Set<TodoItem> = .init()

	@State private var presentation: TodoListPresentation = .init()

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

// MARK: - View
extension TodoListUnitView: View {

	var body: some View {
		List(selection: $selection) {
			ForEach(todos, id: \.uuid) { todo in
				TodoView(todo: todo, indicators: [.inFocus, .isUrgent])
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
				Toggle(sources: Binding(get: {
					return newSelection.map { $0 }
				}, set: { newValue in

				}), isOn: \.inFocus) {
					Text("In Stack")
				}
				Divider()
				Button("Delete") {
					model.delete(first, in: modelContext)
				}
			} else {
				Toggle(sources: Binding(get: {
					return newSelection.map { $0 }
				}, set: { newValue in

				}), isOn: \.inFocus) {
					Text("In Stack")
				}
				Divider()
				Button("Delete") {
					model.delete(newSelection, in: modelContext)
				}
			}
		}
		.listStyle(.inset)
		.scrollIndicators(.never)
		#if os(macOS)
		.alternatingRowBackgrounds()
		#endif
		.navigationTitle(list.title)
		.toolbar {
			ToolbarItem(placement: .primaryAction) {
				Button("Add", systemImage: "plus") {
					self.presentation.todoAction = .new(.init(list: list))
				}
			}
			#if os(iOS)
			ToolbarItem(placement: .primaryAction) {
				EditButton()
			}
			#endif
		}
		.sheet(item: $presentation.todoAction) { action in
			TodoDetails.UnitView(action: action)
		}
	}
}
