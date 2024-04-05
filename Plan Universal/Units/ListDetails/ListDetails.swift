//
//  ListDetails.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 05.04.2024.
//

import SwiftUI

struct ListDetails: View {

	@Environment(\.dismiss) var dismiss

	// MARK: - Data

	@Bindable var list: ListItem

	@Environment(\.modelContext) private var modelContext

	init(list: ListItem?) {
		self.list = list ?? ListItem.random
	}

	var body: some View {
		#if os(macOS)
		VStack(alignment: .trailing) {
			makeForm()
			HStack(alignment: .firstTextBaseline) {
				Button(role: .cancel) {
					cancel()
				} label: {
					Text("Cancel")
				}
				Button("Save") {
					save()
				}
				.keyboardShortcut("\r", modifiers: /*@START_MENU_TOKEN@*/.command/*@END_MENU_TOKEN@*/)
			}
			.padding()
		}
		#else
		NavigationView {
			makeForm()
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
			}
		}
		#endif
	}

	@ViewBuilder
	func makeForm() -> some View {
		Form {
			TextField("List name", text: $list.title)
			Toggle(isOn: $list.isArchieved) {
				Text("Is Archived")
			}
			Toggle(isOn: $list.isFavorite) {
				Text("Is Favorite")
			}
		}
		.formStyle(.grouped)
	}
}

// MARK: - Helpers
private extension ListDetails {

	func save() {
		withAnimation {
			modelContext.insert(list)
			dismiss.callAsFunction()
		}
	}

	func cancel() {
		dismiss.callAsFunction()
	}
}

#Preview {
	ListDetails(list: .random)
		.frame(width: 240)
}

extension ListItem {

	static var random: ListItem {
		return .init(
			uuid: .init(),
			title: "New list",
			isArchieved: false,
			isFavorite: false,
			creationDate: .now,
			rawIcon: nil
		)
	}
}
