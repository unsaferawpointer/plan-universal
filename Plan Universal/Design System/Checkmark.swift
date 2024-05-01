//
//  Checkmark.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 21.04.2024.
//

import SwiftUI

#if os(iOS)
struct Checkmark: View {

	// MARK: - Locale state

	@Binding var animate: Bool

	// MARK: - Initialization

	init(animate: Binding<Bool>) {
		self._animate = animate
	}

	var body: some View {
		ZStack {
			RoundedRectangle(
				cornerSize: CGSize(width: 8, height: 8),
				style: .continuous
			)
			.fill(Color(animate ? UIColor(named: "checkmarkBackground")! : .secondarySystemFill))
			.frame(width: 24, height: 24)
			Path { path in
				path.move(to: .init(x: 0.20 * 10, y: 0.55 * 10))
				path.addLine(to: .init(x: 0.43 * 10, y: 0.75 * 10))
				path.addLine(to: .init(x: 0.85 * 10, y: 0.25 * 10))
			}
			.trim(from: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, to: animate ? 1 : 0)
			.stroke(
				Color.white,
				style: .init(
					lineWidth: 3.0,
					lineCap: .square,
					lineJoin: .miter
				)
			)
			.opacity(animate ? 1 : 0)
			.frame(width: 10, height: 10)
		}
	}
}
#endif

#if os(iOS)
#Preview {
	Checkmark(animate: .constant(false))
}
#endif
