//
//  Checkmark.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 21.04.2024.
//

import SwiftUI

struct Checkmark: View {

	@Binding var animate: Bool

	var body: some View {
		Path { path in
			path.move(to: .init(x: 0.1 * 16, y: 0.55 * 16))
			path.addLine(to: .init(x: 0.4 * 16, y: 0.85 * 16))
			path.addLine(to: .init(x: 1.0 * 16, y: 0.25 * 16))
		}
		.trim(from: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, to: animate ? 1 : 0)
		.stroke(Color.primary, lineWidth: 4.0)
		.opacity(animate ? 1 : 0)
		.frame(width: 16, height: 16)
	}
}
