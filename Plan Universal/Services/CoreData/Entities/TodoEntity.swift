//
//  TodoEntity+CoreDataClass.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 14.04.2024.
//
//

import Foundation
import CoreData

@objc(TodoEntity)
public class TodoEntity: NSManagedObject { }

extension TodoEntity {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<TodoEntity> {
		return NSFetchRequest<TodoEntity>(entityName: "TodoItem")
	}

	@NSManaged public var uuid: UUID?
	@NSManaged public var text: String
	@NSManaged public var creationDate: Date?
	@NSManaged public var completionDate: Date?
	@NSManaged public var rawStatus: Int64
	@NSManaged public var rawPriority: Int64
	@NSManaged public var estimation: Int64
	@NSManaged public var options: Int64
	@NSManaged public var list: ListEntity?

}

// MARK: - Identifiable
extension TodoEntity : Identifiable { }

// MARK: - Calculated properties
extension TodoEntity {

	var priority: TodoPriority {
		get {
			return TodoPriority(rawValue: rawPriority) ?? .low
		}

		set {
			self.rawPriority = newValue.rawValue
		}
	}

	var isImportant: Bool {
		return priority == .medium || priority == .high
	}

	var isDone: Bool {
		get {
			return rawStatus == TodoStatus.done.rawValue
		}
		set {
			self.rawStatus = newValue ? TodoStatus.done.rawValue : TodoStatus.backlog.rawValue
			self.completionDate = newValue ? .now : nil
		}
	}

	var status: TodoStatus {
		get {
			return TodoStatus(rawValue: rawStatus) ?? .backlog
		}

		set {
			self.rawStatus = newValue.rawValue
			self.completionDate = newValue == .done ? .now : nil
		}
	}

	var configuration: TodoConfiguration {
		get {
			return .init(
				text: text,
				status: status,
				priority: priority,
				list: list
			)
		}
		set {
			self.text = newValue.text
			self.status = newValue.status
			self.priority = newValue.priority
			self.list = newValue.list
		}
	}
}

// MARK: - Templates
extension TodoEntity {

	convenience init(_ configutation: TodoConfiguration, in context: NSManagedObjectContext) {
		self.init(context: context)
		self.uuid = .init()
		self.text = configutation.text
		self.creationDate = .now
		self.completionDate = nil
		self.rawStatus = configutation.status.rawValue
		self.rawPriority = configutation.status.rawValue
		self.estimation = 0
		self.options = 0
		self.list = nil
	}

	static func new(in context: NSManagedObjectContext) -> TodoEntity {

		let entity = TodoEntity(context: context)

		entity.uuid = .init()
		entity.text = String(localized: "New Todo")
		entity.rawStatus = TodoStatus.backlog.rawValue
		entity.rawPriority = TodoPriority.low.rawValue
		entity.creationDate = .now
		entity.completionDate = nil
		entity.list = nil

		return entity
	}
}
