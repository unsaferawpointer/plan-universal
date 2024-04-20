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
	@Binding private var selection: Panel?

	// MARK: - Local state

	@State private var listDetailsIsPresented: Bool = false

	@State private var editedList: ListEntity?

	// MARK: - Data

	@StateObject var model: NavigationModel = .init()

	// MARK: - Initialization

	init(_ selection: Binding<Panel?>) {
		self._selection = selection
	}

	var body: some View {
		List(selection: $selection) {
			NavigationLink(value: Panel.inFocus) {
				NavigationRow(title: "In Focus", icon: "sparkles", sign: nil, filter: TodoFilter.status(.inFocus))
			}
			.listItemTint(.yellow)

			NavigationLink(value: Panel.backlog) {
				NavigationRow(
					title: "Backlog",
					icon: "square.3.layers.3d", 
					sign: "bolt.fill",
					filter: CompoundFilter<TodoFilter>(filters: [.status(.backlog), .highPriority])
				)
			}

			NavigationLink(value: Panel.archieve) {
				Label("Archieve", systemImage: "shippingbox")
			}

			Section("Lists") {
				if model.lists.isEmpty {
					makeContentUnavailableView()
				} else {
					makeSection($model.lists)
				}
			}
		}
		.sheet(isPresented: $listDetailsIsPresented) {
			ListDetailsView(.new)
		}
		.sheet(item: $editedList) { item in
			ListDetailsView(.edit(item))
		}
		.navigationTitle("Plan")
		#if os(iOS)
		.toolbar {
			ToolbarItem(placement: .bottomBar) {
				Spacer()
			}
			ToolbarItem(placement: .bottomBar) {
				Button {
					self.listDetailsIsPresented = true
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
					self.listDetailsIsPresented = true
				} label: {
					Image(systemName: "doc.badge.plus")
				}
			}
		}
		#endif
	}
}

// MARK: - Helpers
private extension SidebarView {

	@ViewBuilder
	func makeContentUnavailableView() -> some View {
		ContentUnavailableView.init(label: {
			Label("No Lists", systemImage: "doc.text")
		}, description: {
			Text("New lists you create will appear here.")
				.lineLimit(2)
		}, actions: {
			Button(action: {
				self.listDetailsIsPresented = true
			}) {
				Text("New List")
			}
			.buttonStyle(.bordered)
		})
	}

	@ViewBuilder
	func makeSection(_ lists: Binding<[ListEntity]>) -> some View {
		ForEach(lists) { list in
			NavigationLink(value: Panel.list(list.wrappedValue)) {
				Label(list.wrappedValue.title, systemImage: "doc.text")
			}
			.contextMenu {
				Button("Edit List...") {
					self.editedList = list.wrappedValue
				}
				Divider()
				Button(role: .destructive) {
					withAnimation {
						model.deleteList(list.wrappedValue)
					}
				} label: {
					Text("Delete")
				}
			}
		}
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
	}
}
