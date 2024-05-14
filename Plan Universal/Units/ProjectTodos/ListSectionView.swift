//
//  ListSectionView.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 19.05.2024.
//

import SwiftUI
import SwiftData

struct ListSectionView: View {

	@Environment(\.modelContext) var modelContext

	// MARK: - Data

	@State var list: ListItem

	@Query var todos: [TodoItem]

	// MARK: - Initialization

	init(list: ListItem) {
		self.list = list

		let uuid = list.uuid
		let predicate = #Predicate<TodoItem> {
			$0.list?.uuid == uuid
		}

		self._todos = Query(filter: predicate, sort: \.order, animation: .default)
	}

	var body: some View {
		Section {
			if !todos.isEmpty {
				ForEach(todos) { todo in
					TodoView(todo: todo)
				}
				.listRowSeparator(.hidden)
			} else {
				BannerView(systemIcon: "magnifyingglass", message: "No todos", color: .secondary)
					.selectionDisabled()
			}
		} header: {
			HStack {
				TextField("Type here...", text: $list.title)
//				Text(list.title)
					.font(.headline)
					.textFieldStyle(.plain)
				Spacer()
				Menu {
					Button("Add Todo") {
						withAnimation {
							let configuration = TodoConfiguration(
								text: "New Todo",
								status: .backlog,
								priority: .low,
								list: list
							)
							DataManager().insert(configuration, toList: list, in: modelContext)
						}
					}
					Divider()
					Button("Delete") {
						withAnimation {
							modelContext.delete(list)
						}
					}
				} label: {
					Image(systemName: "ellipsis")
				}
				.menuIndicator(.hidden)
				.menuStyle(BorderlessButtonMenuStyle())
				.fixedSize()
			}
			.listRowSeparator(.hidden)
		}
	}
}

// MARK: - Helpers
private extension ListSectionView {

	@ViewBuilder
	func makeMenu() -> some View {

	}
}

//#Preview {
//	ListSectionView()
//}
