//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Юрий Демиденко on 27.08.2022.
//

import UIKit

protocol StatisticServiceProtocol {
    var totalAccuracy: Double { get set }
    var gamesCount: Int { get set }
    var bestGame: GameRecord { get }

    func store(correct count: Int, total amount: Int)
}
