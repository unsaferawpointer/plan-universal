//
//  Checkmark.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 21.04.2024.
//

import SwiftUI

#if os(iOS) || os(macOS)
struct Checkmark: View {

	// MARK: - Locale state

	@Binding var isDone: Bool

	// MARK: - Initialization

	init(isDone: Binding<Bool>) {
		self._isDone = isDone
	}

	var body: some View {
		GeometryReader { geometry in
			ZStack {
				RoundedRectangle(
					cornerSize: CGSize(width: 4, height: 4),
					style: .continuous
				)
				.fill(Color(isDone ? .secondaryLabelColor : .secondarySystemFill))
				.stroke(Color(.quaternaryLabelColor), lineWidth: 1.2)
				Path { path in
					path.move(to:
							.init(
								x: 0.30 * geometry.size.width,
								y: 0.70 * geometry.size.height
							)
					)
					path.addLine(to:
							.init(
								x: 0.70 * geometry.size.width,
								y: 0.30 * geometry.size.height
							)
					)
				}
				.trim(from: isDone ? 0 : 0.5, to: isDone ? 1 : 0.5)
				.stroke(
					Color(.textBackgroundColor),
					style: .init(
						lineWidth: 2.0,
						lineCap: .round,
						lineJoin: .miter
					)
				)
				.opacity(isDone ? 1 : 0)

				Path { path in
					path.move(to:
							.init(
								x: 0.30 * geometry.size.width,
								y: 0.30 * geometry.size.height
							)
					)
					path.addLine(to:
							.init(
								x: 0.70 * geometry.size.width,
								y: 0.70 * geometry.size.height
							)
					)
				}
				.trim(from: isDone ? 0 : 0.5, to: isDone ? 1 : 0.5)
				.stroke(
					Color(.textBackgroundColor),
					style: .init(
						lineWidth: 2.0,
						lineCap: .round,
						lineJoin: .miter
					)
				)
				.opacity(isDone ? 1 : 0)
			}
		}
	}
}
#endif

#if os(iOS)
#Preview {
	Checkmark(animate: .constant(false))
}
#endif
