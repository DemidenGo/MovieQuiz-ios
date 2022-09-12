//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by Юрий Демиденко on 22.08.2022.
//

import UIKit

// Модель вопроса
struct QuizQuestion {
    let image: Data
    let text: String
    let correctAnswer: Bool
}

// Формирование модели mock-данных для тестирования
extension QuizQuestion {
    static func makeMockModel() -> [QuizQuestion] {
        var model = [QuizQuestion]()

        model.append(QuizQuestion(image: UIImage(named: "The Godfather")?.pngData() ?? Data(),
                                  text: "Рейтинг этого фильма больше чем 6?",
                                  correctAnswer: true))

        model.append(QuizQuestion(image: UIImage(named: "The Dark Knight")?.pngData() ?? Data(),
                                  text: "Рейтинг этого фильма больше чем 6?",
                                  correctAnswer: true))

        model.append(QuizQuestion(image: UIImage(named: "Kill Bill")?.pngData() ?? Data(),
                                  text: "Рейтинг этого фильма больше чем 6?",
                                  correctAnswer: true))

        model.append(QuizQuestion(image: UIImage(named: "The Avengers")?.pngData() ?? Data(),
                                  text: "Рейтинг этого фильма больше чем 6?",
                                  correctAnswer: true))

        model.append(QuizQuestion(image: UIImage(named: "Deadpool")?.pngData() ?? Data(),
                                  text: "Рейтинг этого фильма больше чем 6?",
                                  correctAnswer: true))

        model.append(QuizQuestion(image: UIImage(named: "The Green Knight")?.pngData() ?? Data(),
                                  text: "Рейтинг этого фильма больше чем 6?",
                                  correctAnswer: true))

        model.append(QuizQuestion(image: UIImage(named: "Old")?.pngData() ?? Data(),
                                  text: "Рейтинг этого фильма больше чем 6?",
                                  correctAnswer: false))

        model.append(QuizQuestion(image: UIImage(named: "The Ice Age Adventures of Buck Wild")?.pngData() ?? Data(),
                                  text: "Рейтинг этого фильма больше чем 6?",
                                  correctAnswer: false))

        model.append(QuizQuestion(image: UIImage(named: "Tesla")?.pngData() ?? Data(),
                                  text: "Рейтинг этого фильма больше чем 6?",
                                  correctAnswer: false))

        model.append(QuizQuestion(image: UIImage(named: "Vivarium")?.pngData() ?? Data(),
                                  text: "Рейтинг этого фильма больше чем 6?",
                                  correctAnswer: false))
        return model
    }
}
