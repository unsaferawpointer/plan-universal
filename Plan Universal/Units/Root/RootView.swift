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
					DetailsView(panel: selection)
				}
			} else {
				Text("Select sidebar item")
			}
		}
	}
}

#Preview {
	RootView()
}
