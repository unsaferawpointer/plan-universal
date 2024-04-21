//
//  DetailsTodoRowElements.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 21.04.2024.
//

import Foundation

struct DetailsTodoRowElements: OptionSet {

	var rawValue: Int

	static let listLabel = DetailsTodoRowElements(rawValue: 1 << 0 )
}
