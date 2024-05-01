//
//  ImpactFeedbackFacade.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 01.05.2024.
//

import Foundation

protocol ImpactFeedbackFacadeProtocol {
	func impactOccurred()
}

final class ImpactFeedbackFacade { }

#if os(iOS)

import UIKit

// MARK: - ImpactFeedbackFacadeProtocol
extension ImpactFeedbackFacade: ImpactFeedbackFacadeProtocol {

	func impactOccurred() {
		let impact = UIImpactFeedbackGenerator(style: .medium)
		impact.impactOccurred()
	}
}
#else

import AppKit

// MARK: - ImpactFeedbackFacadeProtocol
extension ImpactFeedbackFacade: ImpactFeedbackFacadeProtocol {

	func impactOccurred() {
		NSHapticFeedbackManager.defaultPerformer.perform(.alignment, performanceTime: .drawCompleted)
	}
}
#endif
