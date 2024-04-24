//
//  TodoItem.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 24.04.2024.
//
//

import Foundation
import SwiftData


@Model public class TodoItem {
	var uuid: UUID?
	var text: String? = ""
	var creationDate: Date?
	var completionDate: Date?
	var rawStatus: Int64? = 0
	var rawPriority: Int64? = 0
	var estimation: Int64? = 0
	var options: Int64? = 0
	var list: ListItem?
	public init() {
		
	}
	
}
