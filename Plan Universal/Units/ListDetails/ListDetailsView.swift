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

	@StateObject private var model: ListDetailsModel

	// MARK: - Local state

	@FocusState private var isFocused: Bool

	// MARK: - Initialization

	init(_ action: DetailsAction<ListEntity>) {
		self._model = StateObject(wrappedValue:  ListDetailsModel(action))
	}

	var body: some View {
		NavigationStack {
			Form {
				TextField("List Name", text: $model.configuration.title)
					.focused($isFocused)
			}
			.submitLabel(.done)
			.onSubmit {
				withAnimation {
					defer {
						dismiss()
					}
					model.save()
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
							model.save()
						}
					}
					.disabled(!model.buttonToSaveIsEnabled)
				}
				if model.buttonToDeleteIsEnabled {
					ToolbarItem(placement: .destructiveAction) {
						Button(role: .destructive) {
							withAnimation {
								model.delete()
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

#Preview {
	ListDetailsView(.new)
		.frame(width: 240)
}
