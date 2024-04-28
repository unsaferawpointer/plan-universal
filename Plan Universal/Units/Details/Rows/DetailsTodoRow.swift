//
//  DetailsTodoRow.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 05.04.2024.
//

import SwiftUI

struct DetailsTodoRow {

	#if os(iOS)
	@Environment(\.horizontalSizeClass) private var horizontalSizeClass
	private var isCompact: Bool { horizontalSizeClass == .compact }
	#endif

	// MARK: - Data

	@ObservedObject var model: DetailsTodoRowModel

	// MARK: - Local state

	@State var animation: Bool = true

	// MARK: - Initialization

	init(todo: TodoItem, elements: DetailsTodoRowElements) {
		self._animation = State(initialValue: todo.isDone)

		let model = DetailsTodoRowModel(todo: todo, elemens: elements)
		self._model = ObservedObject(initialValue: model)
	}
}

#if os(macOS)
extension DetailsTodoRow: View {

	var body: some View {
		HStack(alignment: .center) {
			Toggle("", isOn: .init {
				model.isDone
			} set: { newValue in
				model.setCompletion(newValue)
			})
			.toggleStyle(.checkbox)
			.labelsHidden()

			HStack(spacing: 2) {
				Group {
					Text(model.showSign ? "\(Image(systemName: "bolt.fill")) " : "")
						.foregroundStyle(model.isDone ? .secondary : model.signColor)
					+ Text(model.text)
						.strikethrough(model.isDone)
						.foregroundStyle(model.isDone ? .secondary: .primary)
				}
				.lineLimit(2)
				Spacer()
				if let list = model.listTitle, model.showList {
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
extension DetailsTodoRow: View {

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
			withAnimation(.easeInOut(duration: 0.2)) {
				animation.toggle()
			} completion: {
				withAnimation {
					model.setCompletion(animation)
				}
				let impact = UIImpactFeedbackGenerator(style: .medium)
				impact.impactOccurred()
			}
		}
	}
}

extension DetailsTodoRow {

	@ViewBuilder
	func makeCompact() -> some View {
		Checkmark(animate: $animation)
		VStack(alignment: .leading, spacing: 2) {
			makeTitle()
			makeInfo()
		}
		Spacer()

	}

	@ViewBuilder
	func makeExtended() -> some View {
		Checkmark(animate: $animation)
		HStack(alignment: .firstTextBaseline, spacing: 2) {
			makeTitle()
			Spacer()
			makeInfo()
		}
	}
}
#endif

// MARK: - Helpers
private extension DetailsTodoRow {

	@ViewBuilder
	func makeTitle() -> some View {
		Group {
			Text(model.showSign ? "\(Image(systemName: "bolt.fill")) " : "")
				.foregroundStyle(model.isDone ? .secondary : model.signColor)
			+ Text(model.todo.text)
				.foregroundStyle(model.isDone ? .secondary: .primary)
				.strikethrough(model.isDone)
		}
		.lineLimit(2)
	}

	@ViewBuilder
	func makeInfo() -> some View {
		if let title = model.listTitle, model.showList {
			Text(title)
				.foregroundStyle(model.isDone ? .tertiary : .secondary)
				.font(.body)
				.lineLimit(1)
		}
	}

	@ViewBuilder
	func makePrioritySign() -> some View {
		Image(systemName: "bolt.fill")
			.foregroundStyle(model.signColor)
	}
}

#Preview {
	DetailsTodoRow(todo: .init(.init(text: "New todo")), elements: [.listLabel])
		.frame(height: 100)
}
