//
//  TodoView.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 19.05.2024.
//

import SwiftUI

struct TodoView: View {

	@State var todo: TodoItem

	@State var animate: Bool = false

	@State var text: String

	@State var indicators: Indicators = []

	init(todo: TodoItem, indicators: Indicators) {
		self.todo = todo
		self._indicators = State(initialValue: indicators)
		self._animate = State(initialValue: todo.isDone)
		self._text = State(initialValue: todo.text)
	}

	#if os(macOS)
	var body: some View {
		HStack {
			Circle()
				.foregroundStyle(
					todo.inFocus && indicators.contains(.inFocus) 
						? Color.accentColor
						: .clear
				)
				.frame(width: 6, height: 6)
			Toggle("", isOn: $todo.isDone)
				.labelsHidden()
			TextField("Description", text: $text)
				.foregroundStyle(todo.isDone ? .secondary : .primary)
				.onSubmit {
					todo.text = text
				}
			Spacer()
			if let storyPoints = todo.estimation?.storyPoints {
				Text("\(storyPoints)")
					.foregroundStyle(.secondary)
			}
			if indicators.contains(.isUrgent) {
				Image(systemName: "bolt.fill")
					.foregroundStyle(todo.isDone ? Color.secondary : Color.yellow)
					.opacity(todo.isUrgent ? 1 : 0)
			}
		}
		.onChange(of: todo.isDone) { oldValue, newValue in
			withAnimation(.easeInOut(duration: 0.3)) {
				animate = newValue
			}
		}
	}
	#else
	var body: some View {
		HStack {
			if indicators.contains(.isUrgent) && todo.isUrgent {
				Image(systemName: "bolt.fill")
					.foregroundStyle(todo.isDone ? Color.secondary : Color.yellow)
			}
			Text(todo.text)
				.foregroundStyle(todo.isDone ? .secondary : .primary)
			if let storyPoints = todo.estimation?.storyPoints {
				Text("\(storyPoints)")
					.foregroundStyle(.secondary)
					.font(.callout)
			}
			Spacer()
			Image(systemName: todo.isDone ? "checkmark" : "")
				.frame(width: 24, height: 24)
		}
		.contentShape(Rectangle())
		.onTapGesture {
			withAnimation {
				animate.toggle()
			} completion: {
				todo.isDone.toggle()
			}
		}
		.onChange(of: todo.isDone) { oldValue, newValue in
			withAnimation(.easeInOut(duration: 0.3)) {
				animate = newValue
			}
		}
	}
	#endif
}

extension TodoView {

	struct Indicators: OptionSet {

		static var inFocus = Indicators(rawValue: 1 << 0)

		static var isUrgent = Indicators(rawValue: 1 << 1)

		var rawValue: Int

		init(rawValue: Int) {
			self.rawValue = rawValue
		}
	}
}

#Preview {
	TodoView(todo: .init(), indicators: [.inFocus, .isUrgent])
}
