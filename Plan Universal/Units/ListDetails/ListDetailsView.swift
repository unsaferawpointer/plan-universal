//
//  ListDetailsView.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 05.04.2024.
//

import SwiftUI

struct ListDetailsView: View {

	@Environment(\.dismiss) var dismiss

	@Environment(\.modelContext) var modelContext

	// MARK: - Local state

	@FocusState private var isFocused: Bool

	@State private var configuration: ListConfiguration

	private var action: Action<ListItem>

	let items = Icon.allCases

	let config = [
		GridItem(.adaptive(minimum: 40))
	]

	// MARK: - Initialization

	init(_ action: Action<ListItem>) {
		self.action = action
		self._configuration = State(initialValue:  action.configuration)
	}

	var body: some View {
		NavigationStack {
			Form {
				TextField("List Name", text: $configuration.title)
					.focused($isFocused)
				Picker("Icon", selection: $configuration.icon) {
					ForEach(items, id: \.self) { icon in
						Label(icon.iconName, systemImage: icon.iconName)
							.tag(icon)
					}
				}
			}
			.submitLabel(.done)
			.onSubmit {
				withAnimation {
					defer {
						dismiss()
					}
					save()
				}
			}
			.onAppear {
				self.isFocused = true
			}
			.toolbar {
				ToolbarItem(placement: .cancellationAction) {
					Button(role: .cancel) {
						dismiss()
					} label: {
						Text("Cancel")
					}
				}
				ToolbarItem(placement: .confirmationAction) {
					Button("Save") {
						withAnimation {
							defer {
								dismiss()
							}
							save()
						}
					}
					.disabled(!canSave)
				}
				if canDelete {
					ToolbarItem(placement: .destructiveAction) {
						Button(role: .destructive) {
							withAnimation {
								delete()
								dismiss()
							}
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

// MARK: - Public interface
extension ListDetailsView {

	func delete() {
		switch action {
		case .new:
			fatalError()
		case .edit(let list):
			list.title = configuration.title
		}
	}

	func save() {

		let trimmed = configuration.title.trimmingCharacters(in: .whitespaces)
		let title = trimmed.isEmpty ? String(localized: "New List") : trimmed

		switch action {
		case .new:
			let new = ListItem(configuration)
			modelContext.insert(new)
		case .edit(let list):
			try? modelContext.transaction {
				list.configuration = configuration
				list.title = title
			}
		}
	}

	var canDelete: Bool {
		guard case .edit = action else {
			return false
		}
		return true
	}

	var canSave: Bool {
		let trimmed = configuration.title.trimmingCharacters(in: .whitespaces)
		return !trimmed.isEmpty
	}
}

#Preview {
	ListDetailsView(.new(.init()))
		.modelContainer(previewContainer)
}
