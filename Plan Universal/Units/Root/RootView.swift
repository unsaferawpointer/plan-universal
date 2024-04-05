//
//  RootView.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 05.04.2024.
//

import SwiftUI

struct RootView: View {

	var body: some View {
		NavigationSplitView {
			SidebarView()
		} detail: {
			DetailsView()
		}
	}
}

#Preview {
	RootView()
		.modelContainer(for: Item.self, inMemory: true)
}
