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
				.subtracting(
					Path { path in
						path.move(to:
								.init(
									x: 0.25 * geometry.size.width,
									y: 0.75 * geometry.size.height
								)
						)
						path.addLine(to:
								.init(
									x: 0.75 * geometry.size.width,
									y: 0.25 * geometry.size.height
								)
						)
					}
						.stroke(lineWidth: 3.0)
						.trim(from: isDone ? 0 : 0.5, to: isDone ? 1 : 0.5)
				)
				.subtracting(
					Path { path in
						path.move(to:
								.init(
									x: 0.25 * geometry.size.width,
									y: 0.25 * geometry.size.height
								)
						)
						path.addLine(to:
								.init(
									x: 0.75 * geometry.size.width,
									y: 0.75 * geometry.size.height
								)
						)
					}
						.stroke(lineWidth: 3.0)
						.trim(from: isDone ? 0 : 0.5, to: isDone ? 1 : 0.5)
				)
				#if os(iOS)
				.fill(Color(isDone ? .tertiaryLabel : .secondarySystemFill))
				.stroke(Color(.quaternaryLabel), lineWidth: 0.8)
				#elseif os(macOS)
				.fill(Color(isDone ? .tertiaryLabelColor : .secondarySystemFill))
				.stroke(Color(.quaternaryLabelColor), lineWidth: 0.8)
				#endif
			}
		}
		.contentShape(Rectangle())
	}
}
#endif

#Preview {
	Checkmark(isDone: .constant(false))
}
