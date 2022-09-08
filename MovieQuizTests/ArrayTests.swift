//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Юрий Демиденко on 05.09.2022.
//
// Тестируем subscript из Helpers/Array+Extensions

import XCTest
@testable import MovieQuiz

final class ArrayTests: XCTestCase {

    // Тест на успешное взятие элемента по индексу
    func testGetValueInRange() throws {
        // Given
        let array = [3, 3, 6, 2, 0]
        // When
        let result = array[safe: 2]
        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result, 6)
    }

    // Тест на взятие элемента по неправильному индексу
    func testGetValueOutOfRange() throws {
        // Given
        let array = [3, 3, 6, 2, 0]
        // When
        let result = array[safe: 5]
        // Then
        XCTAssertNil(result)
    }
}
