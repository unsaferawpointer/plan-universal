//
//  ListItem.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 24.04.2024.
//
//

import Foundation
import SwiftData


@Model public class ListItem {

	var uuid: UUID?
	var title: String? = ""
	var isArchieved: Bool?
	var isFavorite: Bool?
	var creationDate: Date?
	var rawIcon: Int64? = 0
	var options: Int64? = 0
	@Relationship(deleteRule: .cascade, inverse: \TodoItem.list) var todos: [TodoItem]?
	public init() {

	}

}
