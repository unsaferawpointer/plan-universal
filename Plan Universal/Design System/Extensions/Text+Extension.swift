//
//  Text+Extension.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 18.07.2024.
//

import SwiftUI

extension Text {

	init(systemImage: String) {
		self.init("\(Image(systemName: "bolt.fill").symbolRenderingMode(.multicolor))")
	}
}
