//
//  SidebarView.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 05.04.2024.
//

import SwiftUI
import SwiftData

struct SidebarView: View {

	@Environment(\.modelContext) var modelContext

	#if os(iOS)
	private var isCompact: Bool {
		UIDevice.current.userInterfaceIdiom != .pad
	}
	#else
	private let isCompact = false
	#endif

	@Binding private var selection: Panel?

	// MARK: - Local state

	@State private var projectDetailIsPresented: Bool = false

	@State var editedProject: ProjectItem?

	@State var editedList: ListItem?

	@State private var todoDetailsIsPresented: Bool = false

	// MARK: - Data

	@Query private var projects: [ProjectItem]

	@Query private var lists: [ListItem]

	// MARK: - Utilities

	let requestManager = RequestManager()

	// MARK: - Initialization

	init(_ selection: Binding<Panel?>) {
		self._selection = selection
		self._projects = Query(
			filter: requestManager.projectPredicate().predicate,
			sort:
				[
					SortDescriptor(\ProjectItem.order, order: .forward),
				],
			animation: .default
		)

		let listsPredicate = #Predicate<ListItem> {
			$0.project == nil
		}

		self._lists = Query(
			filter: listsPredicate,
			sort: [SortDescriptor(\ListItem.order, order: .forward)],
			animation: .default
		)
	}

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

			Section("Projects") {
				if projects.isEmpty {
					ContentUnavailableView("No Projects", systemImage: "square.stack.3d.up")
				} else {
					ForEach(projects, id: \.self) { project in
						Label(project.name, systemImage: "square.stack.3d.up")
							.listItemTint(.primary)
							.contextMenu {
								Button("Edit project...") {
									self.editedProject = project
								}
								Divider()
								Button(role: .destructive) {
									withAnimation {
										delete(project)
									}
								} label: {
									Text("Delete")
								}
							}
							.tag(Panel.project(project))
					}
					.onMove { indices, newOffset in
						withAnimation {
							var sorted = projects
							sorted.move(fromOffsets: indices, toOffset: newOffset)
							try? modelContext.transaction {
								for (offset, model) in sorted.enumerated() {
									model.order = offset
								}
							}
						}
					}
				}
			}

			Section("Lists") {
				if lists.isEmpty {
					ContentUnavailableView("No Lists", systemImage: "doc.text")
				} else {
					ForEach(lists, id: \.self) { list in
						Label(list.title, systemImage: "doc.text")
							.listItemTint(.primary)
							.contextMenu {
								Button("Edit List...") {
									self.editedList = list
								}
								Divider()
								Button(role: .destructive) {
									withAnimation {
										delete(list)
									}
								} label: {
									Text("Delete")
								}
							}
							.tag(Panel.list(list))
					}
					.onMove { indices, newOffset in
						withAnimation {
							var sorted = lists
							sorted.move(fromOffsets: indices, toOffset: newOffset)
							try? modelContext.transaction {
								for (offset, model) in sorted.enumerated() {
									model.order = offset
								}
							}
						}
					}
				}
			}
		}
		.safeAreaInset(edge: .bottom) {
			HStack {
				Button {
					self.projectDetailIsPresented = true
				} label: {
					Label("New Project", systemImage: "plus")
				}
				.buttonStyle(.link)
				.padding()
				Spacer()
			}
		}
		.sheet(isPresented: $projectDetailIsPresented) {
			ProjectDetailView(.new(.init()))
		}
		.sheet(isPresented: $todoDetailsIsPresented) {
			TodoDetailsView(action: .new(.init()))
		}
		.sheet(item: $editedProject) { item in
			ProjectDetailView(.edit(item))
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

// MARK: - Helpers
private extension SidebarView {

	func delete<T: PersistentModel>(_ item: T) {
		modelContext.delete(item)
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
		.modelContainer(PreviewContainer.preview)
	}
}
