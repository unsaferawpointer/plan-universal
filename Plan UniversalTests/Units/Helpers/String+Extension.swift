//
//  String+Extension.swift
//  Plan UniversalTests
//
//  Created by Anton Cherkasov on 21.07.2024.
//

import Foundation

extension String {

	static var random: String {
		return UUID().uuidString
	}
}
