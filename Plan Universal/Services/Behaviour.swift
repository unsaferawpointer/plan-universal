//
//  Behaviour.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 06.04.2024.
//

import Foundation

enum Behaviour {
	case status(_ value: TodoStatus)
	case list(_ id: ListEntity)
}
