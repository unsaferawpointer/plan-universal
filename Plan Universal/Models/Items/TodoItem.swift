//
//  TodoItem.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 05.04.2024.
//

import SwiftData
import Foundation

@Model
final class TodoItem {

	var uuid: UUID = UUID()

	var text: String = ""

	var creationDate: Date?

	var completionDate: Date?

	// MARK: - Private properties

	private (set) var rawStatus: Int = TodoStatus.backlog.rawValue

	private (set) var rawPriority: Int = TodoPriority.low.rawValue

	// MARK: - Relationships

	@Relationship(deleteRule: .nullify) var list: ListItem?

	// MARK: - Initialization

	init(
		uuid: UUID,
		text: String,
		rawStatus: Int,
		rawPriority: Int,
		creationDate: Date,
		completionDate: Date?,
		list: ListItem?
	) {
		self.uuid = uuid
		self.text = text
		self.rawStatus = rawStatus
		self.rawPriority = rawPriority
		self.creationDate = creationDate
		self.completionDate = completionDate
		self.list = list
	}
}

// MARK: - Calculated properties
extension TodoItem {

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
}

// MARK: - Identifiable
extension TodoItem: Identifiable {

	var id: UUID {
		return uuid
	}
}

// MARK: - Templates
extension TodoItem {

	static var new: TodoItem {
		return TodoItem(
			uuid: .init(),
			text: String(localized: "New Todo"),
			rawStatus: TodoStatus.backlog.rawValue,
			rawPriority: TodoPriority.low.rawValue,
			creationDate: .now,
			completionDate: nil,
			list: nil
		)
	}
}
