//
//  DetailsView.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 05.04.2024.
//

import SwiftUI
import SwiftData

struct DetailsView: View {

	var behaviour: Behaviour

	@Binding var panel: Panel?

	// MARK: - Local state

	@State var selection: Set<TodoItem.ID> = .init()

	@State var isPresented: Bool = false

	@State var edited: TodoItem?

	// MARK: - Data

	@Query(
		sort: \TodoItem.creationDate,
		order: .forward,
		animation: .default
	) private var todos: [TodoItem]

	@Environment(\.modelContext) private var modelContext

	// MARK: - Initialization

	init(behaviour: Behaviour, panel: Binding<Panel?>) {
		self.behaviour = behaviour
		self._panel = panel
		self._todos = Query(
			filter: predicate(for: behaviour),
			sort: sortDescriptors(for: behaviour),
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
		.sheet(isPresented: $isPresented) {
			TodoDetailsView(behaviour: behaviour, todo: nil)
		}
		.sheet(item: $edited) { item in
			TodoDetailsView(behaviour: behaviour, todo: item)
		}
		.navigationTitle(panel?.title ?? "")
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
			self.edited = todo
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
		self.isPresented = true
	}

	func setPriority(priority: TodoPriority, todo: TodoItem) {
		withAnimation {
			let modificating = calculateSelection(todo)
			let items = todos.filter {
				modificating.contains($0.uuid)
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
				modificated.contains($0.uuid)
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
				modificated.contains($0.uuid)
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
		guard selection.contains(todo.uuid) else {
			return .init([todo.uuid])
		}
		return selection
	}

	func predicate(for behaviour: Behaviour) -> Predicate<TodoItem> {
		switch behaviour {
		case .status(let value):
			let rawValue = value.rawValue
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

	func sortDescriptors(for behaviour: Behaviour) -> [SortDescriptor<TodoItem>] {
		switch behaviour {
		case .status(let value):
			switch value {
			case .inFocus, .backlog:
				return [
							SortDescriptor(\TodoItem.rawPriority, order: .reverse),
							SortDescriptor(\TodoItem.creationDate, order: .forward)
					   ]
			case .done:
				return [SortDescriptor(\TodoItem.completionDate, order: .reverse)]
			}

		case .list(let value):
			return [
						SortDescriptor(\TodoItem.rawPriority, order: .reverse),
						SortDescriptor(\TodoItem.creationDate, order: .forward)
				   ]
		}
	}
}

#Preview {
	DetailsView(behaviour: .status(.inFocus), panel: .constant(.inFocus))
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
