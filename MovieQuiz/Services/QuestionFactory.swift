//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Юрий Демиденко on 22.08.2022.
//

import UIKit

class QuestionFactory: QuestionFactoryProtocol {

    private var questions: [QuizQuestion] = QuizQuestion.makeMockModel()

    func requestNextQuestion() -> QuizQuestion? {
        let index = (0..<questions.count).randomElement() ?? 0
        return questions[safe: index]
    }
}
