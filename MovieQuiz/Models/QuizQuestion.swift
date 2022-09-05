//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by Юрий Демиденко on 22.08.2022.
//

import UIKit

// модель вопроса
struct QuizQuestion {
    let image: Data
    let text: String
    let correctAnswer: Bool

// Формирование модели mock-данных, оставлено для следующего спринта
//    static func makeMockModel() -> [QuizQuestion] {
//        var model = [QuizQuestion]()
//
//        model.append(QuizQuestion(image: "The Godfather",
//                                   text: "Рейтинг этого фильма больше чем 6?",
//                                   correctAnswer: true))
//
//        model.append(QuizQuestion(image: "The Dark Knight",
//                                   text: "Рейтинг этого фильма больше чем 6?",
//                                   correctAnswer: true))
//
//        model.append(QuizQuestion(image: "Kill Bill",
//                                   text: "Рейтинг этого фильма больше чем 6?",
//                                   correctAnswer: true))
//
//        model.append(QuizQuestion(image: "The Avengers",
//                                   text: "Рейтинг этого фильма больше чем 6?",
//                                   correctAnswer: true))
//
//        model.append(QuizQuestion(image: "Deadpool",
//                                   text: "Рейтинг этого фильма больше чем 6?",
//                                   correctAnswer: true))
//
//        model.append(QuizQuestion(image: "The Green Knight",
//                                   text: "Рейтинг этого фильма больше чем 6?",
//                                   correctAnswer: true))
//
//        model.append(QuizQuestion(image: "Old",
//                                   text: "Рейтинг этого фильма больше чем 6?",
//                                   correctAnswer: false))
//
//        model.append(QuizQuestion(image: "The Ice Age Adventures of Buck Wild",
//                                   text: "Рейтинг этого фильма больше чем 6?",
//                                   correctAnswer: false))
//
//        model.append(QuizQuestion(image: "Tesla",
//                                   text: "Рейтинг этого фильма больше чем 6?",
//                                   correctAnswer: false))
//
//        model.append(QuizQuestion(image: "Vivarium",
//                                   text: "Рейтинг этого фильма больше чем 6?",
//                                   correctAnswer: false))
//        return model
//    }
}
