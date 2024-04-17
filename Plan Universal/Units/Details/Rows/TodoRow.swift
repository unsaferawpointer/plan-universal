//
//  TodoRow.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 05.04.2024.
//

import SwiftUI

struct TodoRow {

	#if os(iOS)
	@Environment(\.horizontalSizeClass) private var horizontalSizeClass
	private var isCompact: Bool { horizontalSizeClass == .compact }
	#else
	private let isCompact = false
	#endif

	// MARK: - Data

	@ObservedObject var todo: TodoEntity

	// MARK: - Calculated properties

	var showSign: Bool {
		return todo.isImportant
	}

	init(todo: TodoEntity) {
		self.todo = todo
	}
}

#if os(macOS)
extension TodoRow: View {

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
extension TodoRow: View {

	var body: some View {
		HStack {
			if isCompact {
				makeCompact()
			} else {
				makeExtended()
			}
		}
		.contentShape(Rectangle())
		.onTapGesture {
			todo.isDone.toggle()
		}
	}
}
#endif

extension TodoRow {

	@ViewBuilder
	func makeCompact() -> some View {
		VStack(alignment: .leading, spacing: 2) {
			makeTitle()
			makeInfo()
		}
		Spacer()
		makeCheckmark()
	}

	@ViewBuilder
	func makeExtended() -> some View {
		HStack(alignment: .firstTextBaseline, spacing: 2) {
			makeTitle()
			Spacer()
			makeInfo()
		}
		makeCheckmark()
	}
}

// MARK: - Helpers
private extension TodoRow {

	@ViewBuilder
	func makeTitle() -> some View {
		Group {
			Text(showSign ? "\(Image(systemName: "bolt.fill")) " : "")
				.foregroundStyle(todo.isDone ? .secondary : todo.priority.color)
			+ Text(todo.text)
				.foregroundStyle(todo.isDone ? .secondary: .primary)
				.strikethrough(todo.isDone)
		}
		.lineLimit(2)
	}

	@ViewBuilder
	func makeInfo() -> some View {
		if let title = todo.list?.title {
			Text(title)
				.foregroundStyle(todo.isDone ? .tertiary : .secondary)
				.font(.body)
				.lineLimit(1)
		}
	}

	@ViewBuilder
	func makeCheckmark() -> some View {
		if todo.isDone {
			Image(systemName: "checkmark")
				.foregroundStyle(.primary)
		}
	}

	@ViewBuilder
	func makePrioritySign() -> some View {
		Image(systemName: "bolt.fill")
			.foregroundStyle(todo.priority.color)
	}
}

#Preview {
	TodoRow(todo: .new(in: .init(.mainQueue)))
}
