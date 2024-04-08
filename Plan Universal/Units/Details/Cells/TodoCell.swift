//
//  TodoCell.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 05.04.2024.
//

import SwiftUI

struct TodoCell {

	@Bindable var todo: TodoItem

	// MARK: - Calculated properties

	var showSign: Bool {
		return todo.isImportant
	}

	init(todo: TodoItem) {
		self.todo = todo
	}
}

#if os(macOS)
extension TodoCell: View {

	var body: some View {
		Toggle(isOn: $todo.isDone) {
			HStack(spacing: 2) {
				Group {
					Text(showSign ? "\(Image(systemName: "bolt.fill")) " : "")
						.foregroundStyle(todo.isDone ? .secondary : todo.priority.color)
					+ Text(todo.text)
						.strikethrough(todo.isDone)
						.foregroundStyle(todo.isDone ? .secondary: .primary)
				}
				.lineLimit(2)
				Spacer()
				if let list = todo.list?.title {
					Text(list)
						.foregroundStyle(.tertiary)
						.font(.body)
						.lineLimit(1)
				}
			}
		}
	}
}
#endif

#if os(iOS)
extension TodoCell: View {

	var body: some View {
		HStack {
			Image(systemName: todo.isDone ? "checkmark" : "app")
				.foregroundStyle(.tertiary)
				.contentShape(Rectangle())
				.onTapGesture {
					todo.isDone.toggle()
				}
			VStack(alignment: .leading, spacing: 2) {
				Group {
					Text(showSign ? "\(Image(systemName: "bolt.fill")) " : "")
						.foregroundStyle(todo.isDone ? .secondary : todo.priority.color)
					+ Text(todo.text)
						.foregroundStyle(todo.isDone ? .secondary: .primary)
						.strikethrough(todo.isDone)
				}
				.lineLimit(2)
				if let title = todo.list?.title {
					Text(title)
						.foregroundStyle(.secondary)
						.font(.caption)
						.lineLimit(1)
				}
			}
		}

	}
}
#endif

// MARK: - Helpers
private extension TodoCell {

	func makePrioritySign() -> some View {
		Image(systemName: "bolt.fill")
			.foregroundStyle(todo.priority.color)
	}
}

#Preview {
	TodoCell(todo: .new)
}
