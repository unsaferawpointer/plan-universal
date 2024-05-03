//
//  SidebarView.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 05.04.2024.
//

import SwiftUI
import SwiftData

struct SidebarView: View {

	#if os(iOS)
	private var isCompact: Bool {
		UIDevice.current.userInterfaceIdiom != .pad
	}
	#else
	private let isCompact = false
	#endif

	@Binding private var selection: Panel?

	// MARK: - Local state

	@State private var listDetailsIsPresented: Bool = false

	@State var editedList: ListItem?

	@State private var todoDetailsIsPresented: Bool = false

	// MARK: - Data

	@Query private var lists: [ListItem]

	@Query private var favorites: [ListItem]

	// MARK: - Utilities

	let requestManager = RequestManager()

	// MARK: - Initialization

	init(_ selection: Binding<Panel?>) {
		self._selection = selection
		self._lists = Query(
			filter: requestManager.listPredicate(isFavorite: false).predicate,
			sort: [],
			animation: .default
		)
		self._favorites = Query(
			filter: requestManager.listPredicate(isFavorite: true).predicate,
			sort: [],
			animation: .default
		)
	}

	var body: some View {
		List(selection: $selection) {
			NavigationRow(
				title: Panel.inFocus.title,
				icon: "sparkles",
				sign: nil,
				filter: TodoFilter(base: .status(.inFocus), constainsText: nil)
			)
			.tag(Panel.inFocus)
			.listItemTint(.yellow)

			Label(Panel.backlog.title, systemImage: "square.3.layers.3d")
				.tag(Panel.backlog)

			Label(Panel.completed.title, systemImage: "shippingbox")
				.tag(Panel.completed)

			ListsSection(
				title: "Favorites",
				editedList: $editedList,
				listDetailsIsPresented: $listDetailsIsPresented,
				lists: favorites
			)

			ListsSection(
				title: "Lists",
				editedList: $editedList,
				listDetailsIsPresented: $listDetailsIsPresented,
				lists: lists
			)
		}
		.sheet(isPresented: $listDetailsIsPresented) {
			ListDetailsView(.new(.init()))
		}
		.sheet(isPresented: $todoDetailsIsPresented) {
			TodoDetailsView(action: .new(.init()))
		}
		.sheet(item: $editedList) { item in
			ListDetailsView(.edit(item))
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
			SidebarView($selection)
		}
	}

	static var previews: some View {
		NavigationSplitView {
			Preview()
		} detail: {
			Text("Details")
		}
		.modelContainer(previewContainer)
	}
}
