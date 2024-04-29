//
//  PreviewContainer.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 28.04.2024.
//

import Foundation
import SwiftData

@MainActor
let previewContainer: ModelContainer = {

	do {

		let container = try ModelContainer(for: TodoItem.self, configurations: .init(isStoredInMemoryOnly: true))
		return container

	} catch {
		fatalError("Failed to create container.")
	}
}()
