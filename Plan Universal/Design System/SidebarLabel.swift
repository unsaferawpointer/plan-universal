//
//  SidebarLabel.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 11.07.2024.
//

import SwiftUI

struct SidebarLabel: View {

	var systemName: String

	@Binding var text: String

	@State var localText: String

	init(systemName: String, text: Binding<String>) {
		self.systemName = systemName
		self._text = text
		self._localText = State(initialValue: text.wrappedValue)
	}
}

#if os(macOS)
extension SidebarLabel {

	var body: some View {
		HStack {
			Image(systemName: systemName)
			TextField("Description", text: $localText)
				.onSubmit {
					self.text = localText
				}
		}
	}
}
#else
extension SidebarLabel {

	var body: some View {
		HStack {
			Image(systemName: systemName)
			Text(localText)
		}
	}
}
#endif

#Preview {
	SidebarLabel(systemName: "doc.text", text: .constant("Label"))
}
