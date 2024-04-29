//
//  Icon.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 29.04.2024.
//

import Foundation

enum Icon: Int64 {
	case doc = 0
	case folder
	case bookClosed
	case bubble
	case envelope
	case `case`
	// MARK: - Home
	case house
	case lightbulb
	case sofa
	// MARK: - Fitness
	case baseball
	case basketball
	// MARK: - Nature
	case sunMax
	case cloud
	case cloudBolt
	case flame
	case carrot
	case ladybug
	// MARK: - Editing
	case sliderHorizontal2Square
	// MARK: - Commerce
	case cart
	case bag
	case creditcard
	// MARK: - Health
	case heart
	case crossCase
	case cross
}

// MARK: - CaseIterable
extension Icon: CaseIterable { }

extension Icon {

	var iconName: String {
		switch self {
		case .doc:
			"doc.text"
		case .folder:
			"folder"
		case .bookClosed:
			"book.closed"
		case .sunMax:
			"sun.max"
		case .bubble:
			"bubble"
		case .envelope:
			"envelope"
		case .case:
			"case"
		case .house:
			"house"
		case .lightbulb:
			"lightbulb"
		case .sofa:
			"sofa"
		case .baseball:
			"baseball"
		case .basketball:
			"basketball"
		case .cloud:
			"cloud"
		case .cloudBolt:
			"cloud.bolt"
		case .flame:
			"flame"
		case .carrot:
			"carrot"
		case .ladybug:
			"ladybug"
		case .sliderHorizontal2Square:
			"slider.horizontal.2.square"
		case .cart:
			"cart"
		case .bag:
			"bag"
		case .creditcard:
			"creditcard"
		case .heart:
			"heart"
		case .crossCase:
			"cross.case"
		case .cross:
			"cross"
		}
	}
}
