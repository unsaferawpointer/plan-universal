//
//  TodoDetailsView.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 06.04.2024.
//

import SwiftUI

struct TodoDetailsView: View {

	@Environment(\.dismiss) var dismiss

	// MARK: - Data

	var behaviour: Behaviour

	var todo: TodoItem?

	@Environment(\.modelContext) private var modelContext

	// MARK: - Local state

	@State var text: String

	@State var priority: TodoPriority

	@FocusState var isFocused: Bool

	init(behaviour: Behaviour, todo: TodoItem?) {
		self.behaviour = behaviour
		self.todo = todo
		self._priority = State(initialValue: todo?.priority ?? .low)
		self._text = State(initialValue: todo?.text ?? "")
	}

	var body: some View {
		NavigationStack {
			Form {
				TextField("New Todo", text: $text)
					.focused($isFocused)
					.submitLabel(.return)
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
		guard let todo else {
			let new: TodoItem = .new

			switch behaviour {
			case .status(let value):
				new.status = value
			case .list(let value):
				new.list = value
			}

			let trimmed = text.trimmingCharacters(in: .whitespaces)
			new.text = trimmed.isEmpty ? String(localized: "New Todo") : trimmed

			new.priority = priority
			modelContext.insert(new)
			return
		}
		todo.text = text
		todo.priority = priority
	}
}

#Preview {
	TodoDetailsView(behaviour: .status(.inFocus), todo: .new)
}
