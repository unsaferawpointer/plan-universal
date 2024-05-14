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

	@State private var todoDetailsIsPresented: Bool = false

	// MARK: - Data

	@Query private var projects: [ProjectItem]

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
	}

	var body: some View {
		List(selection: $selection) {
			NavigationRow(
				title: Panel.inFocus.title,
				icon: "star.fill",
				sign: nil,
				filter: TodoFilter(base: .status(.inFocus), constainsText: nil)
			)
			.tag(Panel.inFocus)
			.listItemTint(.yellow)

			Section("Projects") {
				if projects.isEmpty {
					ContentUnavailableView("No Projects", systemImage: "doc.text")
				} else {
					ForEach(projects, id: \.self) { project in
						Label("\(project.name) \(project.order) ", systemImage: "doc.text")
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
							.tag(Panel.list(project))
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

	func delete(_ item: ProjectItem) {
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
