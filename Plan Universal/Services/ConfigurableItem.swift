//
//  ConfigurableItem.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 28.04.2024.
//

import Foundation

protocol ConfigurableItem {

	associatedtype Configuration

	var configuration: Configuration { get set }
}
