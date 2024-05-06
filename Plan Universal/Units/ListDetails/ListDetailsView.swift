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

	// MARK: - Data

	@State var model: ListDetailsModel

	// MARK: - Local state

	@FocusState private var isFocused: Bool

	// MARK: - Initialization

	init(_ action: Action<ListItem>) {
		self._model = State(initialValue: .init(action: action))
	}

	var body: some View {
		NavigationStack {
			Form {
				TextField("List Name", text: $model.configuration.title)
					.focused($isFocused)
				#if os(iOS)
				.tint(.accent)
				#endif
				Picker("Icon", selection: $model.configuration.icon) {
					ForEach(Icon.allCases, id: \.self) { icon in
						HStack {
							Image(systemName: icon.iconName)
							Text(icon.iconName)
						}
						.tag(icon)
					}
				}
				Toggle(isOn: $model.configuration.isFavorite, label: {
					Text("Is Favorite")
				})
			}
			.submitLabel(.done)
			.onSubmit {
				withAnimation {
					defer {
						dismiss()
					}
					model.save(in: modelContext)
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
						defer {
							dismiss()
						}
						withAnimation {
							model.save(in: modelContext)
						}
					}
					.disabled(!model.canSave)
				}
				if model.canDelete {
					ToolbarItem(placement: .destructiveAction) {
						Button(role: .destructive) {
							withAnimation {
								model.delete(in: modelContext)
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
	ListDetailsView(.new(.init()))
		.modelContainer(PreviewContainer.preview)
}
