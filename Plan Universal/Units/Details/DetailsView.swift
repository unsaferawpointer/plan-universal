//
//  DetailsView.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 05.04.2024.
//

import SwiftUI
import SwiftData

struct DetailsView: View {

	#if os(iOS)
	private var isCompact: Bool {
		UIDevice.current.userInterfaceIdiom != .pad
	}
	#else
	private let isCompact = false
	#endif

	var panel: Panel

	// MARK: - Local state

	@State private var editedTodo: TodoEntity?

	@State private var todoDetailsIsPresented: Bool = false

	@State private var listDetailsIsPresented: Bool = false

	// MARK: - Data

	@ObservedObject private var model: DetailsModel

	// MARK: - Initialization

	init(panel: Panel) {
		self.panel = panel
		self._model = ObservedObject(initialValue: .init(panel: panel))
	}

	var body: some View {
		List(selection: $model.selection) {
			ForEach(model.todos) { todo in
				DetailsTodoRow(todo: todo, elements: model.elements)
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
				case .completed:			.done
				case .list(let value):	.init(list: value)
				}
			}()

			TodoDetailsView(action: .new, with: configuration)
		}
		.sheet(isPresented: $listDetailsIsPresented) {
			ListDetailsView(.new)
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

			ToolbarItem(placement: .status) {
				Text("\(model.count) Todos")
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
		.navigationSubtitle("\(model.count) Todos")
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
