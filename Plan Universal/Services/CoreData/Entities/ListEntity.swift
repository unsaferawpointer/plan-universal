//
//  ListEntity+CoreDataClass.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 14.04.2024.
//
//

import Foundation
import CoreData

@objc(ListEntity)
public class ListEntity: NSManagedObject { }

extension ListEntity {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<ListEntity> {
		return NSFetchRequest<ListEntity>(entityName: "ListItem")
	}

	@NSManaged public var uuid: UUID?
	@NSManaged public var title: String
	@NSManaged public var isArchieved: Bool
	@NSManaged public var isFavorite: Bool
	@NSManaged public var creationDate: Date?
	@NSManaged public var rawIcon: Int64
	@NSManaged public var options: Int64
	@NSManaged public var todos: NSSet?

}

// MARK: Generated accessors for todos
extension ListEntity {

	@objc(addTodosObject:)
	@NSManaged public func addToTodos(_ value: TodoEntity)

	@objc(removeTodosObject:)
	@NSManaged public func removeFromTodos(_ value: TodoEntity)

	@objc(addTodos:)
	@NSManaged public func addToTodos(_ values: NSSet)

	@objc(removeTodos:)
	@NSManaged public func removeFromTodos(_ values: NSSet)

}

// MARK: - Identifiable
extension ListEntity : Identifiable { }

// MARK: - Templates
extension ListEntity {

	convenience init(_ configutation: ListConfiguration, in context: NSManagedObjectContext) {
		self.init(context: context)
		self.uuid = .init()
		self.title = configutation.title
		self.isArchieved = configutation.isArchieved
		self.isFavorite = configutation.isFavorite
		self.creationDate = .now
		self.rawIcon = 0
		self.options = 0
	}

	var configuration: ListConfiguration {
		get {
			return .init(
				uuid: uuid ?? UUID(),
				title: title,
				isArchieved: isArchieved,
				isFavorite: isFavorite
			)
		}
		set {
			self.title = newValue.title
			self.isArchieved = newValue.isArchieved
			self.isFavorite = newValue.isFavorite
		}
	}

	static func new(in context: NSManagedObjectContext) -> ListEntity {

		let entity = ListEntity(context: context)

		entity.uuid = .init()
		entity.title = String(localized: "New List")
		entity.isArchieved = false
		entity.isFavorite = false
		entity.creationDate = .now
		entity.rawIcon = 0

		return entity
	}
}
