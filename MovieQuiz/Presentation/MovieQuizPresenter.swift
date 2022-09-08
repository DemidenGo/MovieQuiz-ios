//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Юрий Демиденко on 08.09.2022.
//

import UIKit

final class MovieQuizPresenter {

    let questionsAmount = 10
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    private var rightAnswerCounter = 0
    private var currentQuestionIndex = 0

    // MARK: - Internal functions
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        // конвертируем модель вопроса во вью модель для состояния "Вопрос задан"
        let image = UIImage(data: model.image)
        let question = model.text
        let questionNumber = String(currentQuestionIndex + 1)
        return QuizStepViewModel(image: image, question: question, questionNumber: questionNumber)
    }

    func check(userAnswer: Bool) {
        // Проверяем правильность ответа
        guard let currentQuestion = currentQuestion else { return }
        if userAnswer == currentQuestion.correctAnswer {
            viewController?.showAnswerResult(isCorrect: true)
            rightAnswerCounter += 1
        } else {
            viewController?.showAnswerResult(isCorrect: false)
        }
    }

    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }

    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }

    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }

    func rightAnswer() {
        rightAnswerCounter += 1
    }

    func resetRightAnswerCounnter() {
        rightAnswerCounter = 0
    }

    func getRightAnswers() -> Int {
        rightAnswerCounter
    }
}
