//
//  TodoRow.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 05.04.2024.
//

import SwiftUI

#if os(iOS)
struct TodoRow {

	// MARK: - Data

	@ObservedObject var model: TodoRowModel

	// MARK: - Locale state

	#if os(iOS)
	@State var animate: Bool
	#endif

	// MARK: - Initialization

	init(todo: TodoItem) {
		self._model = ObservedObject(initialValue: .init(todo: todo))
		self._animate = State(initialValue: todo.isDone)
	}

}
#else
struct TodoRow {

	// MARK: - Data

	@ObservedObject var model: TodoRowModel

	// MARK: - Initialization

	init(todo: TodoItem) {
		self._model = ObservedObject(initialValue: .init(todo: todo))
	}

}
#endif

// MARK: - View
extension TodoRow: View {

	var body: some View {
		HStack(alignment: .center) {
			#if os(iOS)
			Checkmark(animate: $animate)
			#else
			Toggle("", isOn: $model.isDone)
				.toggleStyle(.checkbox)
				.labelsHidden()
			#endif
			Text(model.text)
				.strikethrough(model.isDone)
				.foregroundStyle(model.isDone ? .secondary: .primary)
				.lineLimit(2)
			Spacer()
			if let icon = model.signIcon {
				Image(systemName: icon)
					.foregroundStyle(model.signColor)
			}
		}
		.contentShape(Rectangle())
		#if os(iOS)
		.onTapGesture {
			withAnimation {
				animate.toggle()
			} completion: {
				model.isDone.toggle()
			}
		}
		.onChange(of: model.isDone) { oldValue, newValue in
			withAnimation {
				animate = newValue
			}
		}
		#endif
	}
}

#Preview {
	TodoRow(todo: .init(.init(text: "New todo")))
		.frame(height: 100)
}
