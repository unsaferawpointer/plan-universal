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
final class TodoItem {

	var uuid: UUID = UUID()
	var text: String = ""
	var isUrgent: Bool = false
	var options: Int64 = 0

	// MARK: - Private properties

	private (set) var rawStatus: Int64 = 0

	private (set) var creationDate: Date = Date()

	// MARK: - Relationships

	@Relationship(deleteRule: .nullify) var list: ListItem?

	// MARK: - Order

	var order: Int = 1

	// MARK: - Initialization

	public init() { }

	required init(_ configuration: TodoConfiguration) {
		self.text = configuration.text
		self.status = configuration.status
		self.list = configuration.list
	}
}

// MARK: - Sortable
extension TodoItem: Sortable { }

// MARK: - Identifiable
extension TodoItem: Identifiable { }

// MARK: - Computed properties
extension TodoItem {

	var isDone: Bool {
		get {
			guard case .done = status else {
				return false
			}
			return true
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
		}
	}

	var isImportant: Bool {
		return false
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
				list: list
			)
		}
		set {
			self.text = newValue.text
			self.status = newValue.status
			self.list = newValue.list
		}
	}

}
