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
		VStack(alignment: .trailing) {
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

			HStack(alignment: .firstTextBaseline) {
				Button(role: .cancel) {
					dismiss()
				} label: {
					Text("Cancel")
				}
				Button("Save") {
					modelContext.insert(list)
					dismiss.callAsFunction()
				}
				.keyboardShortcut("\r", modifiers: /*@START_MENU_TOKEN@*/.command/*@END_MENU_TOKEN@*/)
			}
			.padding()
		}
		.frame(
			minWidth: 240,
			idealWidth: 280,
			maxWidth: 360,
			minHeight: 240,
			idealHeight: 240,
			maxHeight: 360,
			alignment: .center
		)
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
