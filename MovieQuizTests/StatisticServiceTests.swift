//
//  StatisticServiceTests.swift
//  MovieQuizTests
//
//  Created by Юрий Демиденко on 08.09.2022.
//
// Тестируем хранилище статистики

import XCTest
@testable import MovieQuiz

// MARK: - StatisticServiceTests

class StatisticServiceTests: XCTestCase {

    func testStatisticStorage() throws {
        // Given
        let statisticService = StatisticServiceImplementation()

        let initialTotalAccuracy = statisticService.totalAccuracy
        let initialGamesCount = statisticService.gamesCount
        let initialBestGame = statisticService.bestGame

        let newTotalAccuracy = 99.99
        let newGamesCount = 100
        let newBestGame = GameRecord(correct: 0, total: 10, date: Date().dateTimeString)

        // When
        statisticService.totalAccuracy = newTotalAccuracy
        statisticService.gamesCount = newGamesCount
        statisticService.store(correct: newBestGame.correct, total: newBestGame.total)

        let currentTotalAccuracy = statisticService.totalAccuracy
        let currentGamesCount = statisticService.gamesCount
        let currentBestGame = statisticService.bestGame

        // Возвращаем в хранилище первоначальные значения
        statisticService.totalAccuracy = initialTotalAccuracy
        statisticService.gamesCount = initialGamesCount
        statisticService.store(correct: initialBestGame.correct, total: initialBestGame.total)

        // Then
        XCTAssertEqual(currentTotalAccuracy, newTotalAccuracy)
        XCTAssertEqual(currentGamesCount, newGamesCount)
        XCTAssertEqual(currentBestGame.correct, newBestGame.correct)
        XCTAssertEqual(currentBestGame.total, newBestGame.total)
    }
}
