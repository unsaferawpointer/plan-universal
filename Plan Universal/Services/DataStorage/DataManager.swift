//
//  DataManager.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 24.04.2024.
//

import Foundation
import SwiftData

protocol DataManagerProtocol {
	func insert(_ todo: TodoConfiguration, in context: ModelContext)
	func insert(_ list: ListConfiguration, in context: ModelContext)

	func delete(_ todo: TodoConfiguration, in context: ModelContext)
	func delete(_ list: ListConfiguration, in context: ModelContext)
}

final class DataManager {

}

// MARK: - DataManagerProtocol
extension DataManager: DataManagerProtocol {

	func insert(_ todo: TodoConfiguration, in context: ModelContext) {
		<#code#>
	}
	
	func insert(_ list: ListConfiguration, in context: ModelContext) {
		<#code#>
	}

	func delete(_ todo: TodoConfiguration, in context: ModelContext) {
		<#code#>
	}

	func delete(_ list: ListConfiguration, in context: ModelContext) {
		<#code#>
	}
}
