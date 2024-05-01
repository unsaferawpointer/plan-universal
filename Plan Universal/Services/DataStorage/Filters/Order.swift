//
//  Order.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 28.04.2024.
//

import Foundation

protocol Order {
	
	associatedtype Element

	var sortDescriptor: SortDescriptor<Element> { get }
}
