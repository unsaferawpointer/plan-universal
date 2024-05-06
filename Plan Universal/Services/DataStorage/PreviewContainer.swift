//
//  PreviewContainer.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 28.04.2024.
//

import Foundation
import SwiftData

final class PreviewContainer {

	static var preview: ModelContainer = {
		do {
			return try ModelContainer(
				for: TodoItem.self,
				configurations: .init(isStoredInMemoryOnly: true)
			)
		} catch {
			fatalError("Failed to create container.")
		}
	}()
}
