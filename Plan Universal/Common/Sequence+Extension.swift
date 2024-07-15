//
//  Sequence+Extension.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 14.07.2024.
//

import Foundation

extension Sequence where Element: AdditiveArithmetic {

	var sum: Element {
		reduce(.zero) { partialResult, element in
			return partialResult + element
		}
	}
}
