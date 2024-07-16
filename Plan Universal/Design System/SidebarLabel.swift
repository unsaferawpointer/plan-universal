//
//  SidebarLabel.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 11.07.2024.
//

import SwiftUI

struct SidebarLabel: View {

	var systemName: String

	@State var list: ListItem

	@State var localText: String

	init(systemName: String, list: ListItem) {
		self.systemName = systemName
		self.list = list
		self._localText = State(initialValue: list.title)
	}
}

#if os(macOS)
extension SidebarLabel {

	var body: some View {
		HStack {
			Image(systemName: systemName)
			TextField("Description", text: $localText)
				.onSubmit {
					self.list.title = localText
				}
				.onChange(of: list.title) { oldValue, newValue in
					guard oldValue != newValue else {
						return
					}
					localText = newValue
				}
		}
	}
}
#else
extension SidebarLabel {

	var body: some View {
		HStack {
			Image(systemName: systemName)
			Text(list.title)
		}
	}
}
#endif

//#Preview {
//	SidebarLabel(systemName: "doc.text", text: .constant("Label"))
//}
