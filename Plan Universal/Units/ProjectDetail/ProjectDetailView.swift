//
//  ProjectDetailView.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 15.05.2024.
//

import SwiftUI

struct ProjectDetailView: View {

	@Environment(\.dismiss) var dismiss

	@Environment(\.modelContext) var modelContext

	// MARK: - Data

	@State var model: ProjectDetailsModel

	// MARK: - Local state

	@FocusState private var isFocused: Bool

	// MARK: - Initialization

	init(_ action: Action<ProjectItem>) {
		self._model = State(initialValue: .init(action: action))
	}

	var body: some View {
		NavigationStack {
			Form {
				TextField("Name", text: $model.configuration.name)
					.focused($isFocused)
					#if os(iOS)
					.tint(.accent)
					#endif
				TextField("Description", text: $model.configuration.details, axis: .vertical)
					.lineLimit(2, reservesSpace: true)
				Toggle(isOn: $model.configuration.isArchieved, label: {
					Text("Is Archieved")
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
	ProjectDetailView(.new(.default))
}
