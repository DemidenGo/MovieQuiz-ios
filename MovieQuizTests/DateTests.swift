//
//  DateTests.swift
//  MovieQuizTests
//
//  Created by Юрий Демиденко on 05.09.2022.
//
// Тестируем расширение Date из Helpers/Date+Extensions

import XCTest
@testable import MovieQuiz

final class DateTests: XCTestCase {

    func testGetRightDateFormat() throws {
        // Given
        let date = Date()
        let rightDateFormatter = DateFormatter()
        rightDateFormatter.dateFormat = "dd.MM.YY HH:mm"

        // When
        let stringDate = date.dateTimeString

        // Then
        XCTAssertEqual(stringDate, rightDateFormatter.string(from: date))
    }
}
