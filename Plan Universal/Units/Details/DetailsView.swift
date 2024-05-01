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

	var panel: Panel

	// MARK: - Local state

	@State private var editedTodo: TodoItem?

	@State private var todoDetailsIsPresented: Bool = false

	@State private var listDetailsIsPresented: Bool = false

	@State private var selection: Set<TodoItem.ID> = .init()

	// MARK: - Data

	@Query private var todos: [TodoItem]

	// MARK: - Utilities

	private var dataManager: DataManager = .init()

	let requestManager = RequestManager()

	// MARK: - Initialization

	init(panel: Panel) {
		self.panel = panel
		let filter = requestManager.predicate(for: panel, containsText: nil).predicate
		self._todos = Query(filter: filter, sort: requestManager.sorting(for: panel).map(\.sortDescriptor), animation: .default)
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
			TodoDetailsView(action: .new(requestManager.todoConfiguration(for: panel)))
		}
		.sheet(isPresented: $listDetailsIsPresented) {
			ListDetailsView(.new(.init(uuid: UUID(), title: "", isArchieved: false, isFavorite: false)))
		}
		.navigationTitle(panel.title)
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
			dataManager.update(todo, keyPath: \.priority, value: priority)
		}
	}

	func setStatus(_ status: TodoStatus, todo: TodoItem) {
		withAnimation {
			dataManager.update(todo, keyPath: \.status, value: status)
		}
	}

	func delete(_ todo: TodoItem) {
		withAnimation {
			if selection.contains(todo.id) {
				let selected = todos.filter { selection.contains($0.id) }
				try? modelContext.transaction {
					for item in selected {
						modelContext.delete(item)
					}
				}
			} else {
				dataManager.delete(todo, in: modelContext)
			}
		}
	}
}

#Preview {
	DetailsView(panel: .inFocus)
		.modelContainer(previewContainer)
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
