//
//  TodoDetailsView.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 06.04.2024.
//

import SwiftUI
import SwiftData

struct TodoDetailsView: View {

	@Environment(\.dismiss) var dismiss

	// MARK: - Data

	var todo: TodoItem?

	@Environment(\.modelContext) private var modelContext

	@Query private var lists: [ListItem]

	// MARK: - Local state

	@State var text: String = ""

	@State var status: TodoStatus = .backlog

	@State var priority: TodoPriority = .low

	@State var list: ListItem?

	@FocusState var isFocused: Bool

	init(behaviour: Behaviour, todo: TodoItem?) {
		guard let todo else {
			switch behaviour {
			case .status(let value):
				self._status =  State(initialValue: value)
			case .list(let value):
				self._list = State(initialValue: value)
			}
			return
		}

		self.todo = todo
		self._list = State(initialValue: todo.list)
		self._priority = State(initialValue: todo.priority)
		self._text = State(initialValue: todo.text)
		self._status = State(initialValue: todo.status)
	}

	var body: some View {
		NavigationStack {
			Form {
				TextField("New Todo", text: $text)
					.focused($isFocused)
					.submitLabel(.return)
				Picker("Status", selection: $status) {
					ForEach(TodoStatus.allCases) { status in
						Text(status.title)
							.tag(status)
					}
				}
				#if os(iOS)
				.pickerStyle(.inline)
				#else
				.pickerStyle(.menu)
				#endif
				Picker("Priority", selection: $priority) {
					ForEach(TodoPriority.allCases) { priority in
						Text(priority.title)
							.tag(priority)
					}
				}
				#if os(iOS)
				.pickerStyle(.inline)
				#else
				.pickerStyle(.menu)
				#endif
				Picker("List", selection: $list) {
					Text("None")
						.tag(Optional<ListItem>(nil))
					Divider()
					ForEach(lists) { list in
						Text(list.title)
							.tag(Optional<ListItem>(list))
					}
				}
			}
			.onAppear {
				self.isFocused = true
			}
			.toolbar {
				ToolbarItem(placement: .cancellationAction) {
					Button("Cancel") {
						dismiss()
					}
				}
				ToolbarItem(placement: .confirmationAction) {
					Button("Save", action: save)
				}
			}
		}
		#if os(macOS)
		.padding(/*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
		.frame(minWidth: 320)
		#endif
	}
}

// MARK: - Helpers
private extension TodoDetailsView {

	func save() {
		defer {
			dismiss()
		}

		let trimmed = text.trimmingCharacters(in: .whitespaces)
		let modificatedText = trimmed.isEmpty ? String(localized: "New Todo") : trimmed

		guard let todo else {
			let new: TodoItem = .new
			modificate(new, with: modificatedText)
			modelContext.insert(new)
			return
		}
		modificate(todo, with: modificatedText)
	}

	func modificate(_ item: TodoItem, with modificatedText: String) {
		item.status = status
		item.priority = priority
		item.text = modificatedText
		item.list = list
	}
}

#Preview {
	TodoDetailsView(behaviour: .status(.inFocus), todo: .new)
}
