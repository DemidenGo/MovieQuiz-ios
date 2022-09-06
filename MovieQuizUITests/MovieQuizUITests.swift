//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Юрий Демиденко on 06.09.2022.
//
// Тестируем UI приложения

import XCTest

class MovieQuizUITests: XCTestCase {

    var app: XCUIApplication!

    // Задаём начальное состояние приложения
    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
    }

    // Сбрасываем состояние приложения после каждого теста
    override func tearDownWithError() throws {
        app.terminate()
        app = nil
    }

    func testYesButton() throws {
        let firstPoster = app.images["Poster"]
        app.buttons["Yes"].tap()
        sleep(1)
        let secondPoster = app.images["Poster"]
        let indexLabel = app.staticTexts["Index"]
        XCTAssertFalse(firstPoster == secondPoster)
        XCTAssertTrue(indexLabel.label == "2/10")
    }

    func testNoButton() throws {
        let firstPoster = app.images["Poster"]
        app.buttons["No"].tap()
        sleep(1)
        let secondPoster = app.images["Poster"]
        let indexLabel = app.staticTexts["Index"]
        XCTAssertFalse(firstPoster == secondPoster)
        XCTAssertTrue(indexLabel.label == "2/10")
    }

    // Тест появления алерта при окончании раунда
    func testResultAlertDidAppear() throws {
        app.buttons["Yes"].tap()
        sleep(1)
        app.buttons["Yes"].tap()
        sleep(1)
        app.buttons["Yes"].tap()
        sleep(1)
        app.buttons["Yes"].tap()
        sleep(1)
        app.buttons["Yes"].tap()
        sleep(1)
        app.buttons["Yes"].tap()
        sleep(1)
        app.buttons["Yes"].tap()
        sleep(1)
        app.buttons["Yes"].tap()
        sleep(1)
        app.buttons["Yes"].tap()
        sleep(1)
        app.buttons["Yes"].tap()
        sleep(1)
        let alert = app.alerts.firstMatch
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alert.label, "Этот раунд окончен!")
        XCTAssertEqual(alert.buttons.firstMatch.label, "Сыграть ещё раз")
    }

    // Тест скрытия алерта после нажатия на кнопку на нём
    func testResultAlertDidDisappear() throws {
        app.buttons["Yes"].tap()
        sleep(1)
        app.buttons["Yes"].tap()
        sleep(1)
        app.buttons["Yes"].tap()
        sleep(1)
        app.buttons["Yes"].tap()
        sleep(1)
        app.buttons["Yes"].tap()
        sleep(1)
        app.buttons["Yes"].tap()
        sleep(1)
        app.buttons["Yes"].tap()
        sleep(1)
        app.buttons["Yes"].tap()
        sleep(1)
        app.buttons["Yes"].tap()
        sleep(1)
        app.buttons["Yes"].tap()
        sleep(1)
        let alert = app.alerts.firstMatch
        alert.buttons.firstMatch.tap()
        XCTAssertFalse(alert.exists)
        let indexLabel = app.staticTexts["Index"]
        XCTAssertTrue(indexLabel.label == "1/10")
    }
}
