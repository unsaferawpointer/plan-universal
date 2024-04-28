//
//  Checkmark.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 21.04.2024.
//

import SwiftUI

#if os(iOS)
struct Checkmark: View {

	@Binding var animate: Bool

	var body: some View {
		ZStack {
			RoundedRectangle(
				cornerSize: CGSize(width: 8, height: 8),
				style: .continuous
			)
			.fill(Color(animate ? UIColor(named: "checkmarkBackground")! : .secondarySystemFill))
				.frame(width: 24, height: 24)
			Path { path in
				path.move(to: .init(x: 0.20 * 16, y: 0.55 * 16))
				path.addLine(to: .init(x: 0.43 * 16, y: 0.75 * 16))
				path.addLine(to: .init(x: 0.85 * 16, y: 0.25 * 16))
			}
			.trim(from: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, to: animate ? 1 : 0)
			.stroke(
				Color.white,
				style: .init(
					lineWidth: 3.0,
					lineCap: .round,
					lineJoin: .round
				)
			)
			.opacity(animate ? 1 : 0)
			.frame(width: 16, height: 16)
		}

	}
}

#Preview {
	Checkmark(animate: .constant(true))
}
#endif
