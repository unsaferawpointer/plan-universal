//
//  ListDetailsView.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 05.04.2024.
//

import SwiftUI

struct ListDetailsView: View {

	@Environment(\.dismiss) var dismiss

	// MARK: - Data

	var list: ListItem?

	@Environment(\.modelContext) private var modelContext

	// MARK: - Local state

	@State var title: String

	init(list: ListItem?) {
		self.list = list
		self._title = State(initialValue: list?.title ?? "New list")
	}

	var body: some View {
		NavigationStack {
			Form {
				TextField("List name", text: $title)
			}
			.toolbar {
				ToolbarItem(placement: .cancellationAction) {
					Button(role: .cancel) {
						cancel()
					} label: {
						Text("Cancel")
					}
				}
				ToolbarItem(placement: .confirmationAction) {
					Button("Save") {
						save()
					}
				}
				if let list {
					ToolbarItem(placement: .destructiveAction) {
						Button(role: .destructive) {
							delete()
						} label: {
							Label("Delete", systemImage: "trash")
						}

					}
				}
			}
		}
		#if os(macOS)
		.padding(10)
		.frame(minWidth: 320)
		#endif
	}

}

// MARK: - Helpers
private extension ListDetailsView {

	func save() {
		withAnimation {
			defer {
				dismiss()
			}
			guard let list else {
				let new: ListItem = .new
				new.title = title

				modelContext.insert(new)
				return
			}
			list.title = title
		}
	}

	func cancel() {
		dismiss()
	}

	func delete() {
		withAnimation {
			guard let list else {
				return
			}
			modelContext.delete(list)
			dismiss()
		}
	}
}

#Preview {
	ListDetailsView(list: .new)
		.frame(width: 240)
}
