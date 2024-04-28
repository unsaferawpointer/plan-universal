//
//  ListsSection.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 28.04.2024.
//

import SwiftUI

struct ListsSection: View {

	@Environment(\.modelContext) var modelContext

	@Binding var editedList: ListItem?

	@Binding var listDetailsIsPresented: Bool

	var lists: [ListItem]

	var body: some View {
		Section("Lists") {
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
					NavigationLink(value: Panel.list(list)) {
						Label(list.title, systemImage: "doc.text")
					}
					.contextMenu {
						Button("Edit List...") {
							self.editedList = list
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
	ListsSection(editedList: .constant(nil), listDetailsIsPresented: .constant(false), lists: [])
		.modelContainer(previewContainer)
}
