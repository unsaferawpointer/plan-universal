//
//  Sidebar+ProjectsSection.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 21.05.2024.
//

import SwiftUI
import SwiftData

extension Sidebar {

	struct ProjectsSection {

		@Environment(\.modelContext) var modelContext

		// MARK: - Data

		@Query private var projects: [ProjectItem]

		// MARK: - Local state

		@Binding var presentation: Presentation

		init(presentation: Binding<Presentation>) {
			self._presentation = presentation
			self._projects = Query(sort: \.order, animation: .default)
		}
	}
}

// MARK: - View
extension Sidebar.ProjectsSection: View {

	var body: some View {
		Section("Projects") {
			if projects.isEmpty {
				ContentUnavailableView("No Projects", systemImage: "square.stack.3d.up")
			} else {
				ForEach(projects, id: \.self) { project in
					Label(project.name, systemImage: "square.stack.3d.up")
						.listItemTint(.primary)
						.contextMenu {
							Button("Edit project...") {
								presentation.editedProject = project
							}
							Divider()
							Button(role: .destructive) {
								delete(project)
							} label: {
								Text("Delete")
							}
						}
						.tag(Panel.project(project))
				}
				.onMove { indices, offset in
					move(indices, offset: offset)
				}
				Button {
					presentation.projectDetailIs = true
				} label: {
					Label("New Project...", systemImage: "plus")
						.foregroundStyle(.primary)
				}
				.buttonStyle(.plain)
				.selectionDisabled()
			}
		}
	}
}

// MARK: - Helpers
private extension Sidebar.ProjectsSection {

	func delete(_ project: ProjectItem) {
		withAnimation {
			modelContext.delete(project)
		}
	}

	func move(_ indices: IndexSet, offset: Int) {
		withAnimation {
			var sorted = projects
			sorted.move(fromOffsets: indices, toOffset: offset)
			for (offset, model) in sorted.enumerated() {
				model.order = offset
			}
		}
	}
}
