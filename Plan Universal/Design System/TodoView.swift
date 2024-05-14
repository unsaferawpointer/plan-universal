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
				if todo.isUrgent {
					Image(systemName: "bolt.fill")
						.foregroundStyle(.yellow)
				}
				Text(todo.text)
					.strikethrough(todo.isDone)
					.foregroundStyle(todo.isDone ? .secondary : .primary)
			}
		}
		.onChange(of: todo.isDone) { oldValue, newValue in
			withAnimation {
				animate = newValue
			}
		}
	}
}

//#Preview {
//	TodoView()
//}
