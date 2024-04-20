//
//  DataStorageProtocol.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 20.04.2024.
//

protocol DataStorageProtocol {

	// MARK: - Insert

	@discardableResult
	func insertList(_ configuration: ListConfiguration) -> ListEntity

	@discardableResult
	func insertTodo(_ configuration: TodoConfiguration) -> TodoEntity

	// MARK: - Delete

	func deleteTodos(_ todos: [TodoEntity])

	func deleteLists(_ lists: [ListEntity])

	// MARK: - Update

	func update(_ todo: TodoEntity, with configuration: TodoConfiguration)

	func update(_ list: ListEntity, with configuration: ListConfiguration)

	func setStatus(_ status: TodoStatus, for todos: [TodoEntity])

	func setPriority(_ priority: TodoPriority, for todos: [TodoEntity])

	// MARK: - Save

	func save() throws
}
