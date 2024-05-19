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
			if let selection, selection == .inFocus {
				NavigationStack {
					InFocusView()
				}
			} else if case let .project(value) = selection {
				NavigationStack {
					ProjectTodosView(value)
				}
			} else if case let .list(value) = selection {
				NavigationStack {
					ListTodosView(value)
				}
			} else {
				Text("Select sidebar item")
			}
		}
	}
}

#Preview {
	RootView()
		.modelContainer(PreviewContainer.preview)
}
