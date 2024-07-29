//
//  Sequence+Extension.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 14.07.2024.
//

import Foundation

extension Sequence {

	func count<T: Equatable>(where keyPath: KeyPath<Element, T>, equalsTo value: T) -> Int {
		var result = 0
		forEach {
			if $0[keyPath: keyPath] == value {
				result += 1
			}
		}
		return result
	}

	func filter<T: Equatable>(where keyPath: KeyPath<Element, T>, equalsTo value: T) -> [Element] {
		filter {
			$0[keyPath: keyPath] == value
		}
	}
}

extension Sequence where Element: AdditiveArithmetic {

	var sum: Element {
		reduce(.zero) { partialResult, element in
			return partialResult + element
		}
	}
}

extension Sequence {

	func sum<T: AdditiveArithmetic>(keyPath: KeyPath<Element, T>) -> T {
		reduce(.zero) { partialResult, element in
			return partialResult + element[keyPath: keyPath]
		}
	}
}
