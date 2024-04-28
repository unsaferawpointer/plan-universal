//
//  ListDetailsModel.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 18.04.2024.
//

import Foundation

//final class ListDetailsModel: ObservableObject {
//
//	// MARK: - Published
//
//	@Published var configuration: ListConfiguration
//
//	// MARK: - DI
//
//	private (set) var action: DetailsAction<ListItem>
//
//	// MARK: - Initialization
//
//	init(action: DetailsAction<ListItem>) {
//		self.action = action
//		self._configuration = Published(initialValue: action.configuration)
//	}
//}
//
//// MARK: - Public interface
//extension ListDetailsModel {
//
//	func delete() {
//		switch action {
//		case .new:
//			fatalError()
//		case .edit(let list):
//			dataStorage.deleteLists([list])
//		}
//	}
//
//	func save() {
//
//		let trimmed = configuration.title.trimmingCharacters(in: .whitespaces)
//		let title = trimmed.isEmpty ? String(localized: "New List") : trimmed
//
//		switch action {
//		case .new:
//			let new = dataStorage.insertList(configuration)
//			new.title = title
//		case .edit(let list):
//			list.configuration = configuration
//			list.title = title
//		}
//		try? dataStorage.save()
//	}
//
//	var buttonToDeleteIsEnabled: Bool {
//		guard case .edit = action else {
//			return false
//		}
//		return true
//	}
//
//	var buttonToSaveIsEnabled: Bool {
//		let trimmed = configuration.title.trimmingCharacters(in: .whitespaces)
//		return !trimmed.isEmpty
//	}
//}
