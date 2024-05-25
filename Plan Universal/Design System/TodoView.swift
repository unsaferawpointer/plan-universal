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

	init(todo: TodoItem) {
		self.todo = todo
		self._animate = State(initialValue: todo.isDone)
	}

	var body: some View {
		HStack {
			Checkmark(isDone: $animate)
				.frame(width: 13, height: 13)
				.onTapGesture {
					withAnimation {
						animate.toggle()
					} completion: {
						todo.isDone.toggle()
					}
				}
			HStack(spacing: 4) {
				if (todo.isUrgent || todo.inFocus) && !todo.isDone {
					Image(systemName: todo.inFocus ? "sparkles" : "bolt.fill")
						.foregroundStyle(todo.isDone ? Color.secondary : Color.yellow)
				}
				Text(todo.text)
					.foregroundStyle(todo.isDone ? .secondary : .primary)
			}
		}
		.onChange(of: todo.isDone) { oldValue, newValue in
			withAnimation(.easeInOut(duration: 0.3)) {
				animate = newValue
			}
		}
	}
}

//#Preview {
//	TodoView()
//}
