//
//  TodoDetailsView.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 06.04.2024.
//

import SwiftUI
import SwiftData

struct TodoDetailsView: View {

	@Environment(\.modelContext) var modelContext

	@Environment(\.dismiss) var dismiss

	// MARK: - Data

	@Query private var lists: [ListItem]

	@State var model: TodoDetailsModel

	// MARK: - Local state

	@FocusState var isFocused: Bool

	// MARK: - Initialization

	init(action: Action<TodoItem>) {
		self._model = State(initialValue: TodoDetailsModel(action: action))
	}

	var body: some View {
		NavigationStack {
			Form {
				TextField("New Todo", text: $model.configuration.text)
					.focused($isFocused)
					.submitLabel(.return)
				Picker("Status", selection: $model.configuration.status) {
					ForEach(TodoStatus.allCases) { status in
						Text(status.title)
							.tag(status)
					}
				}
				#if os(iOS)
				.pickerStyle(.inline)
				#else
				.pickerStyle(.menu)
				#endif
				Picker("Priority", selection: $model.configuration.priority) {
					ForEach(TodoPriority.allCases) { priority in
						Text(priority.title)
							.tag(priority)
					}
				}
				#if os(iOS)
				.pickerStyle(.inline)
				#else
				.pickerStyle(.menu)
				#endif
				Picker("List", selection: $model.configuration.list) {
					Text("None")
						.tag(Optional<ListItem>(nil))
					Divider()
					ForEach(lists) { list in
						Text(list.title)
							.tag(Optional<ListItem>(list))
					}
				}
			}
			.onAppear {
				self.isFocused = true
			}
			.toolbar {
				if model.canDelete {
					ToolbarItem(placement: .destructiveAction) {
						Button(role: .destructive) {
							delete()
						} label: {
							Label("Delete", systemImage: "trash")
						}

					}
				}
				ToolbarItem(placement: .cancellationAction) {
					Button("Cancel") {
						dismiss()
					}
				}
				ToolbarItem(placement: .confirmationAction) {
					Button("Save") {
						save()
					}
					.disabled(!model.canSave)
				}
			}
		}
		#if os(macOS)
		.padding(/*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
		.frame(minWidth: 320)
		#endif
	}
}

// MARK: - Helpers
private extension TodoDetailsView {

	func delete() {
		defer {
			dismiss()
		}
		withAnimation {
			model.delete(in: modelContext)
		}
	}

	func save() {
		defer {
			dismiss()
		}
		withAnimation {
			model.save(in: modelContext)
		}
	}
}

//#Preview {
//	TodoDetailsView(action: .new, with: .inFocus)
//}
