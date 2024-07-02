//
//  InFocusView.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 16.05.2024.
//

import SwiftUI
import SwiftData

struct InFocusView: View {

	@Environment(\.modelContext) var modelContext

	// MARK: - Data

	@Query(animation: .default) private var todos: [TodoItem]

	@Query(animation: .default) private var completed: [TodoItem]

	// MARK: - Locale state

	@State private var selection: Set<UUID> = .init()

	@State private var editedTodo: TodoItem?

	// MARK: - Initialization

	init() {

		let todosPredicate = #Predicate<TodoItem> {
			$0.inFocus == true && $0.isDone == false
		}

		self._todos = Query(
			filter: todosPredicate,
			sort: \.order,
			animation: .default
		)

		let completedPredicate = #Predicate<TodoItem> {
			$0.isDone == true && $0.inFocus == true
		}

		self._completed = Query(
			filter: completedPredicate,
			sort: \.order,
			animation: .default
		)
	}

	var body: some View {
		List(selection: $selection) {
			Section {
				ForEach(todos, id: \.uuid) { todo in
					TodoView(todo: todo)
						.contextMenu {
							buildMenu(for: todo)
						}
				}
				.listRowSeparator(.hidden)
			}
			if !completed.isEmpty {
				Section {
					ForEach(completed, id: \.uuid) { todo in
						TodoView(todo: todo)
							.contextMenu {
								buildMenu(for: todo)
							}
					}
					.listRowSeparator(.hidden)
				} header: {
					HStack {
						Text("Completed")
							.font(.headline)
						Spacer()
					}
				}
				.listSectionSeparator(.hidden)
			}
		}
		#if os(macOS)
		.alternatingRowBackgrounds()
		#endif
		.navigationTitle("In Focus")
		#if os(macOS)
		.navigationSubtitle("10 Items")
		#endif			
		.toolbar {
			ToolbarItem(placement: .primaryAction) {
				Button("Archieve", systemImage: "archivebox") {
					try? modelContext.transaction {
						for todo in completed {
							todo.inFocus = false
						}
					}
				}
			}
		}
		.sheet(item: $editedTodo) { todo in
			TodoDetails.UnitView(action: .edit(todo))
		}
	}
}

// MARK: - Helpers
private extension InFocusView {

	@ViewBuilder
	func buildMenu(for todo: TodoItem) -> some View {
		Button("Move to backlog") {
			todo.inFocus = false
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

#Preview {
	InFocusView()
}
