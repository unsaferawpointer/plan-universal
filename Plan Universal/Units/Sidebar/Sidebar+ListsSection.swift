//
//  Sidebar+ListsSection.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 21.05.2024.
//

import SwiftUI
import SwiftData

extension Sidebar {

	struct ListsSection {

		@Environment(\.modelContext) var modelContext

		// MARK: - Data

		@Query private var lists: [ListItem]

		// MARK: - Local state

		@Binding var presentation: Presentation

		// MARK: - Initialization

		init(presentation: Binding<Presentation>) {
			self._presentation = presentation
			let listsPredicate = #Predicate<ListItem> {
				$0.project == nil
			}

			self._lists = Query(
				filter: listsPredicate,
				sort: [SortDescriptor(\ListItem.order, order: .forward)],
				animation: .default
			)
		}
	}
}

// MARK: - View
extension Sidebar.ListsSection: View {

	var body: some View {
		Section("Lists") {
			ForEach(lists, id: \.self) { list in
				Label(list.title, systemImage: "doc.text")
					.listItemTint(.primary)
					.contextMenu {
						Button("Edit List...") {
							presentation.editedList = list
						}
						Divider()
						Button(role: .destructive) {
							delete(list)
						} label: {
							Text("Delete")
						}
					}
					.tag(Panel.list(list))
			}
			.onMove { indices, newOffset in
				move(indices, offset: newOffset)
			}
			Button {
				presentation.listDetailIs = true
			} label: {
				Label("New List...", systemImage: "plus")
					.foregroundStyle(.primary)
			}
			.buttonStyle(.plain)
			.selectionDisabled()
		}
	}
}

// MARK: - Helpers
private extension Sidebar.ListsSection {

	func delete(_ list: ListItem) {
		withAnimation {
			modelContext.delete(list)
		}
	}

	func move(_ indices: IndexSet, offset: Int) {
		withAnimation {
			var sorted = lists
			sorted.move(fromOffsets: indices, toOffset: offset)
			for (offset, model) in sorted.enumerated() {
				model.order = offset
			}
		}
	}
}
