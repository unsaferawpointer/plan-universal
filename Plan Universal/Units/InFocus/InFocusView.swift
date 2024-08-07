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

	@State private var selection: Set<TodoItem> = .init()

	@State private var editedTodo: TodoItem?

	var model: InFocusModel = .init()

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
					TodoView(todo: todo, indicators: [.isUrgent])
						.tag(todo)
				}
				.listRowSeparator(.hidden)
			}
		}
		.contextMenu(forSelectionType: TodoItem.self) { newSelection in
			if newSelection.isEmpty {
				EmptyView()
			} else if newSelection.count == 1, let first = newSelection.first {
				Button("Edit...") {
					editedTodo = first
				}
				Divider()
				buildMenu(for: newSelection)
			} else {
				buildMenu(for: newSelection)
			}
		}
		#if os(macOS)
		.safeAreaInset(edge: .bottom) {
			if let status = model.estimationMessage(for: todos) {
				VStack(alignment: .center) {
					Divider()
					Text(status)
						.foregroundStyle(.secondary)
						.font(.callout)
						.padding(.init(top: 2, leading: 0, bottom: 8, trailing: 0))
				}
				.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
				.background(.thinMaterial)
			}
		}
		.alternatingRowBackgrounds()
		.navigationSubtitle(model.subtitle(for: todos))
		#endif
		.navigationTitle("Stack")
		.toolbar {
			#if os(macOS)
			ToolbarItem(placement: .primaryAction) {
				Button("Archieve", systemImage: "archivebox") {
					try? modelContext.transaction {
						for todo in todos where todo.isDone == true {
							todo.inFocus = false
						}
					}
				}
			}
			#else
			ToolbarItem(placement: .bottomBar) {
				Button("Done", systemImage: "checkmark") {
					try? modelContext.transaction {
						for todo in todos where todo.isDone == true {
							todo.inFocus = false
						}
					}
				}
			}
			ToolbarItem(placement: .bottomBar) {
				Button("Archieve", systemImage: "archivebox") {
					try? modelContext.transaction {
						for todo in todos where todo.isDone == true {
							todo.inFocus = false
						}
					}
				}
			}
			ToolbarItem(placement: .status) {
				VStack {
					Text(model.subtitle(for: todos))
						.foregroundStyle(.primary)
						.font(.caption)
					if let subtitle = model.estimationMessage(for: todos) {
						Text(subtitle)
							.foregroundStyle(.secondary)
							.font(.caption)
					}
				}
			}
			#endif
		}
		.sheet(item: $editedTodo) { todo in
			TodoDetails.UnitView(action: .edit(todo))
		}
	}
}

// MARK: - Helpers
private extension InFocusView {

	@ViewBuilder
	func buildMenu(for selection: Set<TodoItem>) -> some View {
		Toggle(sources: Binding(get: {
			return selection.map { $0 }
		}, set: { newValue in

		}), isOn: \.inFocus) {
			Text("In Stack")
		}
		Toggle(sources: Binding(get: {
			return selection.map { $0 }
		}, set: { newValue in

		}), isOn: \.isUrgent) {
			Text("Urgent")
		}
		Divider()
		Menu("Move To") {
			ListPicker { list in
				for todo in self.todos {
					todo.list = list
				}
			}
		}
		Divider()
		Menu("Estimation") {
			ForEach(TodoEstimation.allCases) { estimation in
				Button("\(estimation.storyPoints) pt") {
					for todo in self.todos {
						todo.rawEstimation = estimation.rawValue
					}
				}
			}
		}
		Divider()
		Button("Delete") {
			withAnimation {
				try? modelContext.transaction {
					for todo in selection {
						modelContext.delete(todo)
					}
				}
			}
		}
	}
}

#Preview {
	InFocusView()
}
