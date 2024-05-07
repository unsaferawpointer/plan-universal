//
//  DetailsView.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 05.04.2024.
//

import SwiftUI
import SwiftData

struct DetailsView: View {

	@Environment(\.modelContext) var modelContext

	#if os(iOS)
	private var isCompact: Bool {
		UIDevice.current.userInterfaceIdiom != .pad
	}
	#else
	private let isCompact = false
	#endif

	// MARK: - Local state

	@State private var editedTodo: TodoItem?

	@State private var todoDetailsIsPresented: Bool = false

	@State private var listDetailsIsPresented: Bool = false

	@State private var selection: Set<TodoItem.ID> = .init()

	// MARK: - Data

	@Query private var todos: [TodoItem]

	var model: DetailsModel

	// MARK: - Initialization

	init(panel: Panel) {
		self.model = .init(panel: panel)
		self._todos = Query(
			filter: model.predicate(containsText: nil).predicate,
			sort: model.sorting().map(\.sortDescriptor),
			animation: .default
		)
	}

	var body: some View {
		List(selection: $selection) {
			ForEach(todos) { todo in
				TodoRow(todo: todo)
					.contextMenu {
						makeMenu(todo)
					}
			}
			.listRowSeparator(.hidden)
			.listRowInsets(.init(top: 4, leading: 8, bottom: 4, trailing: 8))
		}
		#if os(iOS)
		.listStyle(.plain)
		#else
		.listStyle(.inset)
		#endif
		.sheet(item: $editedTodo) { todo in
			TodoDetailsView(action: .edit(todo))
		}
		.sheet(isPresented: $todoDetailsIsPresented) {
			TodoDetailsView(action: .new(model.todoConfiguration()))
		}
		.sheet(isPresented: $listDetailsIsPresented) {
			ListDetailsView(.new(.default))
		}
		.navigationTitle(model.title)
		.overlay {
			if todos.isEmpty {
				ContentUnavailableView(
					"No Todos",
					image: "ghost",
					description: Text("New todos you create will appear here.")
				)
			}
		}
		#if os(iOS)
		.toolbar {
			ToolbarItem(placement: .status) {
				Text("\(todos.count) Todos")
					.foregroundStyle(.secondary)
					.font(.callout)
			}

			if !isCompact {
				ToolbarItem(placement: .bottomBar) {
					Menu("Add", systemImage: "plus") {
						Button {
							self.listDetailsIsPresented = true
						} label: {
							Text("New List")
						}
						Button {
							self.todoDetailsIsPresented = true
						} label: {
							Text("New Todo")
						}
					} primaryAction: {
						self.todoDetailsIsPresented = true
					}
				}
			} else {
				ToolbarItem(placement: .bottomBar) {
					Button {
						self.todoDetailsIsPresented = true
					} label: {
						Image(systemName: "plus")
					}
				}
			}
		}
		#else
		.navigationSubtitle("\(todos.count) Todos")
		.toolbar {
			ToolbarItem(placement: .primaryAction) {
				Menu("Add", systemImage: "plus") {
					Button {
						self.listDetailsIsPresented = true
					} label: {
						Text("New List")
					}
				} primaryAction: {
					self.todoDetailsIsPresented = true
				}
			}
		}
		#endif
	}
}

// MARK: - Helpers
private extension DetailsView {

	@ViewBuilder
	func makeMenu(_ todo: TodoItem) -> some View {
		Button("Edit...") {
			self.editedTodo = todo
		}
		Divider()
		Section("Status") {
			ForEach(TodoStatus.allCases) { status in
				Button(status.title) {
					setStatus(status, todo: todo)
				}
			}
		}
		Divider()
		Section("Priority") {
			ForEach(TodoPriority.allCases) { priority in
				Button(priority.title) {
					setPriority(priority: priority, todo: todo)
				}
			}
		}
		Divider()
		Button(role: .destructive) {
			delete(todo)
		} label: {
			Text("Delete")
		}
	}
}

// MARK: - Helpers
private extension DetailsView {

	func newTodo() {
		self.todoDetailsIsPresented = true
	}

	func setPriority(priority: TodoPriority, todo: TodoItem) {
		withAnimation {
			model.setPriority(priority: priority, todo: todo)
		}
	}

	func setStatus(_ status: TodoStatus, todo: TodoItem) {
		withAnimation {
			model.setStatus(status, todo: todo)
		}
	}

	func delete(_ todo: TodoItem) {
		withAnimation {
			if selection.contains(todo.id) {
				let selected = todos.filter { selection.contains($0.id) }
				model.delete(selected, in: modelContext)
			} else {
				model.delete([todo], in: modelContext)
			}
		}
	}
}

#Preview {
	DetailsView(panel: .inFocus)
		.modelContainer(PreviewContainer.preview)
}

extension TodoPriority {

	var color: Color {
		switch self {
		case .low:
			return .secondary
		case .medium:
			return .yellow
		case .high:
			return .red
		}
	}
}
