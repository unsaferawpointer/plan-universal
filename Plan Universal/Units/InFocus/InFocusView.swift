//
//  InFocusView.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 16.05.2024.
//

import SwiftUI

struct InFocusView: View {

	@State var completed: [Item] =
	[
		.init(text: "ARC"),
		.init(text: "Generic"),
		.init(text: "Reference type VS Value type")
	]

	@State var todos: [Item] = 
	[
		.init(text: "UIResponder"),
		.init(text: "UIView"),
		.init(text: "UIViewController", isUrgent: true)
	]

	@State private var selection: Set<UUID> = .init()

	var body: some View {
		List(selection: $selection) {
			BannerView(
				systemIcon: "star.fill",
				message: "Проект макроса для генерации моков",
				color: .yellow
			)
			.listRowSeparator(.hidden)
			Spacer()
			ForEach(todos) { todo in
				HStack {
					RoundedRectangle(
						cornerSize: CGSize(width: 4, height: 4),
						style: .continuous
					)
					.fill(Color(.secondarySystemFill))
					.frame(width: 13, height: 13)
					HStack(spacing: 4) {
						if todo.isUrgent {
							Image(systemName: "bolt.fill")
								.foregroundStyle(.yellow)
						}
						Text(todo.text)
					}
				}
			}
			.listRowSeparator(.hidden)
			Section {
				ForEach(completed) { item in
					HStack {
						Checkmark(isDone: .constant(true))
							.frame(width: 13, height: 13)

						HStack(spacing: 4) {
							if item.isDone {
								Image(systemName: "bolt.fill")
									.foregroundStyle(.yellow)
							}
							Text(item.text)
								.strikethrough()
								.foregroundStyle(.secondary)
						}
					}
				}
				.listRowSeparator(.hidden)
			} header: {
				HStack {
					Text("Completed")
						.font(.headline)
					Spacer()
				}
			}
		}
		.navigationTitle("In Focus")
		.navigationSubtitle("10 Items")
		.toolbar {
			ToolbarItem(placement: .primaryAction) {
				Button("Archieve", systemImage: "archivebox") {

				}
			}
		}
	}
}

extension InFocusView {

	struct Header: Identifiable {
		var id: UUID
		var title: String

		var items: [Item]

		init(id: UUID = UUID(), title: String, items: [Item] = []) {
			self.id = id
			self.title = title
			self.items = items
		}
	}

	struct Item: Identifiable {
		var id: UUID
		var text: String
		var isDone: Bool
		var isUrgent: Bool = false

		init(id: UUID = UUID(), text: String, isDone: Bool = false, isUrgent: Bool = false) {
			self.id = id
			self.text = text
			self.isDone = isDone
			self.isUrgent = isUrgent
		}
	}
}

#Preview {
	InFocusView()
}
