//
//  TodoEstimation.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 14.07.2024.
//

import Foundation

enum TodoEstimation: Int8 {
	case xs = 0
	case s
	case m
	case l
	case xl
	case xxl
}

// MARK: - CaseIterable
extension TodoEstimation: CaseIterable { }

// MARK: - Identifiable
extension TodoEstimation: Identifiable {

	var id: RawValue {
		return rawValue
	}
}

// MARK: - Calculated properties
extension TodoEstimation {

	var storyPoints: Int {
		switch self {
		case .xs:
			return 1
		case .s:
			return 2
		case .m:
			return 3
		case .l:
			return 5
		case .xl:
			return 8
		case .xxl:
			return 13
		}
	}
}

extension TodoEstimation {

	init?(rawValue: Int8?) {
		guard let rawValue else {
			return nil
		}
		self.init(rawValue: rawValue)
	}
}
