//
//  NavigationModel.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 14.04.2024.
//

import Foundation
import Combine

final class NavigationModel: ObservableObject {

	@Published var lists: [ListEntity] = []

	private var cancellable: AnyCancellable?

	var dataStorage: DataStorageProtocol

	init(
		publisher: AnyPublisher<[ListEntity], Never> = PersistentContainer.shared.mainContext.publisher(for: ListEntity.self, filter: ListFilter.all, order: ListOrder.creationDate).eraseToAnyPublisher(),
		dataStorage: DataStorageProtocol = DataStorage()
	) {
		self.dataStorage = dataStorage
		cancellable = publisher.sink { entities in
			self.lists = entities
		}
	}

}

extension NavigationModel {

	func newList() {
		dataStorage.insertList(.default)
		try? dataStorage.save()
	}

	func deleteList(_ list: ListEntity) {
		dataStorage.deleteLists([list])
		try? dataStorage.save()
	}
}
