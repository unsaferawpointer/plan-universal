//
//  ProjectTodosView.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 16.05.2024.
//

import SwiftUI
import SwiftData

struct ProjectTodosView: View {

	@Environment(\.modelContext) var modelContext

	// MARK: - Data

	var project: ProjectItem

	@Query(animation: .default) private var lists: [ListItem]

	// MARK: - Locale state

	@State private var selection: Set<UUID> = .init()

	var body: some View {
		List(selection: $selection) {
			BannerView(
				systemIcon: "doc.text",
				message: project.name,
				color: .secondary
			)
			ForEach(lists) { list in
				ListSectionView(list: list)
			}
		}
		.scrollIndicators(.never)
		.navigationTitle(project.name)
		.toolbar {
			ToolbarItem(placement: .primaryAction) {
				Button("Add", systemImage: "plus") {
					let configuration = ListConfiguration()
					DataManager().insert(configuration, toProject: project, in: modelContext)
				}
			}
		}
	}


}

extension ProjectTodosView {

	struct Header: Identifiable {
		var id: UUID
		var title: String

		var items: [Item]

		init(id: UUID = UUID(), title: String, items: [Item] = []) {
			self.id = id
			self.title = title
			self.items = items
		}
	}

	struct Item: Identifiable {
		var id: UUID
		var text: String
		var isDone: Bool

		init(id: UUID = UUID(), text: String, isDone: Bool = false) {
			self.id = id
			self.text = text
			self.isDone = isDone
		}
	}
}

//#Preview {
//	ProjectTodosView()
//}
