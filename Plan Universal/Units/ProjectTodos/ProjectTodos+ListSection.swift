//
//  ListSectionView.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 19.05.2024.
//

import SwiftUI
import SwiftData

extension ProjectTodos {

	struct ListSection {

		@Environment(\.modelContext) var modelContext

		// MARK: - Data

		@State var list: ListItem

		@Query var todos: [TodoItem]

		// MARK: - Locale state

		@Binding var presentation: Presentation

		// MARK: - Initialization

		init(list: ListItem, presentation: Binding<Presentation>) {
			self.list = list

			let uuid = list.uuid
			let predicate = #Predicate<TodoItem> {
				$0.list?.uuid == uuid
			}

			self._presentation = presentation
			self._todos = Query(filter: predicate, sort: \.order, animation: .default)
		}
	}
}

// MARK: - View
extension ProjectTodos.ListSection: View {


	var body: some View {
		Section {
			ForEach(todos, id: \.uuid) { todo in
				TodoView(todo: todo)
					.contextMenu {
						Button("Focus On") {
							todo.inFocus = true
						}
						Divider()
						Button("Edit Todo...") {
							presentation.todoAction = .edit(todo)
						}
						Divider()
						Button("Delete") {
							withAnimation {
								modelContext.delete(todo)
							}
						}
					}
					.tag(todo)
			}
			.listRowSeparator(.hidden)
		} header: {
			VStack(alignment: .leading) {
				HStack {
					Text(list.title)
						.foregroundStyle(.primary)
						.font(.headline)
					Spacer()
					Menu {
						Button("Add Todo") {
							presentation.todoAction = .new(.init(list: list))
						}
						Divider()
						Button("Edit...") {
							presentation.listAction = .edit(list)
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
				if !list.details.isEmpty {
					Text(list.details)
						.foregroundStyle(.secondary)
						.font(.body)
						.selectionDisabled()
						.listRowSeparator(.hidden)
				}
			}
		}
	}
}
