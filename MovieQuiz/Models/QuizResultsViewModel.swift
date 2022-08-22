//
//  QuizResultsViewModel.swift
//  MovieQuiz
//
//  Created by Юрий Демиденко on 22.08.2022.
//

import UIKit

// модель для состояния "Результат квиза"
struct QuizResultsViewModel {
    let title: String
    let text: String
    let buttonText: String

    static func makeModel(for result: Int,
                          _ questionsAmount: Int,
                          _ quizCounter: Int,
                          _ bestQuiz: (score: Int, date: String)) -> QuizResultsViewModel {

        if result == questionsAmount {
            return QuizResultsViewModel(title: "Вы супер киноман!",
                                         text: "Все ответы верные! Такому знактоку надо работать в киноиндустрии. Сколько фильмов вы можете посмотреть в день?\nКоличество сыгранных квизов: \(quizCounter)",
                                         buttonText: "Сыграть ещё раз")
        } else {
            let averageAccuracy = round(Double(result) / Double(questionsAmount) * 100)
            return QuizResultsViewModel(title: "Этот раунд окончен!",
                                         text: "Ваш результат: \(result)/\(questionsAmount)\nКоличество сыгранных квизов: \(quizCounter)\nРекорд: \(bestQuiz.score)/\(questionsAmount) (\(bestQuiz.date))\nСредняя точность: \(Int(averageAccuracy))%",
                                         buttonText: "Сыграть ещё раз")
        }
    }
}
