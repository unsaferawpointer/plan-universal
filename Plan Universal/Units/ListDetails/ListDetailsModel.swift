//
//  ListDetailsModel.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 18.04.2024.
//

import Foundation

final class ListDetailsModel: ObservableObject {

	// MARK: - Published

	@Published var configuration: ListConfiguration

	// MARK: - DI

	private (set) var action: DetailsAction<ListEntity>

	private let dataStorage: DataStorageProtocol

	// MARK: - Initialization

	init(
		_ action: DetailsAction<ListEntity>,
		dataStorage: DataStorageProtocol = DataStorage()
	) {
		self.action = action
		self.dataStorage = dataStorage
		let initialConfiguration = action.wrappedValue?.configuration ?? .default
		self._configuration = Published(initialValue: initialConfiguration)
	}
}

// MARK: - Public interface
extension ListDetailsModel {

	func delete() {
		switch action {
		case .new:
			fatalError()
		case .edit(let list):
			dataStorage.deleteLists([list])
		}
	}

	func save() {

		let trimmed = configuration.title.trimmingCharacters(in: .whitespaces)
		let title = trimmed.isEmpty ? String(localized: "New List") : trimmed

		switch action {
		case .new:
			let new = dataStorage.insertList(configuration)
			new.title = title
		case .edit(let list):
			list.configuration = configuration
			list.title = title
		}
		try? dataStorage.save()
	}

	var buttonToDeleteIsEnabled: Bool {
		guard case .edit = action else {
			return false
		}
		return true
	}

	var buttonToSaveIsEnabled: Bool {
		let trimmed = configuration.title.trimmingCharacters(in: .whitespaces)
		return !trimmed.isEmpty
	}
}
