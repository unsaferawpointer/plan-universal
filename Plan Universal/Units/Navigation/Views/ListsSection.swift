//
//  ListsSection.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 28.04.2024.
//

import SwiftUI

struct ListsSection: View {

	@Environment(\.modelContext) var modelContext

	var title: String

	@Binding var editedList: ListItem?

	@Binding var listDetailsIsPresented: Bool

	var lists: [ListItem]

	var body: some View {
		Section(title) {
			if lists.isEmpty {
				ContentUnavailableView.init(label: {
					Label("No Lists", systemImage: "doc.text")
				}, description: {
					Text("New lists you create will appear here.")
						.lineLimit(2)
				}, actions: {
					Button(action: {
						self.listDetailsIsPresented = true
					}) {
						Text("New List")
					}
					.buttonStyle(.bordered)
				})
			} else {
				ForEach(lists) { list in
					Label(list.title, systemImage: list.icon.iconName)
						.contextMenu {
							Button("Edit List...") {
								self.editedList = list
							}
							Divider()
							Button(list.isFavorite ? "Delete from Favorites" : "Move to Favorites") {
								withAnimation {
									list.isFavorite.toggle()
								}
							}
							Divider()
							Button(role: .destructive) {
								withAnimation {
									delete(list)
								}
							} label: {
								Text("Delete")
							}
						}
						.tag(Panel.list(list))
				}
			}
		}
	}
}

// MARK: - Helpers
private extension ListsSection {

	func delete(_ list: ListItem) {
		withAnimation {
			modelContext.delete(list)
		}
	}
}

#Preview {
	ListsSection(
		title: "Lists",
		editedList: .constant(nil),
		listDetailsIsPresented: .constant(false),
		lists: []
	)
		.modelContainer(previewContainer)
}
