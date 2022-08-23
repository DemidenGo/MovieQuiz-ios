//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Юрий Демиденко on 22.08.2022.
//

import UIKit

class QuestionFactory: QuestionFactoryProtocol {

    private var questions: [QuizQuestion] = QuizQuestion.makeMockModel()

    private let delegate: QuestionFactoryDelegate

    init(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }

    func requestNextQuestion() {
        let index = (0..<questions.count).randomElement() ?? 0
        let question = questions[safe: index]
        delegate.didReceiveNextQuestion(question: question)
    }
}
