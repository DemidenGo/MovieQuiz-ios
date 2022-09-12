//
//  MovieQuizPresenterTests.swift
//  MovieQuizTests
//
//  Created by Юрий Демиденко on 08.09.2022.
//
// Тестируем презентер

import XCTest
@testable import MovieQuiz

final class MovieQuizPresenterTests: XCTestCase {

    // Тест метода конвертации модели вопроса во вью модель
    func testPresenterConverModel() throws {
        // Given
        let viewControllerMock = MovieQuizViewControllerMock()
        let presenter = MovieQuizPresenter(viewController: viewControllerMock)
        let imageData = UIImage(named: "The Dark Knight")?.pngData() ?? Data()
        let question = QuizQuestion(image: imageData, text: "Question Text", correctAnswer: true)
        // When
        let viewModel = presenter.convert(model: question)
        // Than
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1")
    }
}

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func disableUserInteractionForButtons() { }
    func enableUserInteractionForButtons() { }
    func showLoadingIndicator() { }
    func hideLoadingIndicator() { }
    func showAnswerResult(isCorrect: Bool) { }
    func show(quiz step: QuizStepViewModel) { }
    func show(quiz result: QuizResultsViewModel) { }
    func showNetworkError(message: String, buttonAction: @escaping () -> Void) { }
}
