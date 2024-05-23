//
//  Sidebar+UnitView.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 05.04.2024.
//

import SwiftUI
import SwiftData

extension Sidebar {

	struct UnitView {

		// MARK: - Local state

		@Binding private var selection: Panel?

		@State var presentation: Presentation = .init()

		// MARK: - Initialization

		init(_ selection: Binding<Panel?>) {
			self._selection = selection
		}
	}
}

// MARK: - View
extension Sidebar.UnitView: View {

	var body: some View {
		List(selection: $selection) {
			NavigationRow(
				title: Panel.inFocus.title,
				icon: "star.fill",
				sign: nil,
				filter: TodoFilter(base: .status(true), constainsText: nil)
			)
			.tag(Panel.inFocus)
			.listItemTint(.yellow)

			Sidebar.ProjectsSection(presentation: $presentation)
			Sidebar.ListsSection(presentation: $presentation)
		}
		.sheet(isPresented: $presentation.projectDetailIs) {
			ProjectDetailView(.new(.init()))
		}
		.sheet(isPresented: $presentation.listDetailIs) {
			ListDetailsView(.new(.default), project: nil)
		}
		.sheet(item: $presentation.editedProject) { item in
			ProjectDetailView(.edit(item))
		}
		.sheet(item: $presentation.editedList) { item in
			ListDetailsView(.edit(item), project: item.project!)
		}
		.navigationTitle("Plan")
		#if os(iOS)
		.toolbar {
			if isCompact {
				ToolbarItem(placement: .bottomBar) {
					Spacer()
				}
				ToolbarItem(placement: .primaryAction) {
					Menu("Add", systemImage: "plus") {
						Button {
							self.listDetailsIsPresented = true
						} label: {
							Text("New List")
						}
					} primaryAction: {
						self.todoDetailsIsPresented = true
					}
				}
			}
		}
		#endif
	}
}

struct Sidebar_Previews: PreviewProvider {

	struct Preview: View {
		@State private var selection: Panel? = Panel.inFocus
		var body: some View {
			Sidebar.UnitView($selection)
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
