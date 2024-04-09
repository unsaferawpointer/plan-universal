//
//  SidebarView.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 05.04.2024.
//

import SwiftUI
import SwiftData

struct SidebarView: View {

	/// The person's selection in the sidebar
	@Binding var selection: Panel?

	// MARK: - Local state

	@State var isPresented: Bool = false

	@State var edited: ListItem?

	// MARK: - Data

	@Environment(\.modelContext) private var modelContext

	@Query(sort: \ListItem.creationDate, order: .forward, animation: .default) private var lists: [ListItem]

	var body: some View {
		List(selection: $selection) {
			NavigationLink(value: Panel.inFocus) {
				Label("In Focus", systemImage: "sparkles")
			}
			.listItemTint(.yellow)

			NavigationLink(value: Panel.backlog) {
				Label("Backlog", systemImage: "square.3.layers.3d")
			}

			NavigationLink(value: Panel.archieve) {
				Label("Archieve", systemImage: "shippingbox")
			}

			Section("Lists") {
				if lists.isEmpty {
					ContentUnavailableView.init(label: {
						Label("No Lists", systemImage: "doc.text")
					}, description: {
						Text("New lists you create will appear here.")
							.lineLimit(2)
					}, actions: {
						Button(action: {
							self.isPresented = true
						}) {
							Text("New List")
						}
						.buttonStyle(.bordered)
					})
				} else {
					ForEach(lists) { list in
						NavigationLink(value: Panel.list(list)) {
							Label(list.title, systemImage: "doc.text")
						}
						.contextMenu {
							Button("Edit...") {
								self.edited = list
							}
							Divider()
							Button("Delete") {
								modelContext.delete(list)
							}
						}
					}
				}
			}
		}
		.sheet(isPresented: $isPresented) {
			ListDetailsView(list: nil)
		}
		.sheet(item: $edited) { item in
			ListDetailsView(list: item)
		}
		.navigationTitle("Plan")
		#if os(iOS)
		.toolbar {
			ToolbarItem(placement: .bottomBar) {
				Spacer()
			}
			ToolbarItem(placement: .bottomBar) {
				Button {
					self.isPresented = true
				} label: {
					Image(systemName: "doc.badge.plus")
				}
			}
		}
		#else
		.toolbar {
			ToolbarItem {
				Spacer()
			}
			ToolbarItem(placement: .primaryAction) {
				Button {
					self.isPresented = true
				} label: {
					Image(systemName: "doc.badge.plus")
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
			SidebarView(selection: $selection)
		}
	}

	static var previews: some View {
		NavigationSplitView {
			Preview()
		} detail: {
			Text("Details")
		}
	}
}
