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

	@FocusState var isFocused: Bool

	init(list: ListItem?) {
		self.list = list
		self._title = State(initialValue: list?.title ?? "")
	}

	var body: some View {
		NavigationStack {
			Form {
				TextField("List name", text: $title)
					.focused($isFocused)
			}
			.submitLabel(.done)
			.onSubmit {
				save()
			}
			.onAppear {
				self.isFocused = true
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
							delete(list)
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

				let trimmed = title.trimmingCharacters(in: .whitespaces)
				new.title = trimmed.isEmpty ? String(localized: "New List") : trimmed

				modelContext.insert(new)
				return
			}
			list.title = title
		}
	}

	func cancel() {
		dismiss()
	}

	func delete(_ list: ListItem) {
		withAnimation {
			modelContext.delete(list)
			dismiss()
		}
	}
}

#Preview {
	ListDetailsView(list: .new)
		.frame(width: 240)
}
