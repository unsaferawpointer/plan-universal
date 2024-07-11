//
//  SidebarUnitView.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 05.04.2024.
//

import SwiftUI
import SwiftData

struct SidebarUnitView {

	// MARK: - Data

	@Query private var lists: [ListItem]

	// MARK: - Local state

	@Environment(\.modelContext) var modelContext

	@Binding private var selection: Panel?

	@State var presentation: SidebarPresentation = .init()

	// MARK: - Initialization

	init(_ selection: Binding<Panel?>) {
		self._selection = selection
		self._lists = Query(
			filter: nil,
			sort: [SortDescriptor(\ListItem.order, order: .forward)],
			animation: .default
		)
	}
}

// MARK: - View
extension SidebarUnitView: View {

	var body: some View {
		List(selection: $selection) {
			NavigationRow(
				title: Panel.inFocus.title,
				icon: "square.stack.3d.up.fill",
				sign: nil,
				filter: TodoFilter(base: .inFocus(true), constainsText: nil)
			)
			.tag(Panel.inFocus)
			.listItemTint(.accentColor)

			Section("Lists") {
				ForEach(lists, id: \.self) { list in
					Label(list.title, systemImage: "doc.text")
						.listItemTint(.primary)
						.contextMenu {
							Button("Edit List...") {
								presentation.editedList = list
							}
							Divider()
							Button(role: .destructive) {
								delete(list)
							} label: {
								Text("Delete")
							}
						}
						.tag(Panel.list(list))
				}
				.onMove { indices, newOffset in
					move(indices, offset: newOffset)
				}
				Button {
					presentation.listDetailIs = true
				} label: {
					Label("New List...", systemImage: "plus")
						.foregroundStyle(.primary)
				}
				.buttonStyle(.plain)
				.selectionDisabled()
			}
		}
		.sheet(isPresented: $presentation.listDetailIs) {
			ListDetails.UnitView(.new(.default))
		}
		.sheet(item: $presentation.editedList) { item in
			ListDetails.UnitView(.edit(item))
		}
		.navigationTitle("Plan")
	}
}

// MARK: - Helpers
private extension SidebarUnitView {

	func delete(_ list: ListItem) {
		withAnimation {
			modelContext.delete(list)
		}
	}

	func move(_ indices: IndexSet, offset: Int) {
		withAnimation {
			var sorted = lists
			sorted.move(fromOffsets: indices, toOffset: offset)
			for (offset, model) in sorted.enumerated() {
				model.order = offset
			}
		}
	}
}

struct Sidebar_Previews: PreviewProvider {

	struct Preview: View {
		@State private var selection: Panel? = Panel.inFocus
		var body: some View {
			SidebarUnitView($selection)
		}
	}

	static var previews: some View {
		NavigationSplitView {
			Preview()
		} detail: {
			Text("Details")
		}
		.modelContainer(PreviewContainer.preview)
	}
}
