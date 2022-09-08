//
//  StatisticServiceTests.swift
//  MovieQuizTests
//
//  Created by Юрий Демиденко on 08.09.2022.
//
// Тестируем сервис статистики

import XCTest
@testable import MovieQuiz

// MARK: - StatisticServiceTests

class StatisticServiceTests: XCTestCase {

    // Тест хранилища
    func testSaveGamesCountToStorage() throws {
        // Given
        let statisticService = StatisticServiceImplementation()
        let currentGamesCount = statisticService.gamesCount

        // When
        statisticService.gamesCount += 1
        statisticService.gamesCount -= 1
        let modifiedGamesCount = statisticService.gamesCount

        // Then
        XCTAssertEqual(currentGamesCount, modifiedGamesCount)
    }
}
