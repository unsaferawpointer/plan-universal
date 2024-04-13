//
//  TodoDetailsView.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 06.04.2024.
//

import SwiftUI
import SwiftData

struct TodoDetailsView: View {

	@Environment(\.dismiss) var dismiss

	// MARK: - Data

	@Query private var lists: [ListItem]

	// MARK: - Local state

	@State var configuration: TodoConfiguration

	@FocusState var isFocused: Bool

	// MARK: - Action

	var confirm: (TodoConfiguration) -> Void

	var cancel: (() -> Void)?

	init(
		_ configuration: TodoConfiguration,
		confirm: @escaping (TodoConfiguration) -> Void,
		cancel: (() -> Void)? = nil
	) {
		self._configuration = State(initialValue: configuration)
		self.confirm = confirm
		self.cancel = cancel
	}

	var body: some View {
		NavigationStack {
			Form {
				TextField("New Todo", text: $configuration.text)
					.focused($isFocused)
					.submitLabel(.return)
				Picker("Status", selection: $configuration.status) {
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
				Picker("Priority", selection: $configuration.priority) {
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
				Picker("List", selection: $configuration.list) {
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
				ToolbarItem(placement: .cancellationAction) {
					Button("Cancel") {
						dismiss()
						cancel?()
					}
				}
				ToolbarItem(placement: .confirmationAction) {
					Button("Save", action: save)
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

	func save() {
		confirm(configuration)
		dismiss()
	}
}

#Preview {
	TodoDetailsView(.backlog, confirm: { _ in }, cancel: { })
}

