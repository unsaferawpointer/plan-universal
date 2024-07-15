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
	var options: Int64 = 0
	var rawEstimation: Int8?

	// MARK: - Flags

	var isUrgent: Bool = false
	var inFocus: Bool = false
	var isDone: Bool = false

	// MARK: - Private properties

	private (set) var creationDate: Date = Date()

	// MARK: - Relationships

	@Relationship(deleteRule: .nullify) var list: ListItem?

	// MARK: - Order

	var order: Int = 1

	// MARK: - Initialization

	public init() { }

	required init(_ configuration: TodoConfiguration) {
		self.text = configuration.text
		self.isDone = configuration.isDone
		self.isUrgent = configuration.isUrgent
		self.list = configuration.list
		self.rawEstimation = configuration.estimation?.rawValue
	}
}

// MARK: - Sortable
extension TodoItem: Sortable { }

// MARK: - Identifiable
extension TodoItem: Identifiable { }

// MARK: - ConfigurableItem
extension TodoItem: ConfigurableItem {

	typealias Configuration = TodoConfiguration

	var configuration: Configuration {
		get {
			return .init(
				text: text,
				isDone: isDone,
				isUrgent: isUrgent,
				estimation: TodoEstimation(rawValue: rawEstimation),
				list: list
			)
		}
		set {
			self.text = newValue.text
			self.isDone = newValue.isDone
			self.isUrgent = newValue.isUrgent
			self.rawEstimation = newValue.estimation?.rawValue
			self.list = newValue.list
		}
	}

}

// MARK: - Calculated properties
extension TodoItem {

	var storyPoints: Int {
		return estimation?.storyPoints ?? 0
	}

	var estimation: TodoEstimation? {
		get {
			guard let rawEstimation else {
				return nil
			}
			return TodoEstimation(rawValue: rawEstimation)
		}
		set {
			self.rawEstimation = newValue?.rawValue
		}
	}
}
