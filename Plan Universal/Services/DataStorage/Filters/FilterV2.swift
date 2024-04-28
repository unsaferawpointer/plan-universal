//
//  FilterV2.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 26.04.2024.
//

import Foundation

protocol Filter {

	associatedtype Element

	var predicate: Predicate<Element> { get }
}
