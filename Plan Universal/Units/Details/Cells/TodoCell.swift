//
//  TodoCell.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 05.04.2024.
//

import SwiftUI

#if os(macOS)
struct TodoCell: View {

	@Bindable var todo: TodoItem

	// MARK: - Local state

	@State var text: String

	init(todo: TodoItem) {
		self.todo = todo
		self._text = State(initialValue: todo.text)
	}

	var body: some View {
		Toggle(isOn: $todo.isDone) {
			HStack(spacing: 2) {
				if todo.isImportant && !todo.isDone {
					Image(systemName: "bolt.fill")
						.foregroundStyle(todo.priority.color)
				}
				if todo.isDone {
					Text(text)
						.foregroundStyle(.secondary)
						.strikethrough(todo.isDone)
				} else {
					TextField("", text: $text)
						.textFieldStyle(.plain)
						.foregroundStyle(.primary)
						.focusable(true, interactions: .edit)
						.onSubmit {
							todo.text = text
						}
				}
				Spacer()
				if let list = todo.list?.title {
					Text(list)
						.foregroundStyle(.tertiary)
						.font(.body)
				}
			}
		}
	}
}
#endif

#if os(iOS)
struct TodoCell: View {

	@Bindable var todo: TodoItem

	var body: some View {
		HStack {
			Image(systemName: todo.isDone ? "checkmark" : "app")
				.foregroundStyle(.tertiary)
				.onTapGesture {
					todo.status = .done
				}
			VStack(alignment: .leading, spacing: 2) {
				HStack {
					if todo.isImportant {
						Image(systemName: "bolt.fill")
							.foregroundStyle(.yellow)
					}
					TextField("Todo...", text: $todo.text)
						#if os(iOS)
						.textFieldStyle(.plain)
						#endif
				}
				Text(todo.list?.title ?? "Programming")
					.foregroundStyle(.secondary)
					.font(.caption)
			}
		}

	}
}
#endif



#Preview {
	TodoCell(todo: .random)
}

extension TodoItem {

	static var random: TodoItem {
		return .init(
			uuid: .init(),
			text: "New todo",
			rawStatus: 0,
			rawPriority: 0,
			creationDate: .now,
			completionDate: nil,
			list: nil
		)
	}
}
