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

	#if os(iOS)
	@State private var editMode = EditMode.inactive
	#endif

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
			sort: \.creationDate,
			order: .forward,
			animation: .default
		)
	}

	var body: some View {
		List(selection: $selection) {
			ForEach(todos) { todo in
				TodoCell(todo: todo)
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
		#if os(iOS)
		.toolbar {
			if editMode == .inactive {
				ToolbarItem(placement: .primaryAction) {
					Button {
						newTodo()
					} label: {
						Image(systemName: "plus")
					}
				}
			}
			ToolbarItem {
				EditButton()
			}
			ToolbarItem(placement: .status) {
				Text("\(todos.count) Todos")
					.foregroundStyle(.secondary)
					.font(.callout)
			}
		}
		.environment(\.editMode, $editMode)
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

private extension DetailsView {

	#if os(iOS)
	private var addButton: some View {
		switch editMode {
		case .inactive:
			return AnyView(Button(action: newTodo) { Image(systemName: "plus") })
		default:
			return AnyView(EmptyView())
		}
	}
	#endif

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

	func setStatus(_ status: TodoStatus, todo: TodoItem) {
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

	func delete(_ todo: TodoItem) {
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

	func calculateSelection(_ todo: TodoItem) -> Set<TodoItem.ID> {
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
