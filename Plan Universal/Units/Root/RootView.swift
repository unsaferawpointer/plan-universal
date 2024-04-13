//
//  RootView.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 05.04.2024.
//

import SwiftUI

struct RootView: View {

	@State private var selection: Panel? = Panel.inFocus

	var body: some View {
		NavigationSplitView {
			SidebarView($selection)
		} detail: {
			if let selection {
				NavigationStack {
					DetailsView(behaviour: behaviour(for: selection), panel: $selection)
				}
			} else {
				Text("Select sidebar item")
			}
		}
	}
}

extension RootView {

	func behaviour(for panel: Panel) -> Behaviour {
		switch panel {
		case .inFocus:
			.status(.inFocus)
		case .backlog:
			.status(.backlog)
		case .archieve:
			.status(.done)
		case .list(let id):
			.list(id)
		}
	}
}

#Preview {
	RootView()
		.modelContainer(for: ListItem.self, inMemory: true)
		.modelContainer(for: TodoItem.self, inMemory: true)
}
