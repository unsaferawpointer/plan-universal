//
//  TodoListUnitView.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 26.05.2024.
//

import SwiftUI
import SwiftData

struct TodoListUnitView {

	@Environment(\.modelContext) var modelContext

	// MARK: - Data

	var list: ListItem

	@Query(animation: .default) private var todos: [TodoItem]

	var model: TodoListModel = .init()

	// MARK: - Locale state

	@State private var selection: Set<TodoItem> = .init()

	@State private var presentation: TodoListPresentation = .init()

	// MARK: - Initialization

	init(_ list: ListItem) {
		self.list = list
		let uuid = list.uuid
		let predicate = #Predicate<TodoItem> {
			$0.list?.uuid == uuid
		}
		self._todos = Query(
			filter: predicate,
			sort: \TodoItem.order,
			animation: .default
		)
	}
}

// MARK: - View
extension TodoListUnitView: View {

	var body: some View {
		List(selection: $selection) {
			ForEach(todos, id: \.uuid) { todo in
				TodoView(todo: todo, indicators: [.inFocus, .isUrgent])
					.tag(todo)
			}
			.onMove { indices, newOffset in
				var sorted = todos
				sorted.move(fromOffsets: indices, toOffset: newOffset)

				withAnimation {
					try? modelContext.transaction {
						for (offset, todo) in sorted.enumerated() {
							todo.order = offset
						}
					}
				}
			}
			.listRowSeparator(.hidden)
		}
		.contextMenu(forSelectionType: TodoItem.self) { newSelection in
			if newSelection.isEmpty {
				Button("New Todo...") {
					presentation.todoAction = .edit(.init(.init(list: list)))
				}
			} else if newSelection.count == 1, let first = newSelection.first {
				Button("Edit...") {
					presentation.todoAction = .edit(first)
				}
				Divider()
				buildMenu(for: newSelection)
			} else {
				buildMenu(for: newSelection)
			}
		}
		.listStyle(.inset)
		.scrollIndicators(.never)
		#if os(macOS)
		.safeAreaInset(edge: .bottom) {
			if let status = model.estimationMessage(for: todos) {
				VStack(alignment: .center) {
					Divider()
					Text(status)
						.foregroundStyle(.secondary)
						.font(.callout)
						.padding(.init(top: 0, leading: 0, bottom: 8, trailing: 0))
				}
				.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
				.background(.thinMaterial)
			}
		}
		.alternatingRowBackgrounds()
		.navigationSubtitle(model.subtitle(for: todos))
		#endif
		.navigationTitle(list.title)
		.toolbar {
			ToolbarItem(placement: .primaryAction) {
				Button("Add", systemImage: "plus") {
					self.presentation.todoAction = .new(.init(list: list))
				}
			}
			#if os(iOS)
			ToolbarItem(placement: .primaryAction) {
				EditButton()
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
		.sheet(item: $presentation.todoAction) { action in
			TodoDetails.UnitView(action: action)
		}
	}
}

// MARK: - Helpers
private extension TodoListUnitView {

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
			Button("None") {
				for todo in selection {
					todo.rawEstimation = nil
				}
			}
			Divider()
			ForEach(TodoEstimation.allCases) { estimation in
				Button("\(estimation.storyPoints) pt") {
					for todo in selection {
						todo.rawEstimation = estimation.rawValue
					}
				}
			}
		}
		Divider()
		Button("Delete") {
			model.delete(selection, in: modelContext)
		}
	}
}
