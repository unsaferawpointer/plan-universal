//
//  DetailsView.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 05.04.2024.
//

import SwiftUI
import SwiftData

struct DetailsView: View {

	var panel: Panel

	// MARK: - Local state

	@State var selection: Set<TodoItem.ID> = .init()

	@State var editedTodo: TodoItem?

	@State var todoDetailsIsPresented: Bool = false

	// MARK: - Data

	@Query private var todos: [TodoItem]

	@Environment(\.modelContext) private var modelContext

	// MARK: - Initialization

	init(panel: Panel) {
		self.panel = panel
		self._todos = Query(
			filter: predicate(for: panel),
			sort: sortDescriptors(for: panel),
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
		}
		.sheet(item: $editedTodo) { todo in
			TodoDetailsView(todo.configuration) { configuration in
				todo.configuration = configuration
			}
		}
		.sheet(isPresented: $todoDetailsIsPresented) {
			let configuration: TodoConfiguration = {
				switch panel {
				case .inFocus:			.inFocus
				case .backlog:			.backlog
				case .archieve:			.done
				case .list(let value):	.init(list: value)
				}
			}()

			return TodoDetailsView(configuration) { newConfiguration in

				let trimmed = newConfiguration.text.trimmingCharacters(in: .whitespaces)
				let modificatedText = trimmed.isEmpty ? String(localized: "New Todo") : trimmed

				try? modelContext.transaction {
					let new: TodoItem = .new
					new.configuration = newConfiguration
					new.text = modificatedText

					modelContext.insert(new)
				}
			}
		}
		.navigationTitle(panel.title)
		.overlay {
			if todos.isEmpty {
				ContentUnavailableView.init(label: {
					Label("No Todos", systemImage: "tray.fill")
				}, description: {
					Text("New todos you create will appear here.")
				}, actions: {
					Button(action: {
						newTodo()
					}) {
						Text("New Todo")
					}
					.buttonStyle(.bordered)
				})
			}
		}
		#if os(iOS)
		.toolbar {
			ToolbarItem(placement: .bottomBar) {
				Spacer()
			}
			ToolbarItem(placement: .bottomBar) {
				Button(action: newTodo) {
					Image(systemName: "plus")
				}
			}
			ToolbarItem(placement: .status) {
				Text("\(todos.count) Todos")
					.foregroundStyle(.secondary)
					.font(.callout)
			}
		}
		#else
		.navigationSubtitle("\(todos.count) Todos")
		.toolbar {
			ToolbarItem(placement: .primaryAction) {
				Button {
					newTodo()
				} label: {
					Image(systemName: "plus")
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
			let modificating = calculateSelection(todo)
			let items = todos.filter {
				modificating.contains($0.id)
			}

			try? modelContext.transaction {
				for item in items {
					item.priority = priority
				}
			}
		}
	}

	func setStatus(_ status: TodoStatus, todo: TodoItem?) {
		withAnimation {
			let modificated = calculateSelection(todo)
			let items = todos.filter {
				modificated.contains($0.id)
			}
			try? modelContext.transaction {
				for item in items {
					item.status = status
				}
			}
		}
	}

	func delete(_ todo: TodoItem?) {
		withAnimation {
			let modificated = calculateSelection(todo)
			let items = todos.filter {
				modificated.contains($0.id)
			}
			try? modelContext.transaction {
				for item in items {
					modelContext.delete(item)
				}
			}
		}
	}

	func calculateSelection(_ todo: TodoItem?) -> Set<TodoItem.ID> {
		guard let todo else {
			return selection
		}
		guard selection.contains(todo.id) else {
			return .init([todo.id])
		}
		return selection
	}

	func predicate(for panel: Panel) -> Predicate<TodoItem> {
		switch panel {
		case .inFocus:
			let rawValue = TodoStatus.inFocus.rawValue
			return #Predicate { todo in
				todo.rawStatus == rawValue
			}
		case .backlog:
			let rawValue = TodoStatus.backlog.rawValue
			return #Predicate { todo in
				todo.rawStatus == rawValue
			}
		case .archieve:
			let rawValue = TodoStatus.done.rawValue
			return #Predicate { todo in
				todo.rawStatus == rawValue
			}
		case .list(let value):
			let id = value.uuid
			return #Predicate { todo in
				todo.list?.uuid == id
			}
		}
	}

	func sortDescriptors(for panel: Panel?) -> [SortDescriptor<TodoItem>] {
		switch panel {
		case .inFocus, .backlog:
			return [
				SortDescriptor(\TodoItem.rawPriority, order: .reverse),
				SortDescriptor(\TodoItem.creationDate, order: .forward)
			       ]
		case .archieve:
			return [SortDescriptor(\TodoItem.completionDate, order: .reverse)]
		default:
			return [
				SortDescriptor(\TodoItem.rawPriority, order: .reverse),
				SortDescriptor(\TodoItem.creationDate, order: .forward)
			       ]
		}
	}
}

#Preview {
	DetailsView(panel: .inFocus)
		.modelContainer(for: TodoItem.self, inMemory: true)
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
