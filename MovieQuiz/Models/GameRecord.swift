//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Юрий Демиденко on 24.08.2022.
//
// Модель для сохранения результатов одной игры

import UIKit

struct GameRecord: Codable {
    var correct: Int
    var total: Int
    var date: String

    func isWorseThan(currentQuizScore: Int) -> Bool {
        currentQuizScore > correct ? true : false
    }
}
