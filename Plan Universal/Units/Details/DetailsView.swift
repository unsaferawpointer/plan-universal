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

	@State var editedTodo: TodoEntity?

	@State var todoDetailsIsPresented: Bool = false

	// MARK: - Data

	@ObservedObject var model: DetailsModel

	// MARK: - Initialization

	init(panel: Panel) {
		self.panel = panel

		self._model = ObservedObject(initialValue: .init(panel: panel))
	}

	var body: some View {
		List(selection: $model.selection) {
			ForEach(model.todos) { todo in
				TodoRow(todo: todo)
					.contextMenu {
						makeMenu(todo)
					}
			}
			.listRowSeparator(.hidden)
		}
		.sheet(item: $editedTodo) { todo in
			TodoDetailsView(action: .edit(todo), with: .default)
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

			TodoDetailsView(action: .new, with: configuration)
		}
		.navigationTitle(panel.title)
		.overlay {
			if model.isEmpty {
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
				Text("\(model.count) Todos")
					.foregroundStyle(.secondary)
					.font(.callout)
			}
		}
		#else
		.navigationSubtitle("\(model.count) Todos")
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
	func makeMenu(_ todo: TodoEntity) -> some View {
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

	func setPriority(priority: TodoPriority, todo: TodoEntity) {
		withAnimation {
			model.setPriority(priority, todo: todo)
		}
	}

	func setStatus(_ status: TodoStatus, todo: TodoEntity) {
		withAnimation {
			model.setStatus(status, todo: todo)
		}
	}

	func delete(_ todo: TodoEntity) {
		withAnimation {
			model.delete(todo)
		}
	}

	func calculateSelection(_ todo: TodoEntity?) -> Set<TodoEntity.ID> {
		guard let todo else {
			return model.selection
		}
		guard model.selection.contains(todo.id) else {
			return .init([todo.id])
		}
		return model.selection
	}

//	func predicate(for panel: Panel) -> Predicate<TodoItem> {
//		switch panel {
//		case .inFocus:
//			let rawValue = TodoStatus.inFocus.rawValue
//			return #Predicate { todo in
//				todo.rawStatus == rawValue
//			}
//		case .backlog:
//			let rawValue = TodoStatus.backlog.rawValue
//			return #Predicate { todo in
//				todo.rawStatus == rawValue
//			}
//		case .archieve:
//			let rawValue = TodoStatus.done.rawValue
//			return #Predicate { todo in
//				todo.rawStatus == rawValue
//			}
//		case .list(let value):
//			let id = value.uuid
//			return #Predicate { todo in
//				todo.list?.uuid == id
//			}
//		}
//	}

//	func sortDescriptors(for panel: Panel?) -> [SortDescriptor<TodoItem>] {
//		switch panel {
//		case .inFocus, .backlog:
//			return [
//				SortDescriptor(\TodoItem.rawPriority, order: .reverse),
//				SortDescriptor(\TodoItem.creationDate, order: .forward)
//			       ]
//		case .archieve:
//			return [SortDescriptor(\TodoItem.completionDate, order: .reverse)]
//		default:
//			return [
//				SortDescriptor(\TodoItem.rawPriority, order: .reverse),
//				SortDescriptor(\TodoItem.creationDate, order: .forward)
//			       ]
//		}
//	}
}

#Preview {
	DetailsView(panel: .inFocus)
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
