//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Юрий Демиденко on 08.09.2022.
//

import UIKit

final class MovieQuizPresenter {

    let questionsAmount = 10
    private var currentQuestionIndex = 0
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        // конвертируем модель вопроса во вью модель для состояния "Вопрос задан"
        let image = UIImage(data: model.image)
        let question = model.text
        let questionNumber = String(currentQuestionIndex + 1)
        return QuizStepViewModel(image: image, question: question, questionNumber: questionNumber)
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
}
