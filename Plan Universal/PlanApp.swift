//
//  PlanApp.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 05.04.2024.
//

import SwiftUI
import SwiftData

@main
struct PlanApp: App {

	let container: ModelContainer = {
		let schema = Schema([TodoItem.self, ListItem.self, ProjectItem.self])
		let container = try! ModelContainer(for: schema, configurations: [])
		return container
	}()

	var body: some Scene {
		WindowGroup {
			RootView()
				.modelContainer(container)
		}
	}
}
