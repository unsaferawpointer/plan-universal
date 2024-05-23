//
//  TodoConfiguration.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 24.04.2024.
//

import Foundation

struct TodoConfiguration {

	var text: String = ""

	var isDone: Bool = false

	var isUrgent: Bool = false
}

// MARK: - Hashable
extension TodoConfiguration: Hashable { }
