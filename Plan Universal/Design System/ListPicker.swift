//
//  ListPicker.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 13.07.2024.
//

import SwiftUI
import SwiftData

struct ListPicker: View {

	@Query var lists: [ListItem]

	var action: (ListItem) -> Void

	var body: some View {
		ForEach(lists) { list in
			Button(list.title) {
				action(list)
			}
		}
	}
}

//#Preview {
//	ListPicker(, action: (ListItem) -> Void)
//}
