//
//  ListSectionView.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 19.05.2024.
//

import SwiftUI
import SwiftData

struct ListSectionView: View {

	@Environment(\.modelContext) var modelContext

	// MARK: - Data

	@State var list: ListItem

	@Query var todos: [TodoItem]

	// MARK: - Locale state

	@Binding var editedList: ListItem?

	@Binding var editedTodo: TodoItem?

	// MARK: - Initialization

	init(list: ListItem, editedList: Binding<ListItem?>, editedTodo: Binding<TodoItem?>) {
		self.list = list

		let uuid = list.uuid
		let predicate = #Predicate<TodoItem> {
			$0.list?.uuid == uuid
		}

		self._editedList = editedList
		self._editedTodo = editedTodo
		self._todos = Query(filter: predicate, sort: \.order, animation: .default)
	}

	var body: some View {
		Section {
			if !list.details.isEmpty {
				Text(list.details)
					.foregroundStyle(.secondary)
					.font(.body)
					.selectionDisabled()
			}
			ForEach(todos) { todo in
				TodoView(todo: todo)
					.contextMenu {
						Button("Focus On") {
							todo.inFocus = true
						}
						Divider()
						Button("Edit Todo...") {
							editedTodo = todo
						}
						Divider()
						Button("Delete") {
							withAnimation {
								modelContext.delete(todo)
							}
						}
					}
			}
			.listRowSeparator(.hidden)
		} header: {
			HStack {
				Text(list.title)
					.foregroundStyle(.primary)
					.font(.headline)
				Spacer()
				Menu {
					Button("Add Todo") {
						withAnimation {
							let configuration = TodoConfiguration(
								text: "New Todo",
								isDone: false,
								isUrgent: false,
								list: list
							)
							DataManager().insert(configuration, toList: list, in: modelContext)
						}
					}
					Divider()
					Button("Edit...") {
						editedList = list
					}
					Divider()
					Button("Delete") {
						withAnimation {
							modelContext.delete(list)
						}
					}
				} label: {
					Image(systemName: "ellipsis")
				}
				.menuIndicator(.hidden)
				.menuStyle(BorderlessButtonMenuStyle())
				.fixedSize()
			}
			.listRowSeparator(.visible)
		}
	}
}

// MARK: - Helpers
private extension ListSectionView {

	@ViewBuilder
	func makeMenu() -> some View {

	}
}

//#Preview {
//	ListSectionView()
//}
