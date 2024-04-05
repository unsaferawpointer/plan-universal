//
//  SidebarView.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 05.04.2024.
//

import SwiftUI

struct SidebarView: View {

	/// The person's selection in the sidebar
	@Binding var selection: Panel?

	var body: some View {
		List(selection: $selection) {
			NavigationLink(value: Panel.inFocus) {
				Label("In Focus", systemImage: "sparkles")
			}
			.listItemTint(.yellow)

			NavigationLink(value: Panel.backlog) {
				Label("Backlog", systemImage: "square.3.layers.3d")
			}
			.listItemTint(.monochrome)

			NavigationLink(value: Panel.archieve) {
				Label("Archieve", systemImage: "shippingbox")
			}
			.listItemTint(.monochrome)

			Section("Lists") {
				ForEach(0..<12) { list in
					NavigationLink(value: list) {
						Label("List \(list)", systemImage: "doc.text")
					}
					.listItemTint(.secondary)
				}
			}
		}
	}
}

struct Sidebar_Previews: PreviewProvider {

	struct Preview: View {
		@State private var selection: Panel? = Panel.inFocus
		var body: some View {
			SidebarView(selection: $selection)
		}
	}

	static var previews: some View {
		NavigationSplitView {
			Preview()
		} detail: {
			Text("Detail!")
		}
	}
}
