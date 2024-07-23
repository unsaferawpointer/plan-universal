//
//  InFocusModelTests.swift
//  Plan UniversalTests
//
//  Created by Anton Cherkasov on 21.07.2024.
//

import XCTest
@testable import Plan_Universal

final class InFocusModelTests: XCTestCase {

	private var sut: InFocusModel!

	private var localization: InFocusLocalizationMock!

	override func setUpWithError() throws {
		self.localization = InFocusLocalizationMock()
		sut = InFocusModel(localization: localization)
	}

	override func tearDownWithError() throws {
		sut = nil
		localization = nil
	}
}

// MARK: - Test-cases
extension InFocusModelTests {

	func testSubtitle() throws {
		// Arrange
		let items: [TodoItem] = [.incomplete, .completed]
		localization.stubs.statusMessage = .random

		// Act
		let result = sut.subtitle(for: items)

		// Assert
		XCTAssertEqual(result, localization.stubs.statusMessage)
	}

	func testSubtitle_whenAllTodosCompleted() throws {
		// Arrange
		let items: [TodoItem] = [.completed, .completed, .completed]
		localization.stubs.allTodosCompleted = .random

		// Act
		let result = sut.subtitle(for: items)

		// Assert
		XCTAssertEqual(result, localization.stubs.allTodosCompleted)
	}

	func testSubtitle_whenAllTodosIncomplete() throws {
		// Arrange
		let items: [TodoItem] = [.incomplete, .incomplete, .incomplete]
		localization.stubs.statusMessageV2 = .random

		// Act
		let result = sut.subtitle(for: items)

		// Assert
		XCTAssertEqual(result, localization.stubs.statusMessageV2)
	}

	func testSubtitle_whenNoTodos() throws {
		// Arrange
		let items: [TodoItem] = []
		localization.stubs.noScheduledTodos = .random

		// Act
		let result = sut.subtitle(for: items)

		// Assert
		XCTAssertEqual(result, localization.stubs.noScheduledTodos)
	}
}
