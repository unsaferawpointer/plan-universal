//
//  DetailsView.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 05.04.2024.
//

import SwiftUI

struct DetailsView: View {

	var body: some View {
		List {
			ForEach(0..<12) { item in
				NavigationLink(value: item) {
					Text("Todo \(item)")
				}
				.listItemTint(.secondary)
			}
			.listRowSeparator(.hidden)
		}
	}
}

#Preview {
	DetailsView()
}
