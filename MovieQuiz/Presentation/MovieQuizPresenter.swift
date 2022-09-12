//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Юрий Демиденко on 08.09.2022.
//

import UIKit

final class MovieQuizPresenter {

    let questionsAmount = 10
    var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var rightAnswerCounter = 0
    private var currentQuestionIndex = 0
    private var statisticService: StatisticServiceProtocol
    private var bestQuizResult: GameRecord { statisticService.bestGame }
    private weak var viewController: MovieQuizViewControllerProtocol?

    init(viewController: MovieQuizViewControllerProtocol,
         statisticService: StatisticServiceProtocol = StatisticServiceImplementation()) {
        self.viewController = viewController
        self.statisticService = statisticService
    }

    // MARK: - Internal functions

    // Конвертируем модель вопроса во вью модель для состояния "Вопрос задан"
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let image = UIImage(data: model.image)
        let question = model.text
        let questionNumber = String(currentQuestionIndex + 1)
        return QuizStepViewModel(image: image, question: question, questionNumber: questionNumber)
    }

    // Проверяем правильность ответа
    func check(userAnswer: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        if userAnswer == currentQuestion.correctAnswer {
            viewController?.showAnswerResult(isCorrect: true)
            rightAnswer()
        } else {
            viewController?.showAnswerResult(isCorrect: false)
        }
    }

    // Задержка показа следующего вопроса
    func showNextQuestionOrResultWithDelay(seconds: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.showNextQuestionOrResult()
        }
    }

    func restartGame() {
        currentQuestionIndex = 0
        rightAnswerCounter = 0
        questionFactory?.requestNextQuestion()
    }

    // MARK: - Private functions

    // Проверка окончания игры
    private func showNextQuestionOrResult() {
        if isLastQuestion() {
            // вычисляем и показываем результат квиза
            calculateQuizResult()
            viewController?.show(quiz: makeQuizResultsModel())
        } else {
            // показываем следующий вопрос
            switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }

    private func calculateQuizResult() {
        statisticService.gamesCount += 1
        if bestQuizResult.isWorseThan(currentQuizScore: rightAnswerCounter) {
            statisticService.store(correct: rightAnswerCounter, total: questionsAmount)
        }
        let currentAccuracy = round(Double(rightAnswerCounter) / Double(questionsAmount) * 100)
        let gamesCount = Double(statisticService.gamesCount)
        let previousGamesCount = Double(statisticService.gamesCount - 1)
        let totalAccuracy = (statisticService.totalAccuracy * (previousGamesCount) + currentAccuracy) / gamesCount
        let totalAccuracyRounded = round(totalAccuracy * 100) / 100
        statisticService.totalAccuracy = totalAccuracyRounded
    }

    private func makeQuizResultsModel() -> QuizResultsViewModel {
        QuizResultsViewModel.makeModel(for: rightAnswerCounter,
                                       questionsAmount,
                                       statisticService.gamesCount,
                                       bestQuizResult,
                                       statisticService.totalAccuracy)
    }

    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }

    private func switchToNextQuestion() {
        currentQuestionIndex += 1
    }

    private func rightAnswer() {
        rightAnswerCounter += 1
    }
}

// MARK: - QuestionFactoryDelegate

extension MovieQuizPresenter: QuestionFactoryDelegate {
    
    // Получен вопрос для квиза
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        currentQuestion = question
        let quizStep = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.hideLoadingIndicator()
            self?.viewController?.show(quiz: quizStep)
        }
    }

    // Данные успешно загружены
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }

    // Пришла ошибка от сервера
    func didFailToLoadData(with error: String, buttonAction: @escaping () -> Void) {
        viewController?.hideLoadingIndicator()
        viewController?.showNetworkError(message: error) {
            buttonAction()
        }
    }

    // Метод показа индикатора для QuestionFactory
    func showLoadingIndicator() {
        viewController?.showLoadingIndicator()
    }
}
