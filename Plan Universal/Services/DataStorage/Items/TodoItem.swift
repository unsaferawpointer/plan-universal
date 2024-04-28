//
//  TodoItem.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 24.04.2024.
//
//

import Foundation
import SwiftData


@Model 
class TodoItem {

	var uuid: UUID = UUID()
	var text: String = ""
	var creationDate: Date = Date()
	var completionDate: Date?
	var estimation: Int64 = 0
	var options: Int64 = 0

	// MARK: - Private properties

	private (set) var rawStatus: Int64 = 0
	private (set) var rawPriority: Int64 = 0

	// MARK: - Relationships

	@Relationship(deleteRule: .nullify) var list: ListItem?

	public init() { }
}

// MARK: - Identifiable
extension TodoItem: Identifiable { }

// MARK: - Computed properties
extension TodoItem {

	var isDone: Bool {
		get {
			return rawStatus == TodoStatus.done.rawValue
		}
		set {
			rawStatus = newValue ? TodoStatus.done.rawValue : TodoStatus.backlog.rawValue
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
}

// MARK: - ConfigurableItem
extension TodoItem: ConfigurableItem {

	typealias Configuration = TodoConfiguration

	var configuration: Configuration {
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

// MARK: - Convenience initialization
extension TodoItem {

	convenience init(_ configuration: TodoConfiguration) {
		self.init()
		self.text = configuration.text
		self.status = configuration.status
		self.priority = configuration.priority
		self.list = configuration.list
	}
}
