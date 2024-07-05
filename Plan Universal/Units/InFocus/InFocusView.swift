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

	// MARK: - Locale state

	@State private var selection: Set<UUID> = .init()

	@State private var editedTodo: TodoItem?

	// MARK: - Initialization

	init() {

		let todosPredicate = #Predicate<TodoItem> {
			$0.inFocus == true
		}

		self._todos = Query(
			filter: todosPredicate,
			sort: \.isDone,
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
						for todo in todos where todo.isDone == true {
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
