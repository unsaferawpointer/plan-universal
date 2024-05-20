//
//  BannerView.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 16.05.2024.
//

import SwiftUI

struct BannerView: View {

	var systemIcon: String

	var message: String

	var color: Color

	var body: some View {
		HStack {
			Image(systemName: systemIcon)
				.imageScale(.large)
				.foregroundStyle(color)
			Text(message)
				.lineLimit(3)
			Spacer()
		}
		.padding()
		.background(Color(.quaternarySystemFill))
		.cornerRadius(8, antialiased: true)
	}
}

#Preview {
	BannerView(systemIcon: "star.fill", message: "Message", color: .yellow)
}
